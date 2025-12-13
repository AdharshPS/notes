import 'package:notes/features/notes/domain/entities/notes_entity.dart';

abstract class NotesRepository {
  Future<NotesEntity> addNotes(NotesEntity notes);
  Future<List<NotesEntity>> getNotes();
}
