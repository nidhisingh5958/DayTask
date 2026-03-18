import 'dart:convert';
import 'dart:io';

import 'package:daytask_app/dashboard/task_model.dart';
import 'package:daytask_app/dashboard/task_service.dart';
import 'package:path_provider/path_provider.dart';

class OfflineBackupService {
  OfflineBackupService({TaskService? taskService})
    : _taskService = taskService ?? TaskService();

  final TaskService _taskService;

  Future<String> createTaskBackup({
    required String userId,
    required List<TaskModel> tasks,
  }) async {
    final directory = await _backupDirectory();
    final timestamp = DateTime.now().toUtc().toIso8601String().replaceAll(
      ':',
      '-',
    );
    final file = File('${directory.path}/task-backup-$timestamp.json');

    final payload = <String, dynamic>{
      'schema_version': 1,
      'generated_at': DateTime.now().toUtc().toIso8601String(),
      'user_id': userId,
      'tasks': tasks
          .map(
            (task) => {
              'title': task.title,
              'is_completed': task.isCompleted,
              'created_at': task.createdAt?.toIso8601String(),
              'updated_at': task.updatedAt?.toIso8601String(),
            },
          )
          .toList(),
    };

    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString('${encoder.convert(payload)}\n', flush: true);

    return file.path;
  }

  Future<int> restoreLatestTaskBackup({required String userId}) async {
    final file = await findLatestTaskBackup();
    if (file == null) {
      throw const BackupNotFoundException('No offline backup found.');
    }

    final raw = await file.readAsString();
    final decoded = jsonDecode(raw);

    if (decoded is! Map<String, dynamic>) {
      throw const BackupFormatException('Backup format is invalid.');
    }

    final backupUserId = decoded['user_id'] as String?;
    if (backupUserId != null && backupUserId != userId) {
      throw const BackupFormatException(
        'Latest backup belongs to another account.',
      );
    }

    final taskList = decoded['tasks'];
    if (taskList is! List) {
      throw const BackupFormatException('Backup does not contain task data.');
    }

    final rows = <Map<String, dynamic>>[];
    for (final item in taskList) {
      if (item is! Map<String, dynamic>) continue;
      final title = item['title'] as String?;
      if (title == null || title.trim().isEmpty) continue;

      rows.add({
        'user_id': userId,
        'title': title.trim(),
        'is_completed': (item['is_completed'] as bool?) ?? false,
      });
    }

    await _taskService.replaceTasksFromBackup(userId: userId, tasks: rows);
    return rows.length;
  }

  Future<File?> findLatestTaskBackup() async {
    final directory = await _backupDirectory();
    if (!await directory.exists()) {
      return null;
    }

    final backups =
        directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.json'))
            .toList()
          ..sort(
            (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
          );

    if (backups.isEmpty) {
      return null;
    }

    return backups.first;
  }

  Future<Directory> _backupDirectory() async {
    final root = await getApplicationDocumentsDirectory();
    final directory = Directory('${root.path}/offline_backups');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}

class BackupNotFoundException implements Exception {
  const BackupNotFoundException(this.message);

  final String message;

  @override
  String toString() => message;
}

class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}
