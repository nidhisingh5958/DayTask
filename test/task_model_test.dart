import 'package:daytask_app/dashboard/task_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TaskModel serialization and deserialization', () {
    final now = DateTime.parse('2026-03-16T10:30:00.000Z');

    final task = TaskModel(
      id: 'task-1',
      userId: 'user-1',
      title: 'Prepare interview assignment',
      isCompleted: false,
      createdAt: now,
    );

    final map = task.toMap();
    final restored = TaskModel.fromMap(map);

    expect(restored.id, task.id);
    expect(restored.userId, task.userId);
    expect(restored.title, task.title);
    expect(restored.isCompleted, task.isCompleted);
    expect(restored.createdAt?.toUtc(), now.toUtc());
  });
}
