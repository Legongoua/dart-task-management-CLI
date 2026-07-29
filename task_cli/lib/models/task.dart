import 'priority.dart';

abstract class Task {
  final String id;
  String title;
  bool isCompleted;
  Priority priority;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = Priority.medium,
  });

  String getFormattedDetails();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority.name,
      'type': runtimeType.toString(),
    };
  }
}