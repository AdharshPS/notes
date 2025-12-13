import 'package:hive/hive.dart';
import 'package:notes/features/notes/domain/entities/notes_entity.dart';
part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NotesModel extends HiveObject {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? content;
  @HiveField(3)
  final DateTime? createdAt;
  @HiveField(4)
  final DateTime? updatedAt;
  @HiveField(5)
  final int? color;
  @HiveField(6)
  final String? category;

  NotesModel({
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.color,
    this.category,
  });

  NotesEntity toEntity() => NotesEntity(
    id: id,
    title: title,
    content: content,
    createdAt: createdAt,
    updatedAt: updatedAt,
    color: color,
    category: category,
  );

  factory NotesModel.fromEntity(NotesEntity note) => NotesModel(
    id: note.id,
    title: note.title,
    content: note.content,
    createdAt: note.createdAt,
    updatedAt: note.updatedAt,
    color: note.color,
    category: note.category,
  );

  NotesModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? updatedAt,
    int? color,
  }) {
    return NotesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      color: color ?? this.color,
    );
  }
}
