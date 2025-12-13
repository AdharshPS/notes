import 'package:notes/features/notes/domain/entities/notes_entity.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';

class AddNotes {
  final NotesRepository repository;
  AddNotes(this.repository);
  Future<NotesEntity> call(NotesEntity notes) {
    return repository.addNotes(notes);
  }
}
