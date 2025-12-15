import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notes/features/ai/data/datasource/ai_data_sources.dart';
import 'package:notes/features/ai/data/models/ai_model.dart';

class AiDataSourcesImpl implements AiDataSources {
  final String apiKey;
  AiDataSourcesImpl({required this.apiKey});

  @override
  Future<AiModel> generateTitleAndContent({required AiModel aiModel}) async {
    final response = await http.post(
      Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "llama3-8b-8192",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a helpful assistant that outputs ONLY valid JSON.",
          },
          {
            "role": "user",
            "content":
                """
Generate a title and improved content for the following note.

Return ONLY valid JSON in this format:
{
  "title": "string",
  "content": "string"
}

Note:
$aiModel
""",
          },
        ],
        "temperature": 0.3,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Groq API error');
    }

    final data = jsonDecode(response.body);
    print('ai generated response: $data');
    final message = data['choices'][0]['message']['content'];

    final decoded = jsonDecode(message);

    return AiModel(
      title: decoded['title'] ?? '',
      content: decoded['content'] ?? '',
    );
  }
}
