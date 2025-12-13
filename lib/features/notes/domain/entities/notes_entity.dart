import 'dart:ui';

class NotesEntity {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Color? color;
  final String? category;

  NotesEntity({
    this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.color,
    this.category,
  });
}
