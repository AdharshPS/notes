class NotesEntity {
  final int? id;
  final String? title;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? color;
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
