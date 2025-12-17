import 'package:flutter/material.dart';
import 'package:notes/features/notes/presentation/screens/notes/notes_list_screen.dart';
import 'package:notes/features/todo/presentation/screens/todo_list_screen.dart';

enum Categories { notes, reminders }

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  Categories category = Categories.notes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildScreen(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<Categories>(
              segments: const <ButtonSegment<Categories>>[
                ButtonSegment<Categories>(
                  value: Categories.notes,
                  label: Text('Notes'),
                ),
                ButtonSegment<Categories>(
                  value: Categories.reminders,
                  label: Text('Reminders'),
                ),
              ],
              selected: <Categories>{category},
              onSelectionChanged: (Set<Categories> newSelection) {
                setState(() {
                  category = newSelection.first;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen() {
    switch (category) {
      case Categories.notes:
        return const NotesListScreen(key: ValueKey('notes'));
      case Categories.reminders:
        return const TodoListScreen(key: ValueKey('reminders'));
    }
  }
}
