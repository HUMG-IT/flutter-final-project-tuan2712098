import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_api_service.dart';

class NoteProvider extends ChangeNotifier {
  final NoteApiService apiService;

  NoteProvider({required this.apiService});

  final List<Note> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Note> get notes => List.unmodifiable(_notes);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await apiService.fetchNotes();
      _notes
        ..clear()
        ..addAll(result.reversed);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ tạo note mặc định DONE luôn
  Future<void> addNote({
    required String title,
    required String content,
    required int color,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final newNote = Note(
        id: '',
        title: title,
        content: content,
        isDone: true, // ✅ DONE luôn sau khi lưu
        createdAt: DateTime.now(),
        color: color,
      );

      final created = await apiService.createNote(newNote);
      _notes.insert(0, created);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateNote(Note updated) async {
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await apiService.updateNote(updated);
      final index = _notes.indexWhere((n) => n.id == updated.id);
      if (index != -1) _notes[index] = result;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteNote(Note note) async {
    _errorMessage = null;

    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) return;

    final backup = _notes[index];
    _notes.removeAt(index);
    notifyListeners();

    try {
      await apiService.deleteNote(note.id);
    } catch (e) {
      _notes.insert(index, backup);
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> toggleDone(Note note) async {
    final updated = note.copyWith(isDone: !note.isDone);
    await updateNote(updated);
  }
}
