import 'package:bloc_respons/services/note_services.dart';

class NoteRepository {
  final NoteService service;

  NoteRepository(this.service);

  Future<List<dynamic>> getNotes() => service.fetchNotes();

  Future<void> add(String title, String body) =>
      service.addNote(title as Map<String, dynamic>, body);

  Future<void> update(int id, String title, String body) =>
      service.updateNote(id, title as Map<String, dynamic>, body);

  Future<void> delete(int id) => service.deleteNote(id);

  Future fetchNotes() async {}

  Future<void> addNote(Map<String, String> map) async {}

  Future<void> updateNote(note, Map<String, String> map) async {}
}
