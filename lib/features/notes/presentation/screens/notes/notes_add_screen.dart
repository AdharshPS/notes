import 'package:flutter/material.dart';
import 'package:notes/core/color_constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../provider/notes_provider.dart';
import '../../../domain/entities/notes_entity.dart';

class NotesAddScreen extends StatefulWidget {
  final NotesEntity? notes;
  final bool isUpdate;
  const NotesAddScreen({super.key, this.notes, this.isUpdate = false});

  @override
  State<NotesAddScreen> createState() => _NotesAddScreenState();
}

class _NotesAddScreenState extends State<NotesAddScreen> with AppColors {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  int _selectedColor = Colors.white.toARGB32();

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
      _selectedColor = widget.notes?.color ?? Colors.white.toARGB32();
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
          icon: Icon(Icons.close, color: getTextColor(Color(_selectedColor))),
          onPressed: () => Navigator.pop(context),
        ),
        title: Hero(
          tag: 'notes-add',
          child: Text(
            'New Note',
            style: TextStyle(
              color: getTextColor(Color(_selectedColor)),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: getTextColor(Color(_selectedColor))),
            onPressed: _saveNote,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          'Pick Color',
          style: TextStyle(
            color: getTextColor(Color(_selectedColor), inverted: true),
          ),
        ),
        icon: Icon(
          Icons.palette_outlined,
          color: getTextColor(Color(_selectedColor), inverted: true),
        ),
        backgroundColor: getTextColor(Color(_selectedColor)),
        onPressed: () async {
          final pickedColor = await _showColorPicker(
            context,
            Color(_selectedColor),
          );
          _selectedColor = pickedColor != null
              ? pickedColor.toARGB32()
              : Colors.white.toARGB32();
        },
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
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
        hintStyle: TextStyle(color: getTextColor(Color(_selectedColor))),
      ),
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: getTextColor(Color(_selectedColor)),
      ),
    );
  }

  Widget _buildContentField() {
    return Expanded(
      child: TextField(
        controller: _contentController,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          hintText: 'Write your note here...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: getTextColor(Color(_selectedColor))),
        ),
        style: TextStyle(
          fontSize: 16,
          color: getTextColor(Color(_selectedColor)),
        ),
      ),
    );
  }

  Future<Color?> _showColorPicker(BuildContext context, Color currentColor) {
    Color pickerColor = currentColor;

    // ValueChanged<Color> callback
    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    // raise the [showDialog] widget
    return showDialog<Color?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop(pickerColor);
            },
          ),
        ],
      ),
    );
  }
}
