import 'dart:io';

import 'package:task_cli/exceptions/task_exceptions.dart';
import 'package:task_cli/models/priority.dart';
import 'package:task_cli/models/standard_task.dart';
import 'package:task_cli/models/task.dart';
import 'package:task_cli/models/urgent_task.dart';
import 'package:task_cli/repositories/task_repository.dart';
import 'package:task_cli/services/json_storage_service.dart';

void main() async {
  final storage = JsonStorageService('tasks.json');
  final repo = Repository<Task>(storage);

  await repo.init();
  print('=== Gestionnaire de Tâches CLI ===\n');

  while (true) {
    print('\nMenu :');
    print('1. Lister les tâches');
    print('2. Ajouter une tâche');
    print('3. Marquer une tâche comme terminée');
    print('4. Supprimer une tâche');
    print('5. Quitter');
    stdout.write('Votre choix : ');

    final input = stdin.readLineSync();

    switch (input) {
      case '1':
        _listTasks(repo);
        break;
      case '2':
        await _addTask(repo);
        break;
      case '3':
        await _toggleTask(repo);
        break;
      case '4':
        await _deleteTask(repo);
        break;
      case '5':
        print('Au revoir !');
        exit(0);
      default:
        print('Choix invalide.');
    }
  }
}

void _listTasks(Repository<Task> repo) {
  final tasks = repo.getSortedByPriority();
  if (tasks.isEmpty) {
    print('Aucune tâche.');
    return;
  }
  print('\n--- Liste des Tâches (triées par priorité) ---');
  for (var t in tasks) {
    print('ID: ${t.id} | ${t.getFormattedDetails()}');
  }
}

Future<void> _addTask(Repository<Task> repo) async {
  stdout.write('Titre : ');
  final title = stdin.readLineSync() ?? '';

  stdout.write('Priorité (low, medium, high) : ');
  final priorityStr = stdin.readLineSync() ?? 'medium';
  final priority = Priority.fromString(priorityStr);

  stdout.write('Est-ce urgent ? (o/N) : ');
  final isUrgent = (stdin.readLineSync() ?? '').toLowerCase() == 'o';

  final id = DateTime.now().millisecondsSinceEpoch.toString();

  if (isUrgent) {
    stdout.write('Date limite (AAAA-MM-JJ) : ');
    final dateStr = stdin.readLineSync() ?? '';
    final dueDate = DateTime.tryParse(dateStr) ?? DateTime.now().add(Duration(days: 1));
    
    await repo.add(UrgentTask(
      id: id,
      title: title,
      priority: priority,
      dueDate: dueDate,
    ));
  } else {
    await repo.add(StandardTask(
      id: id,
      title: title,
      priority: priority,
    ));
  }
  print('Tâche ajoutée !');
}

Future<void> _toggleTask(Repository<Task> repo) async {
  stdout.write('ID de la tâche terminée : ');
  final id = stdin.readLineSync() ?? '';
  try {
    await repo.toggleComplete(id);
    print('Statut mis à jour !');
  } on TaskNotFoundException catch (e) {
    print('Erreur : ${e.message}');
  }
}

Future<void> _deleteTask(Repository<Task> repo) async {
  stdout.write('ID de la tâche à supprimer : ');
  final id = stdin.readLineSync() ?? '';
  try {
    await repo.remove(id);
    print('Tâche supprimée !');
  } on TaskNotFoundException catch (e) {
    print('Erreur : ${e.message}');
  }
}