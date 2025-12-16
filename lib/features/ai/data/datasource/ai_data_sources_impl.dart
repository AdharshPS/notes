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
        "model": "llama-3.1-8b-instant",
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
You are given a note with a title and content.

Your task:
- Rewrite and improve the note
- Do NOT change the topic
- Do NOT introduce new ideas
- Do NOT add explanations
- Keep the meaning the same
- Improve clarity and wording only
- Correct the spelling mistakes and grammer
- If there is no title, create a title based on the content
- If there is no content, create a sample content based on title

Return ONLY valid JSON in this exact format:
{
  "title": "string",
  "content": "string"
}

Input note:
Title: ${aiModel.title}
Content: ${aiModel.content}
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
    final message = data['choices'][0]['message']['content'];
    final decoded = jsonDecode(message);

    return AiModel(
      title: decoded['title'] ?? '',
      content: decoded['content'] ?? '',
    );
  }
}
