abstract class AddNoteEvent {}

class SubmitNoteEvent extends AddNoteEvent {
  final String title;
  final String body;

  SubmitNoteEvent(this.title, this.body);
}
