abstract class StorageInterface<T> {
  Future<void> save(List<T> items);
  Future<List<T>> load();
}