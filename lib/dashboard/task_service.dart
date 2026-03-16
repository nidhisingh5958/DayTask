import 'package:daytask_app/dashboard/task_model.dart';
import 'package:daytask_app/services/supabase_service.dart';

class TaskService {
  Future<List<TaskModel>> fetchTasks({required String userId}) async {
    final rows = await SupabaseService.client
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return rows.map<TaskModel>((row) => TaskModel.fromMap(row)).toList();
  }

  Future<void> addTask({required String userId, required String title}) async {
    await SupabaseService.client.from('tasks').insert({
      'user_id': userId,
      'title': title.trim(),
      'is_completed': false,
    });
  }

  Future<void> deleteTask({required String id}) async {
    await SupabaseService.client.from('tasks').delete().eq('id', id);
  }

  Future<void> updateTaskStatus({
    required String id,
    required bool isCompleted,
  }) async {
    await SupabaseService.client
        .from('tasks')
        .update({
          'is_completed': isCompleted,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }
}
