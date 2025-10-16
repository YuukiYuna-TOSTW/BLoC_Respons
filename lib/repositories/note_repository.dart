import '../services/note_services_database.dart';
import '../services/note_services_local.dart';

/// Repository khusus untuk penggunaan lokal (dipakai langsung di main.dart)
class NoteRepositoryLocal {
  final NoteServiceLocal service;

  NoteRepositoryLocal([NoteServiceLocal? service]) : service = service ?? NoteServiceLocal();

  Future<List<Map<String, dynamic>>> fetchNotes() async => await service.fetchNotes();

  Future<void> addNote(Map<String, dynamic> payload) async => await service.addNote(payload);

  /// convenience overload used by some callers
  Future<void> add(String title, String body) async =>
      await addNote({'title': title, 'body': body});

  Future<void> updateNote(int id, Map<String, dynamic> payload) async =>
      await service.updateNote(id, payload);

  Future<void> deleteNote(int id) async => await service.deleteNote(id);
}

/// Repository umum: coba service database terlebih dahulu, jika gagal fallback ke lokal
class NoteRepository {
  final NoteServiceDatabase? _dbService;
  final NoteServiceLocal _localService;

  NoteRepository({NoteServiceDatabase? dbService, NoteServiceLocal? localService})
      : _dbService = dbService,
        _localService = localService ?? NoteServiceLocal();

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    if (_dbService != null) {
      try {
        final res = await _dbService!.fetchNotes();
        return res;
      } catch (e) {
        // fallback ke lokal jika database gagal
      }
    }
    return await _localService.fetchNotes();
  }

  Future<void> addNote(Map<String, dynamic> payload) async {
    if (_dbService != null) {
      try {
        await _dbService!.addNote(payload);
        return;
      } catch (e) {
        // fallback ke lokal
      }
    }
    await _localService.addNote(payload);
  }

  /// convenience overload
  Future<void> add(String title, String body) async => addNote({'title': title, 'body': body});

  Future<void> updateNote(int id, Map<String, dynamic> payload) async {
    if (_dbService != null) {
      try {
        await _dbService!.updateNote(id, payload);
        return;
      } catch (e) {
        // fallback ke lokal
      }
    }
    await _localService.updateNote(id, payload);
  }

  Future<void> deleteNote(int id) async {
    if (_dbService != null) {
      try {
        await _dbService!.deleteNote(id);
        return;
      } catch (e) {
        // log lalu fallback ke lokal
      }
    }
    // bila lokal juga gagal biarkan exception naik
    await _localService.deleteNote(id);
  }
}
