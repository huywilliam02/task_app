import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:test_interview/data/db_helper/home/model/notes.dart';
part 'home_state.g.dart';

@CopyWith()
class HomeState {
  final bool isLoading;
  final List<Note> notes;
  final int axisCount;
  final String? error;
  HomeState({
    this.isLoading = false,
    this.notes = const [],
    this.axisCount = 2,
    this.error,
  });
}
