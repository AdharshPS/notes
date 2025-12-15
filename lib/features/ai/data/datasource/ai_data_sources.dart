import 'package:notes/features/ai/data/models/ai_model.dart';

abstract class AiDataSources {
  Future<AiModel> generateTitleAndContent({required AiModel aiModel});
}
