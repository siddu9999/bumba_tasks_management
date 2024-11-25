import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management/features/task_management/presentation/tab_button.dart';

import '../../authentication/data/authentication_bloc.dart';
import '../../authentication/data/authentication_events.dart';
import '../../authentication/data/authentication_states.dart';
import '../data/task_bloc.dart';
import '../data/task_events.dart';
import '../data/task_model.dart';
import '../data/task_states.dart';

class TaskScreen extends StatefulWidget {

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // Function to show task details dialog
  void _showTaskDetailsDialog(BuildContext context, Task task) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd'); // Date formatter

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color(0xFFFFFFFF), // Card Background: White
          titlePadding: const EdgeInsets.all(16),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    color: Color(0xFF6c5ce7), // Primary Color: Purple
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Header Size
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF2d3436)), // Text Color: Dark Gray
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Description:', task.description),
                const SizedBox(height: 16),
                _buildDetailRow('Start Date:', formatter.format(task.startDate)),
                const SizedBox(height: 8),
                _buildDetailRow('End Date:', formatter.format(task.endDate)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d3436), // Text Color: Dark Gray
              fontSize: 14, // Body Text
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2d3436), // Text Color: Dark Gray
                fontSize: 14, // Body Text
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // Function to edit a task
  void _editTask(BuildContext context, Task task) {
    final _titleController = TextEditingController(text: task.title);
    final _descriptionController = TextEditingController(text: task.description);
    DateTime _startDate = task.startDate;
    DateTime _endDate = task.endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFFFFFFFF), // Card Background: White
              title: const Text(
                'Edit Task',
                style: TextStyle(
                  color: Color(0xFF6c5ce7), // Primary Color: Purple
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Header Size
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      title: 'Title',
                      controller: _titleController,
                      hint: 'Enter title',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      title: 'Description',
                      controller: _descriptionController,
                      hint: 'Enter description',
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      title: 'Start Date',
                      color: Colors.green,
                      date: _startDate,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _startDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      title: 'End Date',
                      color: Colors.red,
                      date: _endDate,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _endDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                _buildDialogActions(
                  context: context,
                  onCancel: () => Navigator.of(context).pop(),
                  onConfirm: () {
                    if (_titleController.text.isNotEmpty) {
                      task.title = _titleController.text;
                      task.description = _descriptionController.text;
                      task.startDate = _startDate;
                      task.endDate = _endDate;
                      BlocProvider.of<TaskBloc>(context).add(EditTaskEvent(task));
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildTextField({
    required String title,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2d3436), // Text Color: Dark Gray
            fontSize: 14, // Body Text
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFF2d3436).withOpacity(0.6), // Text Color with Opacity
              fontSize: 14, // Body Text
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA), // Light Gray Background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE1E4E8)), // Border Color
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }


  Widget _buildDateField({
    required String title,
    required Color color,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 14, // Body Text
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA), // Light Gray Background
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E4E8)), // Border Color
            ),
            child: Text(
              formatter.format(date),
              style: const TextStyle(
                color: Color(0xFF2d3436), // Text Color: Dark Gray
                fontSize: 14, // Body Text
              ),
            ),
          ),
        ),
      ],
    );
  }


  TaskStatus selectedTab = TaskStatus.ToDo;

  @override
  void initState() {
    super.initState();
    // Load tasks when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent());
    });
  }


  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
      if (state is AuthenticationSuccess) {
        // Reload tasks for the current user after login
        BlocProvider.of<TaskBloc>(context).add(LoadTasksEvent());
      }
      if (state is AuthenticationInitial) {
        // Navigate to login screen after logout
        Navigator.pushReplacementNamed(context, '/login');
      }
    },child: Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background Color: Light Gray
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF6c5ce7), // Primary Color: Purple
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Task Management',
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context).add(LogoutEvent());
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Tabs Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                title: 'To Do',
                isSelected: selectedTab == TaskStatus.ToDo,
                onTap: () {
                  setState(() {
                    selectedTab = TaskStatus.ToDo;
                  });
                },
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TabButton(
                title: 'In Progress',
                isSelected: selectedTab == TaskStatus.InProgress,
                onTap: () {
                  setState(() {
                    selectedTab = TaskStatus.InProgress;
                  });
                },
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TabButton(
                title: 'Done',
                isSelected: selectedTab == TaskStatus.Done,
                onTap: () {
                  setState(() {
                    selectedTab = TaskStatus.Done;
                  });
                },
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Task List
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoaded) {
                  final tasks = state.tasks.where((task) => task.status == selectedTab).toList();
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return Dismissible(
                        key: ValueKey(task.id),

                        // Set swipe colors based on the task's current status
                        background: Container(
                          color: task.status == TaskStatus.ToDo
                              ? Colors.yellow // Swiping right in 'To Do'
                              : task.status == TaskStatus.InProgress
                              ? Colors.green // Swiping right in 'In Progress'
                              : Colors.transparent, // No swipe right for 'Done'
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: task.status == TaskStatus.InProgress
                              ? Colors.red // Swiping left in 'In Progress'
                              : task.status == TaskStatus.Done
                              ? Colors.yellow // Swiping left in 'Done'
                              : Colors.transparent, // No swipe left for 'To Do'
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),

                        // Handle swipe behavior
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // Swiping right
                            if (task.status != TaskStatus.Done) {
                              BlocProvider.of<TaskBloc>(context).add(
                                MoveTaskEvent(task, TaskStatus.values[task.status.index + 1]),
                              );
                            }
                          } else if (direction == DismissDirection.endToStart) {
                            // Swiping left
                            if (task.status != TaskStatus.ToDo) {
                              BlocProvider.of<TaskBloc>(context).add(
                                MoveTaskEvent(task, TaskStatus.values[task.status.index - 1]),
                              );
                            }
                          }
                          return false; // Prevent automatic dismissal
                        },

                        child: GestureDetector(
                          onTap: () => _showTaskDetailsDialog(context, task),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54, // Darker color for a more pronounced shadow
                                  blurRadius: 6,        // Increase the blur radius for a larger, softer shadow
                                  offset: Offset(0, 3),  // Adjust the vertical displacement
                                ),
                              ],

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.grey),
                                      onPressed: () => _editTask(context, task),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.grey),
                                      onPressed: () => BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(task)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );

                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6c5ce7), // Primary Color: Purple
        onPressed: () => _showTaskDialog(context),
        child: const Icon(
          Icons.add,
          color: Colors.white, // Icon Color: White
        ),
      ),

    ));
  }

  Widget _buildDialogActions({
    required BuildContext context,
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: onCancel,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF), // Card Background: White
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              border: Border.all(color: const Color(0xFFE1E4E8)), // Border Color: Light Gray
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2d3436), // Text Color: Dark Gray
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: onConfirm,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF6c5ce7), // Primary Color: Purple
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text Color: White
              ),
            ),
          ),
        ),
      ],
    );
  }


  void _showTaskDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    DateTime? _startDate;
    DateTime? _endDate;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: const Color(0xFFFFFFFF), // Card Background: White
              title: const Text(
                'Add Task',
                style: TextStyle(
                  color: Color(0xFF6c5ce7), // Primary Color: Purple
                  fontWeight: FontWeight.bold,
                  fontSize: 18, // Header Size
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      title: 'Title',
                      controller: _titleController,
                      hint: 'Enter title',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      title: 'Description',
                      controller: _descriptionController,
                      hint: 'Enter description',
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      title: 'Start Date',
                      color: Colors.green,
                      date: _startDate ?? DateTime.now(),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _startDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      title: 'End Date',
                      color: Colors.red,
                      date: _endDate ?? DateTime.now(),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _endDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                _buildDialogActions(
                  context: context,
                  onCancel: () => Navigator.of(context).pop(),
                  onConfirm: () {
                    if (_titleController.text.isNotEmpty &&
                        _startDate != null &&
                        _endDate != null) {
                      final newTask = Task(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        startDate: _startDate!,
                        endDate: _endDate!,
                        status: TaskStatus.ToDo,
                      );
                      BlocProvider.of<TaskBloc>(context).add(AddTaskEvent(newTask));
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

}


