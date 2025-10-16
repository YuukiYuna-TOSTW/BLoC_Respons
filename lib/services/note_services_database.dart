import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteServiceDatabase {
  final String baseUrl = 'http://localhost:8080/notes';

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception('DB fetch failed: ${response.statusCode}');
  }

  Future<void> addNote(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('DB add failed: ${response.statusCode}');
    }
  }

  Future<void> updateNote(int id, Map<String, dynamic> payload) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode != 200) {
      throw Exception('DB update failed: ${response.statusCode}');
    }
  }

  Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('DB delete failed: ${response.statusCode}');
    }
  }
}
