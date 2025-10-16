abstract class SelectionEvent {}

class SelectNoteEvent extends SelectionEvent {
  final int noteId;
  SelectNoteEvent(this.noteId);
}

class ClearSelectionEvent extends SelectionEvent {}
