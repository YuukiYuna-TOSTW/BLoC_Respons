import 'package:bloc_respons/services/note_services.dart';
import 'package:flutter/material.dart';
import 'repositories/note_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NoteRepository noteRepository = NoteRepository(NoteService());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NoteListScreen(noteRepository: noteRepository),
    );
  }
}

class NoteListScreen extends StatefulWidget {
  final NoteRepository noteRepository;
  const NoteListScreen({required this.noteRepository});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await widget.noteRepository.fetchNotes();
    setState(() => notes = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Notes")),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note['title']),
            subtitle: Text(note['body']),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UpdateNoteScreen(
                  note: note,
                  noteRepository: widget.noteRepository,
                  refresh: loadNotes,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddNoteScreen(
              noteRepository: widget.noteRepository,
              refresh: loadNotes,
            ),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddNoteScreen extends StatefulWidget {
  final NoteRepository noteRepository;
  final VoidCallback refresh;
  const AddNoteScreen({required this.noteRepository, required this.refresh});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  Future<void> saveNote() async {
    await widget.noteRepository.addNote({
      'title': titleController.text,
      'body': bodyController.text,
    });
    widget.refresh();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: bodyController, decoration: InputDecoration(labelText: "Content")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveNote, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}

class UpdateNoteScreen extends StatefulWidget {
  final NoteRepository noteRepository;
  final Map<String, dynamic> note;
  final VoidCallback refresh;

  const UpdateNoteScreen({required this.noteRepository, required this.note, required this.refresh});

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note['title']);
    bodyController = TextEditingController(text: widget.note['body']);
  }

  Future<void> updateNote() async {
    await widget.noteRepository.updateNote(widget.note['id'], {
      'title': titleController.text,
      'body': bodyController.text,
    });
    widget.refresh();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Note")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: bodyController, decoration: InputDecoration(labelText: "Content")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateNote, child: Text("Update")),
          ],
        ),
      ),
    );
  }
}
