import 'package:flutter/material.dart';
import 'services/note_services_local.dart';
import 'services/note_services_database.dart';
import 'repositories/note_repository.dart';

void main() {
  // Option A — coba database dulu, jika gagal fallback ke lokal
  final repo = NoteRepository(
    dbService: NoteServiceDatabase(),
    localService: NoteServiceLocal(),
  );

  // Option B — gunakan lokal saja (jika ingin memaksa local)
  // final repo = NoteRepository(localService: NoteServiceLocal());

  runApp(MyApp(noteRepository: repo));
}

class MyApp extends StatelessWidget {
  final NoteRepository noteRepository;

  const MyApp({Key? key, required this.noteRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC_Respons',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NoteListScreen(noteRepository: noteRepository),
    );
  }
}

class NoteListScreen extends StatefulWidget {
  final dynamic noteRepository;
  const NoteListScreen({required this.noteRepository});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Map<String, dynamic>> notes = [];
  bool isSelectionMode = false;
  List<Map<String, dynamic>> selectedNotes = [];

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
      appBar: AppBar(
        title: Text("My Notes"),
        actions: [
          if (isSelectionMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                if (selectedNotes.isEmpty) return;
                try {
                  // hapus semua item yang terpilih
                  for (var note in List.from(selectedNotes)) {
                    final id = note['id'] ?? note['ID'];
                    await widget.noteRepository.deleteNote(int.parse(id.toString()));
                  }
                  // reset selection dan reload
                  setState(() {
                    isSelectionMode = false;
                    selectedNotes.clear();
                  });
                  await loadNotes();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted selected notes')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
                }
              },
            )
          else
            IconButton(
              icon: Icon(Icons.select_all),
              onPressed: () {
                setState(() {
                  isSelectionMode = true;
                  selectedNotes = List<Map<String, dynamic>>.from(notes);
                });
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final selected = selectedNotes.contains(note);
          return ListTile(
            title: Text(note['title'] ?? ''),
            subtitle: Text(note['body'] ?? ''),
            leading: isSelectionMode
                ? Checkbox(
                    value: selected,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          if (!selectedNotes.contains(note)) selectedNotes.add(note);
                        } else {
                          selectedNotes.remove(note);
                        }
                      });
                    },
                  )
                : null,
            onTap: () {
              if (isSelectionMode) {
                setState(() {
                  if (selected) selectedNotes.remove(note); else selectedNotes.add(note);
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateNoteScreen(
                      note: note,
                      noteRepository: widget.noteRepository,
                      refresh: loadNotes,
                    ),
                  ),
                );
              }
            },
            onLongPress: () {
              setState(() {
                isSelectionMode = true;
                if (!selectedNotes.contains(note)) selectedNotes.add(note);
              });
            },
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
  final dynamic noteRepository;
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
  final dynamic noteRepository;
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

class DeleteNoteScreen extends StatelessWidget {
  final dynamic noteRepository;
  final Map<String, dynamic> note;
  final VoidCallback refresh;

  const DeleteNoteScreen({required this.noteRepository, required this.note, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete Note")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final id = note['id'] ?? note['ID'];
            try {
              await noteRepository.deleteNote(int.parse(id.toString()));
              refresh();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note deleted')));
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
            }
          },
          child: Text("Confirm Delete"),
        ),
      ),
    );
  }
}
