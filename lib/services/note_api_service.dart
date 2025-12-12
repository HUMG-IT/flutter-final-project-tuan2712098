import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/note.dart';

class NoteApiService {
  static const String baseUrl =
      'https://6939601ec8d59937aa0788d5.mockapi.io/notes';

  Future<List<Note>> fetchNotes() async {
    final response = await http
        .get(Uri.parse(baseUrl))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load notes (${response.statusCode})');
  }

  Future<Note> createNote(Note note) async {
    final response = await http
        .post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(note.toCreateJson()), // ✅ không gửi id
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create note (${response.statusCode})');
  }

  Future<Note> updateNote(Note note) async {
    final url = '$baseUrl/${note.id}';
    final response = await http
        .put(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(note.toJson()),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update note (${response.statusCode})');
  }

  Future<void> deleteNote(String id) async {
    final url = '$baseUrl/$id';
    final response = await http
        .delete(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note (${response.statusCode})');
    }
  }
}
