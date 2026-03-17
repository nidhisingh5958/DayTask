import 'package:daytask_app/app/theme.dart';
import 'package:daytask_app/dashboard/secondary_screens.dart';
import 'package:daytask_app/dashboard/task_controller.dart';
import 'package:daytask_app/dashboard/task_details_screen.dart';
import 'package:daytask_app/dashboard/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF101C2D),
      body: SafeArea(
        child: taskState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load tasks: $error')),
          data: (tasks) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: _buildBody(context, tasks),
          ),
        ),
      ),
      bottomNavigationBar: _BottomActionBar(
        selectedIndex: _selectedIndex,
        onSelect: _onSelectTab,
        onCenterTap: () => _onSelectTab(2),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<TaskModel> tasks) {
    if (_selectedIndex == 0) {
      return _HomeContent(
        key: const ValueKey('home-content'),
        tasks: tasks,
        onOpenDetails: (task, progress) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => TaskDetailsScreen(task: task, progress: progress),
            ),
          );
        },
        onOpenProfile: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
          );
        },
      );
    }

    if (_selectedIndex == 1) {
      return const MessagesScreen(key: ValueKey('messages-screen'));
    }

    if (_selectedIndex == 2) {
      return CreateTaskScreen(
        key: const ValueKey('create-task-screen'),
        onCreate: (title) async {
          await ref.read(taskControllerProvider.notifier).addTask(title);
          if (!mounted) return;
          setState(() => _selectedIndex = 0);
          ScaffoldMessenger.of(
            this.context,
          ).showSnackBar(const SnackBar(content: Text('Task created')));
        },
      );
    }

    if (_selectedIndex == 3) {
      return const ScheduleScreen(key: ValueKey('schedule-screen'));
    }

    return const NotificationsScreen(key: ValueKey('notifications-screen'));
  }

  void _onSelectTab(int index) {
    setState(() => _selectedIndex = index);
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    super.key,
    required this.tasks,
    required this.onOpenDetails,
    required this.onOpenProfile,
  });

  final List<TaskModel> tasks;
  final void Function(TaskModel task, double progress) onOpenDetails;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final completed = tasks.where((task) => task.isCompleted).toList();
    final ongoing = tasks.where((task) => !task.isCompleted).toList();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFF4C95D),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Fazil Laghari',
                          style: GoogleFonts.orbitron(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            fontSize: 26,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onOpenProfile,
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFF6BA6D9),
                      child: Text(
                        'FL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF455F6E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: const TextField(
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14),
                          hintText: 'Search tasks',
                          hintStyle: TextStyle(color: Color(0xFF9FB3C3)),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF8EA5B7),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 56,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.tune, color: Color(0xFF152132)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const _SectionHeader(
                title: 'Completed Tasks',
                subtitle: 'See all',
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 162,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: completed.isEmpty ? 1 : completed.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    if (completed.isEmpty) {
                      return const _EmptyStateCard(
                        message: 'No completed tasks yet',
                      );
                    }

                    final task = completed[index];
                    final progress = _progressForTask(task, tasks);

                    return _CompletedCard(
                      task: task,
                      progress: progress,
                      onTap: () => onOpenDetails(task, progress),
                      highlighted: index == 0,
                    );
                  },
                ),
              ),
              const SizedBox(height: 26),
              const _SectionHeader(
                title: 'Ongoing Projects',
                subtitle: 'See all',
              ),
              const SizedBox(height: 10),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              if (ongoing.isEmpty) {
                return const _EmptyStateCard(
                  message: 'No ongoing projects right now',
                );
              }

              final task = ongoing[index];
              final progress = _progressForTask(task, tasks);

              return _OngoingTile(
                task: task,
                progress: progress,
                onTap: () => onOpenDetails(task, progress),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemCount: ongoing.isEmpty ? 1 : ongoing.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 26)),
      ],
    );
  }

  double _progressForTask(TaskModel task, List<TaskModel> allTasks) {
    if (allTasks.isEmpty) return 0;

    final totalDone = allTasks.where((entry) => entry.isCompleted).length;
    final base = totalDone / allTasks.length;

    if (task.isCompleted) {
      return 1;
    }

    return base.clamp(0.15, 0.95);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.accent,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CompletedCard extends StatelessWidget {
  const _CompletedCard({
    required this.task,
    required this.progress,
    required this.onTap,
    required this.highlighted,
  });

  final TaskModel task;
  final double progress;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final cardColor = highlighted ? AppTheme.accent : const Color(0xFF546E7C);
    final textColor = highlighted ? const Color(0xFF111B2C) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 188,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                task.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  height: 1.1,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Team members',
              style: TextStyle(color: textColor.withValues(alpha: 0.85)),
            ),
            const SizedBox(height: 6),
            const _AvatarRow(),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Completed',
                  style: TextStyle(color: textColor.withValues(alpha: 0.92)),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              minHeight: 5,
              value: progress,
              backgroundColor: textColor.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                highlighted ? const Color(0xFF131C2D) : AppTheme.accent,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
          ],
        ),
      ),
    );
  }
}

class _OngoingTile extends StatelessWidget {
  const _OngoingTile({
    required this.task,
    required this.progress,
    required this.onTap,
  });

  final TaskModel task;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dueDate = _formatDueDate(task.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF435D6D),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Team members',
                    style: TextStyle(color: Color(0xFFD7DFE7)),
                  ),
                  const SizedBox(height: 6),
                  const _AvatarRow(),
                  const SizedBox(height: 10),
                  Text(
                    'Due on : $dueDate',
                    style: const TextStyle(
                      color: Color(0xFFDEE5EB),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 56,
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.accent,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}';
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFF435D6D),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
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
      height: 22,
      child: Stack(
        children: [
          for (int i = 0; i < items.length; i++)
            Positioned(
              left: i * 14,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 9,
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

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.selectedIndex,
    required this.onSelect,
    required this.onCenterTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCenterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: const BoxDecoration(color: Color(0xFF1B2A3B)),
      child: Row(
        children: [
          Expanded(
            child: _BottomItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: selectedIndex == 0,
              onTap: () => onSelect(0),
            ),
          ),
          Expanded(
            child: _BottomItem(
              icon: Icons.chat_bubble_outline,
              label: 'Chat',
              selected: selectedIndex == 1,
              onTap: () => onSelect(1),
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onCenterTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF111B2C),
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _BottomItem(
              icon: Icons.calendar_month_outlined,
              label: 'Calendar',
              selected: selectedIndex == 3,
              onTap: () => onSelect(3),
            ),
          ),
          Expanded(
            child: _BottomItem(
              icon: Icons.notifications_none,
              label: 'Notification',
              selected: selectedIndex == 4,
              onTap: () => onSelect(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.accent : const Color(0xFF7991A3);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
