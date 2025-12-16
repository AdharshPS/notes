import 'package:notes/features/ai/domain/entities/ai_entity.dart';
import 'package:notes/features/ai/domain/repositories/ai_repositories.dart';

class DisabledAiRepositoryImpl implements AiRepositories {
  @override
  Future<AiEntity> generateTitleAndContent(AiEntity entity) {
    throw UnsupportedError('AI is disabled in this build');
  }
}
