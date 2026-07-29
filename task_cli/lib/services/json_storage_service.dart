import 'dart:convert';
import 'dart:io';

import '../exceptions/task_exceptions.dart';
import '../interfaces/storage_interface.dart';
import '../models/standard_task.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';

class JsonStorageService implements StorageInterface<Task> {
  final String filePath;

  JsonStorageService(this.filePath);

  @override
  Future<void> save(List<Task> items) async {
    try {
      final file = File(filePath);
      final jsonList = items.map((t) => t.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      throw StorageException('Erreur lors de la sauvegarde : $e');
    }
  }

  @override
  Future<List<Task>> load() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      if (content.isEmpty) return [];

      final List<dynamic> jsonList = jsonDecode(content);
      return jsonList.map((data) {
        final map = data as Map<String, dynamic>;
        if (map['type'] == 'UrgentTask') {
          return UrgentTask.fromJson(map);
        }
        return StandardTask.fromJson(map);
      }).toList();
    } catch (e) {
      throw StorageException('Erreur lors du chargement : $e');
    }
  }
}