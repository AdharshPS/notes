import 'package:notes/features/todo/data/models/todo_model.dart';

abstract class TodoDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> addTodo(TodoModel todo);
}
