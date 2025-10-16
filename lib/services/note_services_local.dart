import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NoteServiceLocal {
  static const _key = 'notes_local';

  // existing local-methods (explicit names kept)
  Future<List<Map<String, dynamic>>> fetchNotesLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) return <Map<String, dynamic>>[];
    final list = jsonDecode(jsonStr) as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> addNoteLocal(Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await fetchNotesLocal();
    final nextId = list.isEmpty
        ? 1
        : (list
                .map((e) => (e['id'] ?? 0) as int)
                .reduce((a, b) => a > b ? a : b) +
            1);
    final item = <String, dynamic>{...payload, 'id': nextId};
    list.add(item);
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<void> updateNoteLocal(int id, Map<String, dynamic> payload) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await fetchNotesLocal();
    for (var i = 0; i < list.length; i++) {
      final m = list[i];
      if ((m['id'] ?? m['ID']) == id) {
        list[i] = <String, dynamic>{...m, ...payload, 'id': id};
        break;
      }
    }
    await prefs.setString(_key, jsonEncode(list));
  }

  Future<void> deleteNoteLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await fetchNotesLocal();
    final idStr = id.toString();
    list.removeWhere((e) {
      final m = Map<String, dynamic>.from(e as Map);
      final stored = (m['id'] ?? m['ID']);
      return stored?.toString() == idStr;
    });
    await prefs.setString(_key, jsonEncode(list));
  }

  // Public API methods (used by repositories)
  Future<List<Map<String, dynamic>>> fetchNotes() => fetchNotesLocal();

  Future<void> addNote(Map<String, dynamic> payload) => addNoteLocal(payload);

  Future<void> updateNote(int id, Map<String, dynamic> payload) =>
      updateNoteLocal(id, payload);

  Future<void> deleteNote(int id) => deleteNoteLocal(id);
}