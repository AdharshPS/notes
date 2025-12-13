import 'package:notes/features/notes/data/datasources/notes_local_data_source.dart';
import 'package:notes/features/notes/data/models/notes_model.dart';
import 'package:notes/features/notes/domain/entities/notes_entity.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';

class NoteRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource local;
  NoteRepositoryImpl({required this.local});

  @override
  Future<NotesEntity> addNotes(NotesEntity notes) async {
    final model = NotesModel.fromEntity(notes);
    final inserted = await local.addNote(model);
    return inserted.toEntity();
  }

  @override
  Future<List<NotesEntity>> getNotes() async {
    final model = await local.getNote();
    return model.map((e) => e.toEntity()).toList();
  }
}
