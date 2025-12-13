import 'package:flutter/material.dart';
import 'package:notes/features/notes/domain/entities/notes_entity.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';
import 'package:notes/features/notes/domain/usecases/add_notes.dart';
import 'package:notes/features/notes/domain/usecases/get_notes.dart';

class NotesProvider extends ChangeNotifier {
  final NotesRepository repo;
  final GetNotes getNotesGC;
  final AddNotes addNotesUC;
  NotesProvider({required this.repo})
    : getNotesGC = GetNotes(repository: repo),
      addNotesUC = AddNotes(repo);
  List<NotesEntity> notes = [];
  bool isLoading = false;
  String? error;

  Future<void> add(NotesEntity note) async {
    isLoading = true;
    notifyListeners();
    try {
      final inserted = await addNotesUC(note); // returns NotesEntity with id
      // update provider cache so UI shows the new note immediately
      notes.insert(0, inserted);
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
      notes = await getNotesGC();
      error = null;
    } catch (e, st) {
      error = e.toString();
      debugPrint('load error: $e\n$st');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
