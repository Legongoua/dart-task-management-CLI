import 'task.dart';
import 'priority.dart';

class StandardTask extends Task {
  StandardTask({
    required super.id,
    required super.title,
    super.isCompleted,
    super.priority,
  });

  @override
  String getFormattedDetails() {
    final status = isCompleted ? '[✓]' : '[ ]';
    return '$status [${priority.label}] $title';
  }

  factory StandardTask.fromJson(Map<String, dynamic> json) {
    return StandardTask(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: Priority.fromString(json['priority'] as String),
    );
  }
}