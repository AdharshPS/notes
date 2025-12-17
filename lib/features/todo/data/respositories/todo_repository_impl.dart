import 'package:notes/features/todo/data/datasources/todo_data_source.dart';
import 'package:notes/features/todo/data/models/todo_model.dart';
import 'package:notes/features/todo/domain/entities/todo_entity.dart';
import 'package:notes/features/todo/domain/repositories/todo_repositories.dart';

class TodoRepositoryImpl implements TodoRepositories {
  final TodoDataSource todoDS;
  TodoRepositoryImpl(this.todoDS);
  @override
  Future<List<TodoEntity>> getTodos() async {
    final model = await todoDS.getTodos();
    return model.map((e) => e.toEntity()).toList();
  }

  @override
  Future<TodoEntity> addTodo(TodoEntity todo) async {
    final model = TodoModel.fromEntity(todo);
    final response = await todoDS.addTodo(model);
    return response.toEntity();
  }
}
