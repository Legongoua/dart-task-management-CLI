import 'package:test/test.dart';
import 'package:task_cli/models/priority.dart';
import 'package:task_cli/models/standard_task.dart';
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
  late MockStorage mockStorage;

  setUp(() {
    mockStorage = MockStorage();
    repo = Repository<Task>(mockStorage);
  });

  test('1. Ajouter une tâche augmente la taille du repository', () async {
    final task = StandardTask(id: '1', title: 'Tester');
    await repo.add(task);
    expect(repo.all.length, 1);
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

  test('4. Lever TaskNotFoundException lors de la suppression d\'un mauvais ID', () {
    expect(() => repo.remove('invalid_id'), throwsA(isA<TaskNotFoundException>()));
  });

  test('5. Le tri par priorité ordonne correctement les tâches', () async {
    final t1 = StandardTask(id: '1', title: 'Basse', priority: Priority.low);
    final t2 = StandardTask(id: '2', title: 'Haute', priority: Priority.high);

    await repo.add(t1);
    await repo.add(t2);

    final sorted = repo.getSortedByPriority();
    expect(sorted.first.priority, Priority.high);
  });
}