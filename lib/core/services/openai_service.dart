import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final openAIServiceProvider = Provider((ref) => OpenAIService());

class OpenAIService {
  final String? _apiKey = dotenv.env['OPENAI_API_KEY'];

  Future<String> getAIResponse({
    required String userMessage,
    required Map<String, dynamic> guidelines,
  }) async {
    if (_apiKey == null || _apiKey.isEmpty) {
      throw Exception('OpenAI API Key is missing in .env');
    }

    final url = Uri.parse('https://api.openai.com/v1/chat/completions');

    final systemPrompt = '''
You are an AI Medical Assistant for Dentists.
Your primary goal is to provide decision support based STRICTLY on the following clinical guidelines.

*** CLINICAL GUIDELINES (JSON) ***
${jsonEncode(guidelines)}
*** END GUIDELINES ***

INSTRUCTIONS:
1. Analyze the patient case described by the user.
2. Check for any "RED FLAGS" listed in the guidelines. If present, alert immediately.
3. Recommend treatment based on the "conditions" and "antibiotics" sections.
4. If the case is not covered by the guidelines, state that you cannot provide specific advice.
5. Be concise and professional.
''';

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.3, // Low temperature for deterministic behavior
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('OpenAI API Error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }
}
