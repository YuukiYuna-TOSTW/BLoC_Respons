import 'package:flutter_bloc/flutter_bloc.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  SelectionBloc() : super(SelectionInitial()) {
    on<SelectNoteEvent>(_onSelectNote);
    on<ClearSelectionEvent>(_onClearSelection);
  }

  void _onSelectNote(SelectNoteEvent event, Emitter<SelectionState> emit) {
    final current = state is SelectionActive
        ? List<int>.from((state as SelectionActive).selectedIds)
        : <int>[];
    if (current.contains(event.noteId)) {
      current.remove(event.noteId);
    } else {
      current.add(event.noteId);
    }
    emit(SelectionActive(current));
  }

  void _onClearSelection(ClearSelectionEvent event, Emitter<SelectionState> emit) {
    emit(SelectionInitial());
  }
}
