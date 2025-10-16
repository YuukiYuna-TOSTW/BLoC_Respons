abstract class UpdateNoteState {}

class UpdateNoteInitial extends UpdateNoteState {}
class UpdateNoteLoading extends UpdateNoteState {}
class UpdateNoteSuccess extends UpdateNoteState {}
class UpdateNoteError extends UpdateNoteState {
  final String message;
  UpdateNoteError(this.message);
}
