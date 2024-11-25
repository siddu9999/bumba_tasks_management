import 'package:task_management/features/task_management/data/task_model.dart';
import 'package:task_management/features/task_management/data/task_states.dart';

abstract class TaskEvent {}

class LoadTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;
  AddTaskEvent(this.task);
}

class EditTaskEvent extends TaskEvent {
  final Task task;
  EditTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;
  DeleteTaskEvent(this.task);
}

class MoveTaskEvent extends TaskEvent {
  final Task task;
  final TaskStatus newStatus;
  MoveTaskEvent(this.task, this.newStatus);
}