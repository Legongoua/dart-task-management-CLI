import 'task.dart';
import 'priority.dart';

class UrgentTask extends Task {
  DateTime dueDate;

  UrgentTask({
    required super.id,
    required super.title,
    required this.dueDate,
    super.isCompleted,
    super.priority = Priority.high,
  });

  @override
  String getFormattedDetails() {
    final status = isCompleted ? '[✓]' : '[ ]';
    final dateStr = '${dueDate.day}/${dueDate.month}/${dueDate.year}';
    return '$status 🔥 [URGENT - ${priority.label}] $title (Limite: $dateStr)';
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['dueDate'] = dueDate.toIso8601String();
    return json;
  }

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      priority: Priority.fromString(json['priority'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
    );
  }
}