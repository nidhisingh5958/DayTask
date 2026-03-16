import 'package:daytask_app/dashboard/task_model.dart';
import 'package:daytask_app/dashboard/task_service.dart';
import 'package:daytask_app/auth/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final taskControllerProvider =
    StateNotifierProvider<TaskController, AsyncValue<List<TaskModel>>>((ref) {
      final user = ref.watch(currentUserProvider);
      return TaskController(
        taskService: ref.watch(taskServiceProvider),
        userId: user?.id,
      )..loadTasks();
    });

class TaskController extends StateNotifier<AsyncValue<List<TaskModel>>> {
  TaskController({required TaskService taskService, required this.userId})
    : _taskService = taskService,
      super(const AsyncValue.loading());

  final TaskService _taskService;
  final String? userId;

  Future<void> loadTasks() async {
    if (userId == null) {
      state = const AsyncValue.data(<TaskModel>[]);
      return;
    }

    try {
      final tasks = await _taskService.fetchTasks(userId: userId!);
      state = AsyncValue.data(tasks);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addTask(String title) async {
    if (userId == null) return;
    await _taskService.addTask(userId: userId!, title: title);
    await loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id: id);
    await loadTasks();
  }

  Future<void> toggleTask(TaskModel task, bool isCompleted) async {
    await _taskService.updateTaskStatus(id: task.id, isCompleted: isCompleted);
    await loadTasks();
  }
}
