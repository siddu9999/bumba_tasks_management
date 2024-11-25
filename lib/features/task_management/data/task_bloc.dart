import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/features/task_management/data/task_events.dart';
import 'package:task_management/features/task_management/data/task_model.dart';
import 'package:task_management/features/task_management/data/task_states.dart';



class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final Database authDatabase; // For session table
  final Database taskDatabase; // For tasks table

  TaskBloc({required this.authDatabase, required this.taskDatabase}) : super(TaskInitial()) {
    // LoadTasksEvent: Load tasks for the current session user
    on<LoadTasksEvent>((event, emit) async {
      final List<Map<String, dynamic>> session = await authDatabase.query('session');
      if (session.isNotEmpty) {
        final userId = session.first['userId'] as int; // Get current session userId
        final List<Map<String, dynamic>> maps = await taskDatabase.query(
          'tasks',
          where: 'userId = ?', // Filter tasks by userId
          whereArgs: [userId],
        );
        final tasks = maps.map((map) => Task.fromMap(map)).toList();
        emit(TaskLoaded(tasks)); // Emit the filtered tasks
      } else {
        emit(TaskLoaded([])); // No tasks if no user is logged in
      }
    });


// AddTaskEvent: Assign userId to new tasks and save in the database
    on<AddTaskEvent>((event, emit) async {
      final List<Map<String, dynamic>> session = await authDatabase.query('session');
      if (session.isNotEmpty) {
        final userId = session.first['userId'] as int; // Get current session userId
        final task = event.task;
        task.userId = userId; // Assign userId to the task
        await taskDatabase.insert(
          'tasks',
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        add(LoadTasksEvent()); // Reload tasks after adding
      }
    });

    on<EditTaskEvent>((event, emit) async {
      await taskDatabase.update(
        'tasks',
        event.task.toMap(),
        where: 'id = ?',
        whereArgs: [event.task.id],
      );
      add(LoadTasksEvent());
    });

    on<DeleteTaskEvent>((event, emit) async {
      await taskDatabase.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [event.task.id],
      );
      add(LoadTasksEvent());
    });

    on<MoveTaskEvent>((event, emit) async {
      event.task.status = event.newStatus;
      await taskDatabase.update(
        'tasks',
        event.task.toMap(),
        where: 'id = ?',
        whereArgs: [event.task.id],
      );
      add(LoadTasksEvent());
    });
  }
}
