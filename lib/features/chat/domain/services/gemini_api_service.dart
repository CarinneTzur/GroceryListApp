import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String apiKey;
  final String modelName = 'gemini-2.0-flash-exp'; // Latest and fastest model
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  GeminiApiService({required this.apiKey});

  Future<String> sendMessage({
    required String message,
    required List<Map<String, dynamic>> conversationHistory,
    String? systemPrompt,
  }) async {
    try {
      // Prepare messages for the API
      final List<Map<String, dynamic>> contents = [];

      // Add conversation history
      for (var msg in conversationHistory) {
        if (msg['role'] != 'system') {  // Skip system messages in history
          contents.add({
            'role': msg['role'],
            'parts': [{'text': msg['content']}],
          });
        }
      }

      // Add current user message
      contents.add({
        'role': 'user',
        'parts': [{'text': message}],
      });

      // Build the request
      final Map<String, dynamic> requestBody = {
        'contents': contents,
      };

      // Add system instruction if provided
      if (systemPrompt != null && systemPrompt.isNotEmpty) {
        requestBody['system_instruction'] = {
          'parts': [{'text': systemPrompt}],
        };
      }

      // Make API request
      final response = await http.post(
        Uri.parse('$baseUrl/models/$modelName:generateContent?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final content = data['candidates'][0]['content']['parts'][0]['text'];
        return content;
      } else {
        throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get response from Gemini: $e');
    }
  }
}

