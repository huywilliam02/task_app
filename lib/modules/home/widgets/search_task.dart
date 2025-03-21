import 'package:flutter/material.dart';
import 'package:test_interview/data/db_helper/home/model/notes.dart';

class TasksSearch extends SearchDelegate<Note> {
  final List<Note> notes;

  TasksSearch({required this.notes});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        splashRadius: 22,
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      splashRadius: 22,
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  List<Note> _getFilteredNotes() {
    if (query.isEmpty) return notes;
    final lowerQuery = query.toLowerCase();
    return notes.where((note) {
      return (note.title.toLowerCase().contains(lowerQuery)) ||
          (note.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Widget _buildEmptyQueryState() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search, size: 50, color: Colors.black),
            SizedBox(height: 16),
            Text(
              'Enter a task to search.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.sentiment_dissatisfied, size: 50, color: Colors.black),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList(List<Note> filteredNotes) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          return ListTile(
            leading: const Icon(Icons.note, color: Colors.black),
            title: Text(
              note.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            subtitle: note.description != null && note.description!.isNotEmpty
                ? Text(
                    note.description!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            onTap: () => close(context, note),
          );
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredNotes = _getFilteredNotes();
    if (query.isEmpty) return _buildEmptyQueryState();
    if (filteredNotes.isEmpty) return _buildNoResultsState();
    return _buildNotesList(filteredNotes);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredNotes = _getFilteredNotes();
    if (query.isEmpty) return _buildEmptyQueryState();
    if (filteredNotes.isEmpty) return _buildNoResultsState();
    return _buildNotesList(filteredNotes);
  }
}
