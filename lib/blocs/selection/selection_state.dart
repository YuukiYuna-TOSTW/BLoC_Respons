abstract class SelectionState {}

class SelectionInitial extends SelectionState {}

class SelectionActive extends SelectionState {
  final List<int> selectedIds;
  SelectionActive(this.selectedIds);
}
