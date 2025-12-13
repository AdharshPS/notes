import 'package:notes/features/notes/data/datasources/notes_local_data_source.dart';
import 'package:notes/features/notes/data/models/notes_model.dart';

class NotesInMemoryDataSource implements NotesLocalDataSource {
  final List<NotesModel> _notesList = [];
  int _auto = 0;

  @override
  Future<NotesModel> addNote(NotesModel note) async {
    _auto++;
    final model = NotesModel(
      id: _auto,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      color: note.color,
      category: note.category,
    );
    _notesList.add(model);
    return model;
  }

  @override
  Future<List<NotesModel>> getNote() async {
    await Future.delayed(Duration(milliseconds: 150));
    return List.unmodifiable(_notesList.reversed);
  }
}
