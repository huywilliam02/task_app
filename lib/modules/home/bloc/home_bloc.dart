import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_interview/data/db_helper/home/db_helper.dart';
import 'package:test_interview/data/db_helper/home/model/notes.dart';
import 'package:test_interview/modules/home/bloc/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DatabaseHelper databaseHelper = DatabaseHelper();

  HomeCubit() : super(HomeState()) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final notes = await databaseHelper.getNoteList();
      emit(state.copyWith(notes: notes, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load notes: $e',
      ));
    }
  }

  void toggleGrid() {
    emit(state.copyWith(axisCount: state.axisCount == 2 ? 4 : 2));
  }

  Future<void> saveNote(Note note) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      note.date = DateFormat.yMMMd().format(DateTime.now());
      if (note.id != null) {
        await databaseHelper.updateNote(note);
      } else {
        await databaseHelper.insertNote(note);
      }
      await loadNotes();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Error saving note: $e',
      ));
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await databaseHelper.deleteNote(id);
      await loadNotes();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Error deleting note: $e',
      ));
    }
  }

  void filterNotes(int? statusFilter) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<Note> allNotes = await databaseHelper.getNoteList();
      List<Note> filteredNotes;
      if (statusFilter == null) {
        filteredNotes = allNotes;
      } else {
        filteredNotes =
            allNotes.where((note) => note.status == statusFilter).toList();
      }
      emit(state.copyWith(
        isLoading: false,
        notes: filteredNotes,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to filter notes: $e',
      ));
    }
  }
}
