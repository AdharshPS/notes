import 'package:notes/features/ai/domain/entities/ai_entity.dart';

abstract class AiRepositories {
  Future<AiEntity> generateTitleAndContent(AiEntity entity);
}
