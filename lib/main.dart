import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/core/notification/notification_service.dart';
import 'package:notes/core/notification/timezone_initializer.dart';
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
import 'package:notes/features/todo/data/datasources/todo_data_source_impl.dart';
import 'package:notes/features/todo/data/datasources/todo_notification_ds.dart';
import 'package:notes/features/todo/data/models/todo_model.dart';
import 'package:notes/features/todo/data/respositories/todo_repository_impl.dart';
import 'package:notes/features/todo/domain/repositories/todo_repositories.dart';
import 'package:notes/features/todo/presentation/provider/todo_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  await TimezoneInitializer.timeZoneInit();

  // Hive Initialization
  await Hive.initFlutter();
  Hive.registerAdapter(NotesModelAdapter());
  Hive.registerAdapter(TodoModelAdapter());

  late final Box<NotesModel> notesBox;
  late final Box<TodoModel> todoBox;

  try {
    notesBox = await Hive.openBox<NotesModel>('notes-box');
    todoBox = await Hive.openBox<TodoModel>('todo-box');
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

  // Local notification initialization
  await NotificationService.init();
  await NotificationService.registerChannel();

  final scheduler = TodoNotificationDataSource(
    plugin: NotificationService.flutterLocalNotificationPlugin,
    notificationDetails: NotificationService.notificationDetails,
  );

  /// todo DI
  final todoDs = TodoDataSourceImpl(box: todoBox, scheduler: scheduler);
  final todoRepo = TodoRepositoryImpl(todoDs);

  runApp(MainApp(noteRepo: noteRepo, aiRepo: aiRepo, todoRepo: todoRepo));
}

class MainApp extends StatelessWidget {
  final NotesRepository noteRepo;
  final AiRepositories aiRepo;
  final TodoRepositories todoRepo;

  const MainApp({
    required this.noteRepo,
    super.key,
    required this.aiRepo,
    required this.todoRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotesProvider(repo: noteRepo)..load(),
        ),
        ChangeNotifierProvider(create: (_) => AiProvider(aiRepo)),
        ChangeNotifierProvider(create: (_) => TodoProvider(todoRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
