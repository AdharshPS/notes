import 'package:flutter/material.dart';
import 'package:notes/features/notes/domain/entities/notes_entity.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';
import 'package:notes/features/notes/domain/usecases/add_notes.dart';
import 'package:notes/features/notes/domain/usecases/delete_notes.dart';
import 'package:notes/features/notes/domain/usecases/get_notes.dart';
import 'package:notes/features/notes/domain/usecases/update_notes.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository repo;
  final GetNotes _getNotes;
  final AddNotes _addNotes;
  final UpdateNotes _updateNotes;
  final DeleteNotes _deleteNotes;

  NotesProvider({required this.repo})
    : _getNotes = GetNotes(repository: repo),
      _addNotes = AddNotes(repo),
      _updateNotes = UpdateNotes(repo),
      _deleteNotes = DeleteNotes(repo);
  List<NotesEntity> notesList = [];
  int _auto = 0;
  bool isLoading = false;
  String? error;

  Future<void> add(NotesEntity note) async {
    isLoading = true;
    notifyListeners();
    _auto++;
    try {
      final model = NotesEntity(
        id: _auto,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        category: note.category,
        color: note.color,
      );
      final inserted = await _addNotes(model);
      notesList = [inserted, ...notesList];
      error = null;
    } catch (e, st) {
      error = e.toString();
      debugPrint('add error: $e\n$st');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      notesList = await _getNotes();
      error = null;
    } catch (e, st) {
      error = e.toString();
      debugPrint('load error: $e\n$st');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(NotesEntity note) async {
    isLoading = true;
    notifyListeners();
    try {
      final updates = await _updateNotes(note);
      final index = notesList.indexWhere((element) => element.id == updates.id);
      notesList[index] = updates;
    } catch (e, st) {
      error = e.toString();
      debugPrint('load error: $e\n$st');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      await _deleteNotes(id);
      notesList.removeWhere((element) => element.id == id);
    } catch (e, st) {
      error = e.toString();
      debugPrint('load error: $e\n$st');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
