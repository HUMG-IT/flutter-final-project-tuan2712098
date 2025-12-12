import 'package:notes_app/models/note.dart';
import 'package:notes_app/services/note_api_service.dart';

class FakeNoteApiService extends NoteApiService {
  final List<Note> _store;
  int _idCounter;

  FakeNoteApiService({List<Note>? seed})
    : _store = List<Note>.from(seed ?? const []),
      _idCounter = 1000;

  @override
  Future<List<Note>> fetchNotes() async {
    return List<Note>.from(_store);
  }

  @override
  Future<Note> createNote(Note note) async {
    final created = Note(
      id: (++_idCounter).toString(),
      title: note.title,
      content: note.content,
      isDone: note.isDone,
      createdAt: note.createdAt,
      color: note.color,
    );
    _store.add(created);
    return created;
  }

  @override
  Future<Note> updateNote(Note note) async {
    final idx = _store.indexWhere((n) => n.id == note.id);
    if (idx == -1) throw Exception('Note not found');
    _store[idx] = note;
    return note;
  }

  @override
  Future<void> deleteNote(String id) async {
    _store.removeWhere((n) => n.id == id);
  }
}
