import 'package:test/test.dart';
import 'package:task_cli/models/standard_task.dart';
import 'package:task_cli/models/urgent_task.dart';
import 'package:task_cli/models/task.dart';
import 'package:task_cli/repositories/task_repository.dart';
import 'package:task_cli/interfaces/storage_interface.dart';
import 'package:task_cli/exceptions/task_exceptions.dart';

class MockStorage implements StorageInterface<Task> {
  List<Task> memory = [];

  @override
  Future<List<Task>> load() async => memory;

  @override
  Future<void> save(List<Task> items) async {
    memory = List.from(items);
  }
}

void main() {
  late Repository<Task> repo;

  setUp(() {
    repo = Repository<Task>(MockStorage());
  });

  test('1. Ajouter une tâche augmente la taille du repository', () async {
    final task = StandardTask(id: '1', title: 'Tester');
    await repo.add(task);
    expect(repo.all.length, equals(1));
  });

  test('2. Marquer une tâche comme terminée modifie son état', () async {
    final task = StandardTask(id: '1', title: 'Tester');
    await repo.add(task);
    await repo.toggleComplete('1');
    expect(repo.all.first.isCompleted, isTrue);
  });

  test('3. Supprimer une tâche la retire du repository', () async {
    final task = StandardTask(id: '1', title: 'Tester');
    await repo.add(task);
    await repo.remove('1');
    expect(repo.all.isEmpty, isTrue);
  });

  test('4. Une exception TaskNotFoundException est levée sur un ID inexistant', () {
    expect(() => repo.remove('invalid_id'), throwsA(isA<TaskNotFoundException>()));
  });

  test('5. Le tri par date ordonne correctement les tâches urgentes', () async {
    final t1 = UrgentTask(id: '1', title: 'Tard', dueDate: DateTime.now().add(const Duration(days: 5)));
    final t2 = UrgentTask(id: '2', title: 'Tôt', dueDate: DateTime.now().add(const Duration(days: 1)));

    await repo.add(t1);
    await repo.add(t2);

    final sorted = repo.getSortedByDate();
    expect(sorted.first.id, equals('2'));
  });
}