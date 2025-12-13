import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/features/notes/data/datasources/notes_data_source_impl.dart';
import 'package:notes/features/notes/data/models/notes_model.dart';
import 'package:notes/features/notes/data/repositories/note_repository_impl.dart';
import 'package:notes/features/notes/presentation/provider/notes_provider.dart';
import 'package:notes/features/notes/presentation/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesModelAdapter());

  var notesBox = await Hive.openBox<NotesModel>('notes-box');
  // 4️⃣ Dependency Injection
  final dataSource = NotesDataSourceImpl(notesBox);
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
        home: const SplashScreen(),
      ),
    );
  }
}
