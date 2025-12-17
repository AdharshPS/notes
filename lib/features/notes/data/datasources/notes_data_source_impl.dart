import 'package:hive/hive.dart';
import 'package:notes/features/notes/data/datasources/notes_local_data_source.dart';
import 'package:notes/features/notes/data/models/notes_model.dart';

class NotesDataSourceImpl implements NotesLocalDataSource {
  final Box<NotesModel> box;
  NotesDataSourceImpl(this.box);

  @override
  Future<NotesModel> addNote(NotesModel note) async {
    final key = await box.add(note);
    final saved = note.copyWith(id: key);
    await box.put(key, saved);
    return saved;
  }

  @override
  Future<List<NotesModel>> getNote() async {
    return List.unmodifiable(box.values.toList().reversed.toList());
  }

  @override
  Future<NotesModel> updateNote(NotesModel note) async {
    if (note.id == null) {
      throw Exception('No key found');
    }
    box.put(note.id, note);
    return note;
  }

  @override
  Future<void> deleteNote(int key) async {
    final note = box.get(key);
    if (note != null) {
      await note.delete();
    }
  }
}
