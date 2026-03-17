import 'package:daytask_app/dashboard/task_model.dart';
import 'package:daytask_app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskService {
  static const String _defaultTable = 'tasks';
  static const String _fallbackTable = 'User tasks';

  Future<List<TaskModel>> fetchTasks({required String userId}) async {
    final rows = await _withTableFallback(
      (table) => SupabaseService.client
          .from(table)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false),
    );

    return rows.map<TaskModel>((row) => TaskModel.fromMap(row)).toList();
  }

  Future<void> addTask({required String userId, required String title}) async {
    await _withTableFallback(
      (table) => SupabaseService.client.from(table).insert({
        'user_id': userId,
        'title': title.trim(),
        'is_completed': false,
      }),
    );
  }

  Future<void> deleteTask({required String id}) async {
    await _withTableFallback(
      (table) => SupabaseService.client.from(table).delete().eq('id', id),
    );
  }

  Future<void> updateTaskStatus({
    required String id,
    required bool isCompleted,
  }) async {
    await _withTableFallback(
      (table) => SupabaseService.client
          .from(table)
          .update({
            'is_completed': isCompleted,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id),
    );
  }

  Future<T> _withTableFallback<T>(Future<T> Function(String table) call) async {
    try {
      return await call(_defaultTable);
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST205') {
        return call(_fallbackTable);
      }
      rethrow;
    }
  }
}
