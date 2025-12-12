import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/models/note.dart';

void main() {
  test('Note.fromJson parses color int + toJson includes color', () {
    final json = {
      'id': '1',
      'title': 'A',
      'content': 'B',
      'isDone': true,
      'createdAt': '2025-01-01T10:00:00.000Z',
      'color': 0xFFFFF1C1,
    };

    final note = Note.fromJson(json);

    expect(note.id, '1');
    expect(note.isDone, true);
    expect(note.color, 0xFFFFF1C1);

    final out = note.toJson();
    expect(out['color'], 0xFFFFF1C1);
  });

  test('Note.fromJson parses color string 0x..', () {
    final json = {
      'id': '1',
      'title': 'A',
      'content': 'B',
      'isDone': false,
      'createdAt': '2025-01-01T10:00:00.000Z',
      'color': '0xFFFFD7E5',
    };

    final note = Note.fromJson(json);
    expect(note.color, 0xFFFFD7E5);
  });

  test('toCreateJson does not include id', () {
    final note = Note(
      id: '999',
      title: 'T',
      content: 'C',
      isDone: true,
      createdAt: DateTime.parse('2025-01-01T10:00:00.000Z'),
      color: 0xFFCFF4FF,
    );

    final out = note.toCreateJson();
    expect(out.containsKey('id'), false);
    expect(out['color'], 0xFFCFF4FF);
  });
}
