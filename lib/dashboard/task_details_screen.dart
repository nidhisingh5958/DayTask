import 'package:daytask_app/app/theme.dart';
import 'package:daytask_app/dashboard/task_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.progress,
  });

  final TaskModel task;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final dueDate = _formatDueDate(task.createdAt);

    return Scaffold(
      backgroundColor: const Color(0xFF101C2D),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Task Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.mode_edit_outline_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      task.title,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 32,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const _MetaCard(
                          icon: Icons.calendar_month_outlined,
                          label: 'Due Date',
                        ),
                        const SizedBox(width: 12),
                        Text(
                          dueDate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const _MetaCard(
                          icon: Icons.groups_2_outlined,
                          label: 'Project Team',
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: _AvatarRow(),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Project Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'This task keeps your delivery trackable from requirements to final mocks. Update the checklist below to keep your team aligned and maintain momentum across the sprint.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text(
                          'Project Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 62,
                          height: 62,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 3,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.accent,
                                ),
                              ),
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'All Tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _ChecklistItem(label: 'User Interviews', done: true),
                    const SizedBox(height: 8),
                    const _ChecklistItem(label: 'Wireframes', done: true),
                    const SizedBox(height: 8),
                    const _ChecklistItem(label: 'Design System', done: true),
                    const SizedBox(height: 8),
                    const _ChecklistItem(label: 'Icons', done: false),
                    const SizedBox(height: 8),
                    const _ChecklistItem(label: 'Final Mockups', done: false),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFF1B2A3B),
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: const Color(0xFF151F30),
                  minimumSize: const Size.fromHeight(62),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime? dateTime) {
    final date = dateTime ?? DateTime.now().add(const Duration(days: 30));
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppTheme.accent,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Icon(icon, color: const Color(0xFF122034)),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      color: const Color(0xFF4A6676),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              border: Border.all(color: const Color(0xFF172538), width: 2),
            ),
            child: Icon(
              done ? Icons.check_circle_outline : Icons.circle_outlined,
              color: const Color(0xFF172538),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarRow extends StatelessWidget {
  const _AvatarRow();

  @override
  Widget build(BuildContext context) {
    const items = <String>['AL', 'SN', 'JK'];

    return SizedBox(
      width: 80,
      height: 24,
      child: Stack(
        children: [
          for (int i = 0; i < items.length; i++)
            Positioned(
              left: i * 18,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: const Color(0xFF26374B),
                  child: Text(
                    items[i],
                    style: const TextStyle(
                      color: AppTheme.accent,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
