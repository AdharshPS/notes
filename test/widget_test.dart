// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes/core/app/app_life_cycle_observer.dart';
import 'package:notes/features/applock/data/datasources/app_lock_data_source_impl.dart';
import 'package:notes/features/applock/data/repositories/app_lock_repository_impl.dart';
import 'package:notes/features/applock/presentation/provider/app_lock_provider.dart';
import 'package:notes/features/notes/data/datasources/notes_data_source_impl.dart';
import 'package:notes/features/notes/data/models/notes_model.dart';
import 'package:notes/features/notes/data/repositories/note_repository_impl.dart';

import 'package:notes/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(NotesModelAdapter());
    final LocalAuthentication auth = LocalAuthentication();

    var notesBox = await Hive.openBox<NotesModel>('notes-box');

    final noteDataSource = NotesDataSourceImpl(notesBox);
    final noteRepo = NoteRepositoryImpl(local: noteDataSource);
    final appLockDataSource = AppLockDataSourceImpl(auth);
    final appLockRepo = AppLockRepositoryImpl(appLockDataSource);

    final authProvider = AppLockProvider(appLockRepo)..checkBiometrics();

    // ---------- App lifecycle observer ----------
    WidgetsBinding.instance.addObserver(AppLifecycleObserver(authProvider));

    runApp(MainApp(noteRepo: noteRepo, appLockRepo: appLockRepo));

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MainApp(noteRepo: noteRepo, appLockRepo: appLockRepo),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
