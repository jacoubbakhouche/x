import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to access the repository
final guidelinesRepositoryProvider = Provider((ref) => GuidelinesRepository());

class GuidelinesRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchGuidelines() async {
    try {
      final response = await _client
          .from('clinical_guidelines')
          .select('rules')
          .limit(1)
          .single();

      return response['rules'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load guidelines: $e');
    }
  }
}
