import 'package:flutter/material.dart';
import 'package:notes/core/extensions/date_format_extension.dart';
import 'package:provider/provider.dart';
import '../provider/todo_provider.dart';
import 'todo_add_screen.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<TodoProvider>().getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'My Reminders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : Consumer<TodoProvider>(
              builder: (context, consumer, child) {
                return consumer.todoList.isEmpty
                    ? const Center(child: Text("No todos yet"))
                    : ListView.builder(
                        itemCount: consumer.todoList.length,
                        itemBuilder: (context, index) {
                          final todo = consumer.todoList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(
                                todo.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (todo.description != null &&
                                      todo.description!.isNotEmpty)
                                    Text(
                                      todo.description!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        height: 1.4,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "⏰ ${todo.dateTime.toLocal().formatForReminders}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TodoAddScreen()),
          );
        },
        heroTag: 'add-reminder',
        label: Text('New Reminder'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
