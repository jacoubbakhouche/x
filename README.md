# HealthLink AI Consultation

A modern Flutter web application designed for healthcare professionals.

## Features
- **AI Consultation**: Intelligent medical assistant using Groq AI (Llama 3).
- **Clinical Guidelines**: Strictly follows JSON-based medical rules.
- **Modern Dashboard**: Dark theme with glassmorphism effects.
- **Supabase Backend**: Secure data storage and Edge Functions.

## Setup
1. Clone the repository.
2. Create a `.env` file with:
   ```
   SUPABASE_URL=your_url
   SUPABASE_ANON_KEY=your_key
   ```
3. Run `flutter pub get`.
4. Run `flutter run -d chrome`.

## Deployment
This app is ready for Vercel deployment. Ensure you add the `.env` variables in Vercel settings.
