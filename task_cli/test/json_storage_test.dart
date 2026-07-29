import 'dart:io';
import 'package:test/test.dart';
import 'package:task_cli/models/standard_task.dart';
import 'package:task_cli/services/json_storage_service.dart';

void main() {
  final testFilePath = 'test_tasks.json';
  late JsonStorageService storage;

  setUp(() {
    storage = JsonStorageService(testFilePath);
  });

  tearDown(() async {
    final file = File(testFilePath);
    if (await file.exists()) {
      await file.delete();
    }
  });

  test('6. JsonStorageService sauvegarde et recharge correctement les données', () async {
    final originalTasks = [StandardTask(id: '100', title: 'Test Storage')];
    await storage.save(originalTasks);

    final loadedTasks = await storage.load();
    expect(loadedTasks.length, equals(1));
    expect(loadedTasks.first.title, equals('Test Storage'));
  });
}