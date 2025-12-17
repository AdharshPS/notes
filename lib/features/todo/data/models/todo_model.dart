import 'package:hive/hive.dart';
import 'package:notes/features/todo/domain/entities/todo_entity.dart';
part 'todo_model.g.dart';

@HiveType(typeId: 1)
class TodoModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final DateTime dateTime;
  @HiveField(4)
  final bool completed;

  TodoModel({
    required this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.completed = false,
  });

  TodoEntity toEntity() => TodoEntity(
    id: id,
    title: title,
    description: description,
    dateTime: dateTime,
    completed: completed,
  );

  factory TodoModel.fromEntity(TodoEntity todo) => TodoModel(
    id: todo.id,
    title: todo.title,
    description: todo.description,
    dateTime: todo.dateTime,
    completed: todo.completed,
  );

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dateTime,
    bool? completed,
  }) => TodoModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    dateTime: dateTime ?? this.dateTime,
    completed: completed ?? this.completed,
  );
}
