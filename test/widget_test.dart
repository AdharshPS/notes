// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:notes/features/notes/data/datasources/notes_data_source_impl.dart';
// import 'package:notes/features/notes/data/models/notes_model.dart';
// import 'package:notes/features/notes/data/repositories/note_repository_impl.dart';

// import 'package:notes/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     var path = Directory.current.path;
//     Hive
//       ..init(path)
//       ..registerAdapter(NotesModelAdapter());

//     var notesBox = await Hive.openBox<NotesModel>('notes-box');

//     final dataSource = NotesDataSourceImpl(notesBox);
//     final repo = NoteRepositoryImpl(local: dataSource);

//     // Build our app and trigger a frame.
//     await tester.pumpWidget(MainApp(noteRepo: repo));

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
