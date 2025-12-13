import 'package:notes/features/notes/domain/entities/notes_entity.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';

class UpdateNotes {
  final NotesRepository repository;
  UpdateNotes(this.repository);
  Future<NotesEntity> call(NotesEntity note) => repository.updateNotes(note);
}
