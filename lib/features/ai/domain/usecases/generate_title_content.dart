import 'package:notes/features/ai/domain/entities/ai_entity.dart';
import 'package:notes/features/ai/domain/repositories/ai_repositories.dart';

class GenerateTitleAndContent {
  final AiRepositories repo;
  GenerateTitleAndContent(this.repo);
  Future<AiEntity> call(AiEntity entity) =>
      repo.generateTitleAndContent(entity);
}
