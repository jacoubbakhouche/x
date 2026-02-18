
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consultationServiceProvider = Provider((ref) => ConsultationService());

class ConsultationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> sendQuery(String query, List<Map<String, String>> history) async {
    try {
      final response = await _client.functions.invoke(
        'chat-consultation',
        body: {
          'query': query,
          'history': history,
        },
      );

      final data = response.data as Map<String, dynamic>;
      
      if (data.containsKey('error')) {
         throw Exception(data['error']);
      }

      return data['response'] as String;
    } catch (e) {
      throw Exception('Failed to get consultation response: $e');
    }
  }
}
