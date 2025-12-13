import 'package:flutter/material.dart';
import 'package:notes/features/notes/domain/entities/notes_entity.dart';
import 'package:provider/provider.dart';
import 'package:notes/features/notes/presentation/provider/notes_provider.dart';

class NotesClean extends StatelessWidget {
  const NotesClean({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<NotesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Notes Add Screen')),
      body: prov.isLoading
          ? Center(child: CircularProgressIndicator())
          : prov.notes.isEmpty
          ? Center(child: Text('No notes'))
          : ListView.builder(
              itemCount: prov.notes.length,
              itemBuilder: (_, i) {
                final n = prov.notes[i];
                return ListTile(
                  title: Text(n.title ?? ''),
                  subtitle: Text(n.content ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // prov.delete(n.id!),
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final now = DateTime.now();
          final note = NotesEntity(
            title: 'Note ${prov.notes.length + 1}',
            content: 'Content ${now.toIso8601String()}',
            createdAt: now,
            updatedAt: now,
          );
          await prov.add(note);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
