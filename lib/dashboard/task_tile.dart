import 'package:daytask_app/app/theme.dart';
import 'package:daytask_app/dashboard/task_model.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggle,
  });

  final TaskModel task;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: task.isCompleted
              ? const Icon(
                  Icons.check_circle,
                  key: ValueKey('done'),
                  color: AppTheme.accent,
                )
              : const Icon(
                  Icons.radio_button_unchecked,
                  key: ValueKey('pending'),
                  color: AppTheme.textMuted,
                ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? AppTheme.textMuted : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(task.isCompleted ? 'Completed' : 'Pending'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch.adaptive(
              value: task.isCompleted,
              onChanged: onToggle,
              activeThumbColor: AppTheme.accent,
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
