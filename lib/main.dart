import 'package:flutter/material.dart';
import 'package:notes/features/notes/data/datasources/notes_in_memory.dart';
import 'package:notes/features/notes/data/repositories/note_repository_impl.dart';
import 'package:notes/features/notes/presentation/provider/notes_provider.dart';
import 'package:notes/features/notes/presentation/screens/notes_clean.dart';
import 'package:notes/features/notes/presentation/screens/notes_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final dataSource = NotesInMemoryDataSource();
  final repo = NoteRepositoryImpl(local: dataSource);
  runApp(MainApp(repo: repo));
}

class MainApp extends StatelessWidget {
  final NoteRepositoryImpl repo;

  const MainApp({required this.repo, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesProvider(repo: repo)..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        home: NotesListPage(),
      ),
    );
  }
}
