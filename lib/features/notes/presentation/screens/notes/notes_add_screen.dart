import 'package:flutter/material.dart';
import 'package:notes/features/ai/presentation/provider/ai_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/notes_provider.dart';
import '../../../domain/entities/notes_entity.dart';

class NotesAddScreen extends StatefulWidget {
  final NotesEntity? notes;
  final bool isUpdate;
  const NotesAddScreen({super.key, this.notes, this.isUpdate = false});

  @override
  State<NotesAddScreen> createState() => _NotesAddScreenState();
}

class _NotesAddScreenState extends State<NotesAddScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  int _selectedColor = _noteColors.first.toARGB32();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final note = NotesEntity(
      id: widget.isUpdate ? widget.notes?.id : null,
      title: title,
      content: content,
      createdAt: widget.isUpdate ? widget.notes?.createdAt : DateTime.now(),
      updatedAt: widget.isUpdate ? DateTime.now() : null,
      color: _selectedColor,
      category: null, // optional
    );

    widget.isUpdate
        ? await context.read<NotesProvider>().update(note)
        : await context.read<NotesProvider>().add(note);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.notes != null) {
      _titleController.text = widget.notes?.title ?? '';
      _contentController.text = widget.notes?.content ?? '';
      _selectedColor = widget.notes?.color ?? _noteColors.first.toARGB32();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(_selectedColor),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Hero(
          tag: 'notes-add',
          child: const Text(
            'New Note',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          Tooltip(
            message: 'Generate corrected Note using AI',
            triggerMode: TooltipTriggerMode.tap,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: const Text(
                'i',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final provider = context.read<AiProvider>();
              await provider.generateNote(
                title: _titleController.text.trim(),
                content: _contentController.text.trim(),
              );
              if (!context.mounted) return;
              await _showAiResultDialog(
                context,
                title: provider.generatedNote?.title,
                content: provider.generatedNote?.content,
                onUse: () {
                  setState(() {
                    _titleController.text = provider.generatedNote?.title ?? '';
                    _contentController.text =
                        provider.generatedNote?.content ?? '';
                  });
                },
              );
            },
            child: Text('generate'),
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.black),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTitleField(),
                  const SizedBox(height: 12),
                  _buildContentField(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildColorPicker(),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
      ),
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildContentField() {
    return Expanded(
      child: TextField(
        controller: _contentController,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: 'Write your note here...',
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Row(
      children: [
        ..._noteColors.map((color) {
          // final isSelected = color == _selectedColor;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedColor = color.toARGB32());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _showAiResultDialog(
    BuildContext context, {
    required String? title,
    required String? content,
    VoidCallback? onUse,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'AI Suggestion',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Content',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content ?? '',
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onUse?.call();
            },
            child: const Text('Use'),
          ),
        ],
      ),
    );
  }
}

const List<Color> _noteColors = [
  Color(0xFFFFF59D),
  Color(0xFFFFCCBC),
  Color(0xFFB2EBF2),
  Color(0xFFC8E6C9),
  Color(0xFFD1C4E9),
];
