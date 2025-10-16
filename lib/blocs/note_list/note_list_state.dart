abstract class NoteListState {}

class NoteListInitial extends NoteListState {}
class NoteListLoading extends NoteListState {}
class NoteListLoaded extends NoteListState {
  final List<dynamic> notes;
  NoteListLoaded(this.notes);
}
class NoteListError extends NoteListState {
  final String message;
  NoteListError(this.message);
}
