class Task {
  final int? id;
  String title;
  String description;
  DateTime startDate;
  DateTime endDate;
  TaskStatus status;
  int? userId; // Add this field for user association

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.userId, // Include userId in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.index,
      'userId': userId, // Include userId in the map
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      status: TaskStatus.values[map['status'] as int],
      userId: map['userId'] as int?, // Parse userId from map
    );
  }
}


enum TaskStatus {
  ToDo,
  InProgress,
  Done,
}