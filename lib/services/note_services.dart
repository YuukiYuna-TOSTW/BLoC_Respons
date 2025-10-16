import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteService {
  final String baseUrl = 'http://localhost:8080/notes';

  Future<List<dynamic>> fetchNotes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch notes: ${response.statusCode}');
    }
  }

  Future<void> addNote(Map<String, dynamic> payload, String body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add note: ${response.statusCode}');
    }
  }

  Future<void> updateNote(int id, Map<String, dynamic> payload, String body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update note: ${response.statusCode}');
    }
  }

  Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete note: ${response.statusCode}');
    }
  }
}
