import 'package:flutter/material.dart';
import 'package:notes/features/ai/domain/entities/ai_entity.dart';
import 'package:notes/features/ai/domain/repositories/ai_repositories.dart';
import 'package:notes/features/ai/domain/usecases/generate_title_content.dart';

class AiProvider with ChangeNotifier {
  final AiRepositories repo;
  final GenerateTitleAndContent _generateTitleAndContent;
  AiProvider(this.repo)
    : _generateTitleAndContent = GenerateTitleAndContent(repo);

  AiEntity? generatedNote;
  bool isLoading = false;
  String? error;

  // Calling the ai function
  Future<void> generateNote({String? title, String? content}) async {
    try {
      isLoading = true;
      notifyListeners();
      generatedNote = await _generateTitleAndContent(
        AiEntity(title: title, content: content),
      );
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
