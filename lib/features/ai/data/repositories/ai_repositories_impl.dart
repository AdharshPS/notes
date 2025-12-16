import 'package:notes/features/ai/data/datasource/ai_data_sources.dart';
import 'package:notes/features/ai/data/models/ai_model.dart';
import 'package:notes/features/ai/domain/entities/ai_entity.dart';
import 'package:notes/features/ai/domain/repositories/ai_repositories.dart';

class AiRepositoriesImpl implements AiRepositories {
  final AiDataSources dataSources;
  AiRepositoriesImpl({required this.dataSources});

  @override
  Future<AiEntity> generateTitleAndContent(AiEntity entity) async {
    final model = AiModel.fromEntity(entity);
    final result = await dataSources.generateTitleAndContent(aiModel: model);
    return result.toEntity();
  }
}
