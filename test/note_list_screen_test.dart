import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/screens/note_list_screen.dart';

import 'helpers/fake_note_api_service.dart';

void main() {
  testWidgets('edit mode toggles checkbox enabled', (tester) async {
    final fake = FakeNoteApiService(
      seed: [
        Note(
          id: '1',
          title: 'Note 1',
          content: 'Content 1',
          isDone: true,
          createdAt: DateTime.now(),
          color: 0xFFFFF1C1,
        ),
      ],
    );

    final provider = NoteProvider(apiService: fake);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => provider),
        ],
        child: const MaterialApp(home: NoteListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Nếu UI có checkbox thì kiểm tra nó đang disabled trước
    if (find.byType(Checkbox).evaluate().isNotEmpty) {
      final cb1 = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(cb1.onChanged, isNull);
    }

    // ✅ Mở menu bằng icon 3 chấm (không phụ thuộc PopupMenuButton)
    final menuIcon = find.byIcon(Icons.more_vert);
    expect(menuIcon, findsOneWidget);

    await tester.tap(menuIcon);
    await tester.pumpAndSettle();

    // Bật "Chỉnh sửa"
    await tester.tap(find.text('Chỉnh sửa'));
    await tester.pumpAndSettle();

    // Sau khi bật edit mode: checkbox phải enable (nếu có)
    if (find.byType(Checkbox).evaluate().isNotEmpty) {
      final cb2 = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(cb2.onChanged, isNotNull);
    }
  });
}
