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
    print('1. Lister les tâches (tri par Priorité)');
    print('2. Lister les tâches (tri par Date)');
    print('3. Ajouter une tâche');
    print('4. Marquer une tâche comme terminée');
    print('5. Supprimer une tâche');
    print('6. Quitter');
    stdout.write('Votre choix : ');

    final input = stdin.readLineSync();

    switch (input) {
      case '1':
        _listTasks(repo.getSortedByPriority(), 'Priorité');
        break;
      case '2':
        _listTasks(repo.getSortedByDate(), 'Date');
        break;
      case '3':
        await _addTask(repo);
        break;
      case '4':
        await _toggleTask(repo);
        break;
      case '5':
        await _deleteTask(repo);
        break;
      case '6':
        print('Au revoir !');
        exit(0);
      default:
        print('Choix invalide. Veuillez saisir un nombre entre 1 et 6.');
    }
  }
}

void _listTasks(List<Task> tasks, String sortType) {
  if (tasks.isEmpty) {
    print('Aucune tâche enregistrée.');
    return;
  }
  print('\n--- Liste des Tâches (tri par $sortType) ---');
  for (var t in tasks) {
    print('ID: ${t.id} | ${t.getFormattedDetails()}');
  }
}

Future<void> _addTask(Repository<Task> repo) async {
  stdout.write('Titre : ');
  final title = stdin.readLineSync() ?? '';
  if (title.trim().isEmpty) {
    print('Erreur : Le titre ne peut pas être vide.');
    return;
  }

  stdout.write('Priorité (low, medium, high) : ');
  final priorityStr = stdin.readLineSync() ?? 'medium';
  final priority = Priority.fromString(priorityStr);

  stdout.write('Est-ce urgent ? (o/N) : ');
  final isUrgent = (stdin.readLineSync() ?? '').toLowerCase() == 'o';

  final id = DateTime.now().millisecondsSinceEpoch.toString();

  if (isUrgent) {
    stdout.write('Date limite (AAAA-MM-JJ) : ');
    final dateStr = stdin.readLineSync() ?? '';
    final dueDate = DateTime.tryParse(dateStr) ?? DateTime.now().add(const Duration(days: 1));

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
  print('Tâche ajoutée avec succès !');
}

Future<void> _toggleTask(Repository<Task> repo) async {
  stdout.write('ID de la tâche à modifier : ');
  final id = stdin.readLineSync() ?? '';
  try {
    await repo.toggleComplete(id);
    print('Statut de la tâche mis à jour !');
  } on TaskNotFoundException catch (e) {
    print('Erreur : ${e.message}');
  }
}

Future<void> _deleteTask(Repository<Task> repo) async {
  stdout.write('ID de la tâche à supprimer : ');
  final id = stdin.readLineSync() ?? '';
  try {
    await repo.remove(id);
    print('Tâche supprimée avec succès !');
  } on TaskNotFoundException catch (e) {
    print('Erreur : ${e.message}');
  }
}