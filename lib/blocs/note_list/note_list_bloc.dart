import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/note_repository.dart';
import 'note_list_event.dart';
import 'note_list_state.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final NoteRepository repository;

  NoteListBloc(this.repository) : super(NoteListInitial()) {
    on<FetchNotesEvent>(_onFetchNotes);
  }

  Future<void> _onFetchNotes(FetchNotesEvent event, Emitter<NoteListState> emit) async {
    emit(NoteListLoading());
    try {
      final notes = await repository.fetchNotes();
      emit(NoteListLoaded(notes));
    } catch (e) {
      emit(NoteListError(e.toString()));
    }
  }
}
