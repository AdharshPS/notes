import 'package:notes/features/notes/data/models/notes_model.dart';

abstract class NotesLocalDataSource {
  Future<NotesModel> addNote(NotesModel note);
  Future<List<NotesModel>> getNote();
  Future<NotesModel> updateNote(NotesModel note);
  Future<void> deleteNote(int key);
}
