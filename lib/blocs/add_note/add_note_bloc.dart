import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/note_repository.dart';
import 'add_note_event.dart';
import 'add_note_state.dart';

class AddNoteBloc extends Bloc<AddNoteEvent, AddNoteState> {
  final NoteRepository repository;

  AddNoteBloc(this.repository) : super(AddNoteInitial()) {
    on<SubmitNoteEvent>(_onSubmitNote);
  }

  Future<void> _onSubmitNote(SubmitNoteEvent event, Emitter<AddNoteState> emit) async {
    emit(AddNoteLoading());
    try {
      await repository.add(event.title, event.body);
      emit(AddNoteSuccess());
    } catch (e) {
      emit(AddNoteError(e.toString()));
    }
  }
}
