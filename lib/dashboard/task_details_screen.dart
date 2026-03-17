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
      backgroundColor: const Color(0xFF1A2A3F),
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
                            fontSize: 22,
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
                    const SizedBox(height: 20),
                    Text(
                      task.title,
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 24,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const _MetaCard(icon: Icons.calendar_month_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Due Date',
                                style: TextStyle(
                                  color: Color(0xFF8CA7BA),
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                dueDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const _MetaCard(icon: Icons.groups_2_outlined),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project Team',
                              style: TextStyle(
                                color: Color(0xFF8CA7BA),
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 4),
                            _AvatarRow(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Project Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontSize: 12,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Project Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 74,
                          height: 74,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 3,
                                backgroundColor: const Color(0xFF29465A),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.accent,
                                ),
                              ),
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'All Tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
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
              color: const Color(0xFF203646),
              padding: const EdgeInsets.fromLTRB(36, 14, 36, 18),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: const Color(0xFF151F30),
                  minimumSize: const Size.fromHeight(52),
                ),
                child: const Text(
                  'Add Task',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
  const _MetaCard({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      color: AppTheme.accent,
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
      height: 58,
      color: const Color(0xFF4A6676),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            width: 58,
            height: 58,
            color: AppTheme.accent,
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
    final colors = <Color>[
      const Color(0xFFF5D8A5),
      const Color(0xFFC7D9F1),
      const Color(0xFFEAB5B5),
    ];

    return SizedBox(
      width: 60,
      height: 20,
      child: Stack(
        children: List.generate(3, (index) {
          return Positioned(
            left: index * 14,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: AppTheme.accent,
              child: CircleAvatar(radius: 9, backgroundColor: colors[index]),
            ),
          );
        }),
      ),
    );
  }
}
