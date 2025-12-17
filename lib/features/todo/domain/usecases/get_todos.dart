import 'package:notes/features/todo/domain/entities/todo_entity.dart';
import 'package:notes/features/todo/domain/repositories/todo_repositories.dart';

class GetTodos {
  final TodoRepositories repo;
  GetTodos(this.repo);
  Future<List<TodoEntity>> call() => repo.getTodos();
}
