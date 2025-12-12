import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/note_provider.dart';

import 'helpers/fake_note_api_service.dart';

void main() {
  test('loadNotes loads notes (reversed in provider)', () async {
    final fake = FakeNoteApiService(
      seed: [
        Note(
          id: '1',
          title: 'First',
          content: 'A',
          isDone: false,
          createdAt: DateTime.now(),
          color: 0xFFFFFFFF,
        ),
        Note(
          id: '2',
          title: 'Second',
          content: 'B',
          isDone: true,
          createdAt: DateTime.now(),
          color: 0xFFFFF1C1,
        ),
      ],
    );

    final provider = NoteProvider(apiService: fake);

    await provider.loadNotes();

    expect(provider.notes.length, 2);
    expect(provider.notes.first.id, '2'); // reversed
    expect(provider.notes.last.id, '1');
  });

  test('addNote creates note DONE by default and inserts at top', () async {
    final fake = FakeNoteApiService(seed: []);
    final provider = NoteProvider(apiService: fake);

    await provider.addNote(title: 'New', content: 'Hello', color: 0xFFCFF4FF);

    expect(provider.notes.length, 1);
    expect(provider.notes.first.title, 'New');
    expect(provider.notes.first.isDone, true);
    expect(provider.notes.first.color, 0xFFCFF4FF);
  });

  test('toggleDone flips isDone', () async {
    final seed = [
      Note(
        id: '1',
        title: 'A',
        content: 'B',
        isDone: true,
        createdAt: DateTime.now(),
        color: 0xFFFFFFFF,
      ),
    ];

    final fake = FakeNoteApiService(seed: seed);
    final provider = NoteProvider(apiService: fake);

    await provider.loadNotes();
    final before = provider.notes.first;
    expect(before.isDone, true);

    await provider.toggleDone(before);

    expect(provider.notes.first.isDone, false);
  });

  test('deleteNote removes note', () async {
    final seed = [
      Note(
        id: '1',
        title: 'A',
        content: 'B',
        isDone: true,
        createdAt: DateTime.now(),
        color: 0xFFFFFFFF,
      ),
    ];

    final fake = FakeNoteApiService(seed: seed);
    final provider = NoteProvider(apiService: fake);

    await provider.loadNotes();
    expect(provider.notes.length, 1);

    await provider.deleteNote(provider.notes.first);
    expect(provider.notes.length, 0);
  });
}
