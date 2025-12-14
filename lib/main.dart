import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/core/app/app_life_cycle_observer.dart';
import 'package:notes/features/applock/data/datasources/app_lock_data_source_impl.dart';
import 'package:notes/features/applock/data/repositories/app_lock_repository_impl.dart';
import 'package:notes/features/applock/presentation/provider/app_lock_provider.dart';
import 'package:notes/features/notes/data/datasources/notes_data_source_impl.dart';
import 'package:notes/features/notes/data/models/notes_model.dart';
import 'package:notes/features/notes/data/repositories/note_repository_impl.dart';
import 'package:notes/features/notes/presentation/provider/notes_provider.dart';
import 'package:notes/features/splash/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NotesModelAdapter());
  final LocalAuthentication auth = LocalAuthentication();

  var notesBox = await Hive.openBox<NotesModel>('notes-box');
  // 4️⃣ Dependency Injection
  final noteDataSource = NotesDataSourceImpl(notesBox);
  final noteRepo = NoteRepositoryImpl(local: noteDataSource);
  final appLockDataSource = AppLockDataSourceImpl(auth);
  final appLockRepo = AppLockRepositoryImpl(appLockDataSource);

  final authProvider = AppLockProvider(appLockRepo)..checkBiometrics();

  // ---------- App lifecycle observer ----------
  WidgetsBinding.instance.addObserver(AppLifecycleObserver(authProvider));

  runApp(MainApp(noteRepo: noteRepo, appLockRepo: appLockRepo));
}

class MainApp extends StatelessWidget {
  final NoteRepositoryImpl noteRepo;
  final AppLockRepositoryImpl appLockRepo;

  const MainApp({required this.noteRepo, super.key, required this.appLockRepo});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NotesProvider(repo: noteRepo)..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppLockProvider(appLockRepo),
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
