import '../exceptions/task_exceptions.dart';
import '../interfaces/storage_interface.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';

class Repository<T extends Task> {
  final StorageInterface<T> _storage;
  final List<T> _items = [];

  Repository(this._storage);

  List<T> get all => List.unmodifiable(_items);

  Future<void> init() async {
    _items.clear();
    final loaded = await _storage.load();
    _items.addAll(loaded);
  }

  Future<void> add(T item) async {
    _items.add(item);
    await _storage.save(_items);
  }

  Future<void> remove(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) {
      throw TaskNotFoundException('Aucune tâche trouvée avec l\'ID : $id');
    }
    _items.removeAt(index);
    await _storage.save(_items);
  }

  Future<void> toggleComplete(String id) async {
    final item = _items.firstWhere(
      (t) => t.id == id,
      orElse: () => throw TaskNotFoundException('Tâche $id introuvable'),
    );
    item.isCompleted = !item.isCompleted;
    await _storage.save(_items);
  }

  List<T> getSortedByPriority() {
    final sorted = List<T>.from(_items);
    sorted.sort((a, b) => b.priority.value.compareTo(a.priority.value));
    return sorted;
  }

  List<T> getSortedByDate() {
  final sorted = List<T>.from(_items);
  sorted.sort((a, b) {
    // Si la tâche a une date (UrgentTask), on compare la date, sinon on met à la fin
    DateTime? dateA = (a is UrgentTask) ? a.dueDate : null;
    DateTime? dateB = (b is UrgentTask) ? b.dueDate : null;

    if (dateA == null && dateB == null) return 0;
    if (dateA == null) return 1;
    if (dateB == null) return -1;
    return dateA.compareTo(dateB);
  });
  return sorted;
}
}