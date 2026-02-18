
// @ts-ignore
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
// @ts-ignore
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req: Request) => {
    // Handle CORS preflight request
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders });
    }

    try {
        console.log("Request received"); // Debug Log

        // Parse Body with fallback
        let body;
        try {
            body = await req.json();
        } catch (e) {
            console.error("Invalid JSON body", e);
            throw new Error("Invalid JSON body");
        }

        const { query, history = [] } = body;
        console.log("Query:", query); // Debug Log

        if (!query) throw new Error("Query is missing");

        // 1. Initialize Supabase Client (Admin/Service Role to bypass RLS for system guidelines)
        const supabaseUrl = Deno.env.get('SUPABASE_URL');
        const supabaseServiceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY'); // Use Service Role!
        const groqApiKey = Deno.env.get('GROQ_API_KEY');

        if (!supabaseUrl || !supabaseServiceRoleKey || !groqApiKey) {
            console.error("Missing Environment Variables");
            throw new Error("Server Misconfiguration: Missing API Keys");
        }

        const supabaseClient = createClient(
            supabaseUrl,
            supabaseServiceRoleKey
            // No global headers needed for Service Role
        );

        // 2. Fetch Clinical Guidelines
        console.log("Fetching guidelines...");
        const { data: guidelines, error: dbError } = await supabaseClient
            .from('clinical_guidelines')
            .select('rules')
            .limit(1)
            .single();

        if (dbError) {
            console.error("Database Error:", dbError);
            // Verify table exists and RLS allows reading
            // But we proceed with empty rules if failed to unblock chat
        }

        const rules = guidelines?.rules || {};
        console.log("Guidelines loaded.", Object.keys(rules).length > 0 ? "Found rules" : "No rules found");

        // 3. Construct System Prompt
        const systemPrompt = `
You are a smart medical assistant. Your answers must depend **ONLY** on the rules found in the attached JSON Guidelines.

*** CLINICAL GUIDELINES (JSON) ***
${JSON.stringify(rules)}
*** END GUIDELINES ***

CRITICAL INSTRUCTIONS:
1. **Adherence:** Your answers must depend **ONLY** on the rules found in the \`Antibiotiques dentaires.json\` file content provided above. Do not use external medical knowledge.
2. **Priority:** Always remind the doctor that **controlling the source of infection (treating the tooth/cause)** is the TOP PRIORITY before prescribing any antibiotic.
3. **Red Flags:** Before proposing ANY treatment, you MUST ask the doctor about the presence of **Red Flags** such as:
    - Fever (Fièvre)
    - Facial Swelling (Cellulite faciale)
    - Difficulty Swallowing (Dysphagie)
    - Trismus (Difficulty opening mouth)
4. **Dosage Precision:** Where applicable, use exact dosages from the rules.
5. **Allergies:** Check for alternatives if allergies are mentioned.
6. **Language:** Respond in the language of the user.
`;

        // 4. Call Groq AI API
        console.log("Calling Groq AI...");
        const groqResponse = await fetch('https://api.groq.com/openai/v1/chat/completions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${groqApiKey}`,
            },
            body: JSON.stringify({
                model: 'llama3-8b-8192',
                messages: [
                    { role: 'system', content: systemPrompt },
                    ...history,
                    { role: 'user', content: query },
                ],
                temperature: 0.1,
            }),
        });

        const aiData = await groqResponse.json();

        if (aiData.error) {
            console.error("Groq API Error:", aiData.error);
            throw new Error(`Groq API Error: ${aiData.error.message}`);
        }

        const aiMessage = aiData.choices?.[0]?.message?.content;

        if (!aiMessage) {
            console.error("Empty response from Groq", aiData);
            throw new Error("Empty response from AI");
        }

        console.log("AI Response received successfully");

        return new Response(
            JSON.stringify({ response: aiMessage }),
            { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
        );

    } catch (error) {
        console.error("Function Error:", error.message);
        return new Response(
            JSON.stringify({ error: error.message }),
            { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
        );
    }
});
