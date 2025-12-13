import 'package:notes/features/notes/domain/repositories/notes_repository.dart';

class DeleteNotes {
  final NotesRepository repo;
  DeleteNotes(this.repo);
  Future<void> call(int key) => repo.deleteNotes(key);
}
