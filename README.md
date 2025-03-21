# test_interview

A new Flutter project.

## Overview

`test_interview` is a simple yet feature-rich task management application built with Flutter. It allows users to create, edit, and manage tasks with details such as titles, descriptions, priorities, colors, completion statuses, and due dates. The app includes a customizable UI with light/dark mode support, task filtering, and due date notifications.

## Features

### 1. Task Management
- **Task List (`HomeScreen`)**:
  - Displays tasks in a grid or list view, toggleable via an `AppBar` button.
  - Each task shows: title, description (if available), date, priority, and completion status.
  - Smooth scrolling with `BouncingScrollPhysics`.
- **Add Task**:
  - A `FloatingActionButton` opens `TaskDetail` to create a new task.
- **Edit Task**:
  - Tap a task in the list to open `TaskDetail` for editing.
- **Delete Task**:
  - A delete button in `TaskDetail` removes the task (with a confirmation dialog).

### 2. Task Details (`TaskDetail`)
- **Task Information**:
  - Editable title (`title`) and description (`description`) via `TextField`.
  - Priority (`priority`) selectable via `PriorityPicker` (3 levels: high, medium, low).
  - Color (`color`) selectable via `ColorPicker` (10 predefined colors).
  - Completion status (`status`) via `AppCheckBox` (Completed/Incomplete).
  - Due date (`dueDate`) selectable via `showDatePicker`.
- **Save Task**:
  - Saves to the database with `createdAt` (creation date) and `updatedAt` (update date).
  - Displays success or error toast messages.
- **Exit Confirmation**:
  - Shows a dialog if exiting with unsaved changes (`WillPopScope`).

### 3. Task Filtering
- **Filter by Status**:
  - An `AppBar` menu with 3 options: "All Tasks", "Completed", "Incomplete".
  - Uses `filterNotes` in `HomeCubit` to update the displayed task list.

### 4. Dark Mode
- **Mode Switching**:
  - An `AppBar` button toggles between light and dark modes (`Icons.dark_mode`/`Icons.light_mode`).
- **UI Customization**:
  - Light mode: white background, black text.
  - Dark mode: dark gray background (`Colors.grey[900]`), white text.
  - Adjusts borders, `FloatingActionButton` background, and other UI elements via `ThemeData`.

### 5. Due Date Notifications
- **Scheduled Notifications**:
  - Uses `flutter_local_notifications` to send notifications on the task's due date (`dueDate`).
  - Notification includes the task title and message: "This task is due today!".
- **Configuration**:
  - Requests notification permissions on Android 13+.
  - Uses `zonedSchedule` with local timezone (`tz.local`).

### 6. Task Search
- **Search Functionality**:
  - An `AppBar` search button opens `showSearch` with a `TasksSearch` delegate.
  - Allows searching tasks by title and opens `TaskDetail` upon selection.

### 7. Database and State Management
- **Storage**:
  - Uses `DatabaseHelper` for CRUD operations (Create, Read, Update, Delete) with SQLite.
- **State Management**:
  - Uses `flutter_bloc` with `HomeCubit` to manage task list, loading state (`isLoading`), errors (`error`), and grid column count (`axisCount`).

## 8. Run App
- flutter clean
- flutter pub get
- flutter pub run build_runner build --delete-conflicting-outputs
- flutter run

## Dependencies
Add the following to `pubspec.yaml`:
```yaml
# dependencies:
#   flutter:
#     sdk: flutter
#   flutter_bloc: ^8.1.3
#   flutter_staggered_grid_view: ^0.7.0
#   intl: ^0.19.0
#   flutter_local_notifications: ^17.0.0
#   timezone: ^0.9.2

