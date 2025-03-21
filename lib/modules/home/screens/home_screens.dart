import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_interview/data/db_helper/home/model/notes.dart';
import 'package:test_interview/modules/home/bloc/home_bloc.dart';
import 'package:test_interview/modules/home/bloc/home_state.dart';
import 'package:test_interview/modules/home/widgets/task_detail.dart';
import 'package:test_interview/modules/home/widgets/search_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const List<Color> colors = [
    Color(0xFFFFFFFF),
    Color(0xffF28B83),
    Color(0xFFFCBC05),
    Color(0xFFFFF476),
    Color(0xFFCBFF90),
    Color(0xFFA7FEEA),
    Color(0xFFE6C9A9),
    Color(0xFFE8EAEE),
    Color(0xFFA7FEEA),
    Color(0xFFCAF0F8)
  ];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Theme(
        data: _isDarkMode ? _darkTheme() : _lightTheme(),
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text(state.error!));
              }
              if (state.notes.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildNotesList(context, state);
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navigateToDetail(
                context, Note('', '', 3, 0, 0, "", ""), 'Add Task'),
            tooltip: 'Add Task',
            shape: const CircleBorder(
              side: BorderSide(color: Colors.black, width: 2.0),
            ),
            backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.white,
            child: Icon(Icons.add,
                color: _isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.black, fontSize: 24),
        bodyMedium: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black54),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Colors.white, fontSize: 24),
        bodyMedium: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white70),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Tasks', style: Theme.of(context).textTheme.headlineSmall),
      centerTitle: true,
      elevation: 0,
      leading: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => state.notes.isEmpty
            ? const SizedBox()
            : IconButton(
                splashRadius: 22,
                icon: Icon(Icons.search,
                    color: _isDarkMode ? Colors.white : Colors.black),
                onPressed: () async {
                  final Note? result = await showSearch<Note>(
                    context: context,
                    delegate: TasksSearch(notes: state.notes),
                  );
                  if (result != null) {
                    _navigateToDetail(context, result, 'Edit Tasks');
                  }
                },
              ),
      ),
      actions: [
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => Row(
            children: [
              IconButton(
                splashRadius: 22,
                icon: Icon(
                  state.axisCount == 2 ? Icons.list : Icons.grid_on,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () => context.read<HomeCubit>().toggleGrid(),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.filter_list,
                    color: _isDarkMode ? Colors.white : Colors.black),
                onSelected: (value) {
                  if (value == 'all') {
                    context.read<HomeCubit>().filterNotes(null);
                  } else if (value == 'completed') {
                    context.read<HomeCubit>().filterNotes(1);
                  } else if (value == 'incomplete') {
                    context.read<HomeCubit>().filterNotes(0);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'all',
                    child: Text('All Tasks'),
                  ),
                  const PopupMenuItem(
                    value: 'completed',
                    child: Text('Completed'),
                  ),
                  const PopupMenuItem(
                    value: 'incomplete',
                    child: Text('Incomplete'),
                  ),
                ],
              ),
              // Nút chuyển đổi dark mode
              IconButton(
                splashRadius: 22,
                icon: Icon(
                  _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      color: _isDarkMode ? Colors.grey[900] : Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Click on the add button to add a new task!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildNotesList(BuildContext context, HomeState state) {
    return Container(
      color: _isDarkMode ? Colors.grey[900] : Colors.white,
      child: StaggeredGridView.countBuilder(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 4,
        itemCount: state.notes.length,
        itemBuilder: (context, index) =>
            _buildNoteCard(context, state.notes[index]),
        staggeredTileBuilder: (index) => StaggeredTile.fit(state.axisCount),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }

  Widget _buildNoteCard(BuildContext context, Note note) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, note, 'Edit Task'),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: HomeScreen.colors[note.color], // Giữ màu từ danh sách colors
            border: Border.all(
              width: 2,
              color: _isDarkMode ? Colors.white : Colors.black,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        note.title,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        note.status == 1 ? Icons.check_circle : Icons.circle,
                        color: note.status == 1 ? Colors.green : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        getPriorityText(note.priority),
                        style: TextStyle(
                          color: getPriorityColor(note.priority),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (note.description?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    note.description!,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      note.date,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      default:
        return Colors.yellow;
    }
  }

  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return '!!!';
      case 2:
        return '!!';
      case 3:
        return '!';
      default:
        return '!';
    }
  }

  Future<void> _navigateToDetail(
      BuildContext context, Note note, String title) async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetail(note, title),
      ),
    );
    if (result == true) {
      context.read<HomeCubit>().loadNotes();
    }
  }
}
