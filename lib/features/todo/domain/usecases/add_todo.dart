import 'package:notes/features/todo/domain/entities/todo_entity.dart';
import 'package:notes/features/todo/domain/repositories/todo_repositories.dart';

class AddTodo {
  final TodoRepositories repo;
  AddTodo(this.repo);
  Future<TodoEntity> call(TodoEntity todo) => repo.addTodo(todo);
}
