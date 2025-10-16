abstract class AddNoteState {}

class AddNoteInitial extends AddNoteState {}
class AddNoteLoading extends AddNoteState {}
class AddNoteSuccess extends AddNoteState {}
class AddNoteError extends AddNoteState {
  final String message;
  AddNoteError(this.message);
}
