import 'package:notes/features/todo/domain/entities/todo_entity.dart';

abstract class TodoRepositories {
  Future<List<TodoEntity>> getTodos();
  Future<TodoEntity> addTodo(TodoEntity todo);
}
