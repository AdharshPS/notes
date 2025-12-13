import 'dart:ui';

import 'package:notes/features/notes/domain/entities/notes_entity.dart';

class NotesModel {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Color? color;
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
}
