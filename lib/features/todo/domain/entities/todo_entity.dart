class TodoEntity {
  final int? id;
  final String title;
  final String? description;
  final DateTime dateTime;
  final bool completed;

  TodoEntity({
    this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.completed = false,
  });
}
