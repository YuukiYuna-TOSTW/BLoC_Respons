import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/note_repository.dart';
import 'update_note_event.dart';
import 'update_note_state.dart';

class UpdateNoteBloc extends Bloc<UpdateNoteEvent, UpdateNoteState> {
  final NoteRepository repository;

  UpdateNoteBloc(this.repository) : super(UpdateNoteInitial()) {
    on<SubmitUpdateEvent>(_onSubmitUpdate);
  }

  Future<void> _onSubmitUpdate(SubmitUpdateEvent event, Emitter<UpdateNoteState> emit) async {
    emit(UpdateNoteLoading());
    try {
      await repository.update(event.id, event.title, event.body);
      emit(UpdateNoteSuccess());
    } catch (e) {
      emit(UpdateNoteError(e.toString()));
    }
  }
}
