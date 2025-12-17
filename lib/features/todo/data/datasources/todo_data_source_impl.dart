import 'package:hive_flutter/adapters.dart';
import 'package:notes/features/todo/data/datasources/todo_data_source.dart';
import 'package:notes/features/todo/data/models/todo_model.dart';

class TodoDataSourceImpl implements TodoDataSource {
  final Box<TodoModel> box;
  TodoDataSourceImpl(this.box);

  List<TodoModel> todoList = [];

  @override
  Future<List<TodoModel>> getTodos() async {
    todoList = box.values.toList().reversed.toList();
    return List.unmodifiable(todoList);
  }

  @override
  Future<TodoModel> addTodo(TodoModel todo) async {
    int key = await box.add(todo);
    final item = todo.copyWith(id: key);
    await box.put(key, item);
    return item;
  }
}
