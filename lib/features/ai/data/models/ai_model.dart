import 'package:notes/features/ai/domain/entities/ai_entity.dart';

class AiModel {
  final String? title;
  final String? content;
  AiModel({required this.title, required this.content});

  AiEntity toEntity() => AiEntity(title: title, content: content);

  factory AiModel.fromEntity(AiEntity aiEntity) =>
      AiModel(title: aiEntity.title, content: aiEntity.content);

  AiModel copyWith({String? title, String? content}) =>
      AiModel(title: title ?? this.title, content: content ?? this.content);
}
