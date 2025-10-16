abstract class UpdateNoteEvent {}

class SubmitUpdateEvent extends UpdateNoteEvent {
  final int id;
  final String title;
  final String body;

  SubmitUpdateEvent(this.id, this.title, this.body);
}
