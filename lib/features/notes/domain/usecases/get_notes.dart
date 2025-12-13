import 'package:notes/features/notes/domain/entities/notes_entity.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';

class GetNotes {
  final NotesRepository repository;
  GetNotes({required this.repository});
  Future<List<NotesEntity>> call() => repository.getNotes();
}
