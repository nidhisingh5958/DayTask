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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isCompleted
              ? AppTheme.success.withValues(alpha: 0.3)
              : AppTheme.accent.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onToggle(!task.isCompleted),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: task.isCompleted
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.success.withValues(alpha: 0.2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.check_circle,
                            key: ValueKey('done'),
                            color: AppTheme.success,
                            size: 24,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.accent,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.radio_button_unchecked,
                            key: ValueKey('pending'),
                            color: AppTheme.accent,
                            size: 16,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isCompleted
                              ? AppTheme.textMuted
                              : AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.isCompleted ? 'Completed' : 'In Progress',
                        style: TextStyle(
                          color: task.isCompleted
                              ? AppTheme.success.withValues(alpha: 0.7)
                              : AppTheme.accent.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.error,
                    size: 20,
                  ),
                  splashRadius: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
