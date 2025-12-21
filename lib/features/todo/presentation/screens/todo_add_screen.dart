import 'package:flutter/material.dart';
import 'package:notes/features/todo/domain/entities/todo_entity.dart';
import 'package:provider/provider.dart';
import '../provider/todo_provider.dart';

class TodoAddScreen extends StatefulWidget {
  const TodoAddScreen({super.key});

  @override
  State<TodoAddScreen> createState() => _TodoAddScreenState();
}

class _TodoAddScreenState extends State<TodoAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Hero(
          tag: 'add-reminder',
          child: const Text(
            "Add Reminder",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// 🔼 EDITOR AREA
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTitleField(),
                      const SizedBox(height: 12),
                      _buildDescriptionField(),
                    ],
                  ),
                ),
              ),

              /// 🔽 BOTTOM BAR
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        hintText: 'Reminder title',
        border: InputBorder.none,
      ),
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      validator: (v) => v == null || v.trim().isEmpty ? 'Title required' : null,
    );
  }

  Widget _buildDescriptionField() {
    return Expanded(
      child: TextFormField(
        controller: _descController,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: 'Description (optional)',
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Date & Time Picker
          Expanded(
            child: InkWell(
              onTap: _pickDateTime,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedDateTime == null
                      ? 'Pick date & time'
                      : _selectedDateTime.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Save Button
          ElevatedButton(onPressed: _onSave, child: const Text('Save')),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date & time')),
      );
      return;
    }

    final todo = TodoEntity(
      title: _titleController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      dateTime: _selectedDateTime!.toLocal(),
    );

    await context.read<TodoProvider>().addTodo(todo);

    if (!mounted) return;
    Navigator.pop(context);
  }
}
