import 'package:flutter/material.dart';
import 'package:notes/features/todo/domain/entities/todo_entity.dart';
import 'package:notes/features/todo/domain/repositories/todo_repositories.dart';
import 'package:notes/features/todo/domain/usecases/add_todo.dart';
import 'package:notes/features/todo/domain/usecases/get_todos.dart';

class TodoProvider with ChangeNotifier {
  final TodoRepositories repo;
  final GetTodos _getTodos;
  final AddTodo _addTodo;
  TodoProvider(this.repo)
    : _getTodos = GetTodos(repo),
      _addTodo = AddTodo(repo);

  List<TodoEntity> todoList = [];
  String? error;
  bool isLoading = false;

  Future<void> addTodo(TodoEntity todo) async {
    try {
      isLoading = true;
      notifyListeners();
      await _addTodo(todo);
      todoList = await _getTodos();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTodos() async {
    try {
      isLoading = true;
      notifyListeners();
      todoList = await _getTodos();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
