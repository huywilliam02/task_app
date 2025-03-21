import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_interview/core/utils/widgets.dart';
import 'package:test_interview/core/widgets/check_box/app_checkbox.dart';
import 'package:test_interview/core/widgets/popup/custom_dialog.dart';
import 'package:test_interview/core/widgets/popup/custom_toast.dart';
import 'package:test_interview/core/widgets/popup/toast_enum.dart';
import 'package:test_interview/data/db_helper/home/db_helper.dart';
import 'package:test_interview/data/db_helper/home/model/notes.dart';
import 'package:test_interview/modules/home/screens/home_screens.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TaskDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const TaskDetail(this.note, this.appBarTitle, {super.key});

  @override
  State<TaskDetail> createState() => TaskDetailState();
}

class TaskDetailState extends State<TaskDetail> {
  final DatabaseHelper helper = DatabaseHelper();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late int color;
  late int status;
  late String dueDate;
  bool isEdited = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    descriptionController =
        TextEditingController(text: widget.note.description);
    color = widget.note.color;
    status = widget.note.status;
    dueDate = widget.note.date.isNotEmpty
        ? widget.note.date
        : DateFormat.yMMMd().format(DateTime.now());
    _initializeNotifications();
    _requestNotificationPermission();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones(); // Khởi tạo múi giờ
  }

  Future<void> _requestNotificationPermission() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> _scheduleNotification(Note note) async {
    if (note.date.isEmpty) return;

    final DateTime dueDateTime = DateFormat.yMMMd().parse(note.date);
    final now = DateTime.now();
    if (dueDateTime.isBefore(now)) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Notifications for task due dates',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      note.id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000, // ID duy nhất
      'Task Due: ${note.title}',
      'This task is due today!',
      tz.TZDateTime.from(dueDateTime, tz.local), // Sử dụng múi giờ local
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEdited) {
          await showDiscardDialog(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: colors[color],
        appBar: AppBar(
          elevation: 0,
          title: Text(
            widget.appBarTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          backgroundColor: colors[color],
          leading: IconButton(
            splashRadius: 22,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () =>
                isEdited ? showDiscardDialog(context) : moveToLastScreen(),
          ),
          actions: [
            IconButton(
              splashRadius: 22,
              icon: const Icon(Icons.save, color: Colors.black),
              onPressed: () {
                titleController.text.isEmpty
                    ? showEmptyTitleDialog(context)
                    : _save();
              },
            ),
            if (widget.note.id != null)
              IconButton(
                splashRadius: 22,
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () => showDeleteDialog(context),
              ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                PriorityPicker(
                  selectedIndex: 3 - widget.note.priority,
                  onTap: (index) {
                    setState(() {
                      isEdited = true;
                      widget.note.priority = 3 - index;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ColorPicker(
                  selectedIndex: color,
                  onTap: (index) {
                    setState(() {
                      isEdited = true;
                      color = index;
                      widget.note.color = index;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: titleController,
                    maxLength: 255,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (_) => updateTitle(),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 255,
                    style: Theme.of(context).textTheme.bodyLarge,
                    onChanged: (_) => updateDescription(),
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateFormat.yMMMd().parse(dueDate),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          isEdited = true;
                          dueDate = DateFormat.yMMMd().format(picked);
                          widget.note.date = dueDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Due Date: $dueDate',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      AppCheckBox(
                        value: status == 1,
                        suffixTitle: status == 1 ? 'Completed' : 'Incomplete',
                        onTap: () {
                          final newValue = status == 1 ? 0 : 1;
                          setState(() {
                            isEdited = true;
                            status = newValue;
                            widget.note.status = status;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showDiscardDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text("Discard Changes?",
            style: Theme.of(context).textTheme.bodyMedium),
        content: Text("Are you sure you want to discard changes?",
            style: Theme.of(context).textTheme.bodyLarge),
        actions: [
          TextButton(
            child: Text("No",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.purple)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Yes",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.purple)),
            onPressed: () {
              Navigator.pop(context);
              moveToLastScreen();
            },
          ),
        ],
      ),
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text("Title is empty!",
            style: Theme.of(context).textTheme.bodyMedium),
        content: Text("The title of the note cannot be empty.",
            style: Theme.of(context).textTheme.bodyLarge),
        actions: [
          TextButton(
            child: Text("Okay",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.purple)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => ConfirmDialog(
              title: "Delete Task?",
              body: const Text("Are you sure you want to delete this task?"),
              leftButtonText: "No",
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButtonText: "Yes",
              onRightButtonTap: () {
                Navigator.pop(context);
                _delete();
              },
            ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    setState(() {
      isEdited = true;
      widget.note.title = titleController.text;
    });
  }

  void updateDescription() {
    setState(() {
      isEdited = true;
      widget.note.description = descriptionController.text;
    });
  }

  Future<void> _save() async {
    final now = DateTime.now();
    widget.note.date = dueDate;
    widget.note.createdAt = widget.note.createdAt.isEmpty
        ? DateFormat.yMMMd().format(now)
        : widget.note.createdAt;
    widget.note.updatedAt = DateFormat.yMMMd().format(now);
    widget.note.status = status;

    try {
      if (widget.note.id != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );

        await helper.updateNote(widget.note);
        await _scheduleNotification(widget.note);
        showCustomToast(
            context: context,
            message: "Update Task Success",
            type: ToastEnum.success);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );

        await helper.insertNote(widget.note);
        await _scheduleNotification(widget.note);
        showCustomToast(
            context: context,
            message: "Save Task Success",
            type: ToastEnum.success);
      }
    } catch (e) {
      showCustomToast(
        context: context,
        message: "Lỗi lưu, Vui lòng thử lại!",
        type: ToastEnum.warning,
      );
    } finally {
      setState(() {
        isEdited = false;
      });
    }
  }

  Future<void> _delete() async {
    if (widget.note.id == null) return;
    try {
      await helper.deleteNote(widget.note.id!);
      moveToLastScreen();
      showCustomToast(
          context: context,
          message: "Delete Task Success",
          type: ToastEnum.success);
    } catch (e) {
      showCustomToast(
        context: context,
        message: "Lỗi xoá, Vui lòng thử lại!",
        type: ToastEnum.warning,
      );
    }
  }
}
