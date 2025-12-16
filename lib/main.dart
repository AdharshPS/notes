import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/features/ai/data/datasource/ai_data_sources_impl.dart';
import 'package:notes/features/ai/data/repositories/ai_repositories_impl.dart';
import 'package:notes/features/ai/data/repositories/disabled_ai_repository_impl.dart';
import 'package:notes/features/ai/domain/repositories/ai_repositories.dart';
import 'package:notes/features/ai/presentation/provider/ai_provider.dart';
import 'package:notes/features/notes/data/datasources/notes_data_source_impl.dart';
import 'package:notes/features/notes/data/models/notes_model.dart';
import 'package:notes/features/notes/data/repositories/note_repository_impl.dart';
import 'package:notes/features/notes/domain/repositories/notes_repository.dart';
import 'package:notes/features/notes/presentation/provider/notes_provider.dart';
import 'package:notes/features/splash/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Hive.initFlutter();
      Hive.registerAdapter(NotesModelAdapter());

      late final Box<NotesModel> notesBox;

      try {
        notesBox = await Hive.openBox<NotesModel>('notes-box');
      } catch (e) {
        debugPrint('❌ Failed to open Hive box: $e');
        rethrow;
      }

      // From envionment
      const bool aiEnabled = bool.fromEnvironment(
        'AI_ENABLED',
        defaultValue: false,
      );
      const String groqApiKey = String.fromEnvironment(
        'GROQ_API_KEY',
        defaultValue: '',
      );

      // --------------Dependency Injection-----------------------
      /// note DI
      final noteDataSource = NotesDataSourceImpl(notesBox);
      final noteRepo = NoteRepositoryImpl(local: noteDataSource);

      /// ai DI
      late final AiRepositories aiRepo;
      if (aiEnabled && groqApiKey.isNotEmpty) {
        final aiDataSource = AiDataSourcesImpl(apiKey: groqApiKey);
        aiRepo = AiRepositoriesImpl(dataSources: aiDataSource);
      } else {
        aiRepo = DisabledAiRepositoryImpl();
      }

      runApp(MainApp(noteRepo: noteRepo, aiRepo: aiRepo));
    },
    (error, stack) {
      debugPrint('❌ Uncaught startup error: $error');
      debugPrintStack(stackTrace: stack);
    },
  );
}

class MainApp extends StatelessWidget {
  final NotesRepository noteRepo;
  final AiRepositories aiRepo;

  const MainApp({required this.noteRepo, super.key, required this.aiRepo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesProvider(repo: noteRepo)..load(),
        ),
        ChangeNotifierProvider(create: (_) => AiProvider(aiRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        home: const SplashScreen(),
      ),
    );
  }
}
