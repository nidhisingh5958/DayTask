import 'package:daytask_app/app/theme.dart';
import 'package:daytask_app/app/text_theme.dart';
import 'package:daytask_app/auth/auth_controller.dart';
import 'package:daytask_app/dashboard/communication_controller.dart';
import 'package:daytask_app/dashboard/communication_model.dart';
import 'package:daytask_app/dashboard/task_controller.dart';
import 'package:daytask_app/services/offline_backup_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offlineBackupServiceProvider = Provider<OfflineBackupService>((ref) {
  return OfflineBackupService(taskService: ref.watch(taskServiceProvider));
});

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  bool _showGroups = false;

  @override
  Widget build(BuildContext context) {
    final threadsAsync = ref.watch(chatThreadsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBar(title: 'Messages', trailingIcon: Icons.edit_outlined),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SegmentButton(
                  label: 'Chat',
                  selected: !_showGroups,
                  onTap: () => setState(() => _showGroups = false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SegmentButton(
                  label: 'Groups',
                  selected: _showGroups,
                  onTap: () => setState(() => _showGroups = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...threadsAsync.when(
            loading: () => const [
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            error: (error, _) => [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Failed to load chats: $error'),
              ),
            ],
            data: (threads) {
              final active = threads
                  .where((thread) => thread.isGroup == _showGroups)
                  .toList();

              return [
                for (final thread in active)
                  _MessageRow(
                    item: _MessageItem(
                      thread.name,
                      thread.lastMessage,
                      thread.timeLabel,
                      thread.initials,
                      Color(thread.avatarColor),
                      threadId: thread.id,
                    ),
                    onTap: () {
                      if (_showGroups) return;
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ChatConversationScreen(
                            name: thread.name,
                            threadId: thread.id,
                            initials: thread.initials,
                            avatarColor: Color(thread.avatarColor),
                          ),
                        ),
                      );
                    },
                  ),
              ];
            },
          ),
          if (!_showGroups) ...[
            const SizedBox(height: 18),
            Center(
              child: SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const NewMessageScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(42),
                  ),
                  child: const Text('Start chat'),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatConversationScreen extends ConsumerWidget {
  const ChatConversationScreen({
    super.key,
    required this.name,
    this.threadId,
    this.initials = 'OA',
    this.avatarColor = const Color(0xFFEAB5B5),
  });

  final String name;
  final String? threadId;
  final String initials;
  final Color avatarColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = threadId == null
        ? const AsyncValue<List<ChatMessage>>.data(<ChatMessage>[])
        : ref.watch(chatMessagesProvider(threadId!));

    return Scaffold(
      backgroundColor: const Color(0xFF1A2A3F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: avatarColor,
                    child: Text(initials),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextTheme.chatHeaderName),
                      Text('Online', style: AppTextTheme.chatHeaderStatus),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.videocam_outlined, color: Colors.white),
                  const SizedBox(width: 12),
                  const Icon(Icons.call_outlined, color: Colors.white),
                ],
              ),
            ),
            Expanded(
              child: messagesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) =>
                    Center(child: Text('Failed to load chat: $error')),
                data: (messages) {
                  final messageItems = messages.isEmpty
                      ? const <ChatMessage>[
                          ChatMessage(
                            id: 'fallback-1',
                            content: 'Hi, please check the new task.',
                            isMine: false,
                            isSeen: false,
                          ),
                          ChatMessage(
                            id: 'fallback-2',
                            content: 'Hi, please check the new task.',
                            isMine: true,
                            isSeen: true,
                          ),
                          ChatMessage(
                            id: 'fallback-3',
                            content: 'Got it. Thanks.',
                            isMine: false,
                            isSeen: false,
                          ),
                        ]
                      : messages;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
                    child: Column(
                      children: [
                        for (int i = 0; i < messageItems.length; i++) ...[
                          _Bubble(
                            text: messageItems[i].content,
                            mine: messageItems[i].isMine,
                            seen: messageItems[i].isSeen,
                          ),
                          const SizedBox(height: 10),
                          if (i == 2) ...[
                            const _AttachmentStrip(),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              color: const Color(0xFF203646),
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      color: const Color(0xFF1E3546),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Row(
                        children: [
                          Icon(Icons.widgets_outlined, color: AppTheme.accent),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Type a message',
                              style: AppTextTheme.chatInputHint,
                            ),
                          ),
                          Icon(Icons.send_outlined, color: AppTheme.accent),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    color: const Color(0xFF1E3546),
                    child: const Icon(
                      Icons.mic_none_outlined,
                      color: AppTheme.accent,
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
}

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const names = <_MessageItem>[
      _MessageItem('Amelia', '', '', 'AM', Color(0xFFBCE6CF)),
      _MessageItem('Alexander', '', '', 'AL', Color(0xFFD7EDF9)),
      _MessageItem('Avery', '', '', 'AV', Color(0xFFE4E4E4)),
      _MessageItem('Asher', '', '', 'AS', Color(0xFFEAB5B5)),
      _MessageItem('Berrett', '', '', 'BE', Color(0xFFBCE6CF)),
      _MessageItem('Benjamin', '', '', 'BN', Color(0xFFC8BDF0)),
      _MessageItem('Brayden', '', '', 'BR', Color(0xFFC7D9F1)),
      _MessageItem('Berrett', '', '', 'BT', Color(0xFFEECBD4)),
      _MessageItem('Braxton', '', '', 'BX', Color(0xFFE4E4E4)),
      _MessageItem('Charlotte', '', '', 'CH', Color(0xFFBCE6CF)),
      _MessageItem('Camelia', '', '', 'CA', Color(0xFFE4E4E4)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A2A3F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
          child: Column(
            children: [
              const _TopBar(title: 'New Message', trailingIcon: Icons.search),
              const SizedBox(height: 14),
              const _MessageRow(
                item: _MessageItem(
                  'Create a group',
                  '',
                  '',
                  'CG',
                  AppTheme.accent,
                ),
                icon: Icons.groups_2_outlined,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    final heading = _letterForIndex(index);
                    return Column(
                      children: [
                        if (heading != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 4,
                                bottom: 4,
                              ),
                              child: Text(
                                heading,
                                style: const TextStyle(
                                  color: AppTheme.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        _MessageRow(item: names[index]),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _letterForIndex(int index) {
    if (index == 0) return 'A';
    if (index == 4) return 'B';
    if (index == 9) return 'C';
    return null;
  }
}

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const days = <String>['1', '2', '3', '4', '5', '6', '7'];
    const weekday = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBar(
            title: 'Schedule',
            trailingIcon: Icons.add_box_outlined,
          ),
          const SizedBox(height: 14),
          const Text(
            'November',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final selected = index == 3;
                return Container(
                  width: 58,
                  color: selected ? AppTheme.accent : const Color(0xFF1F3646),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        days[index],
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFF152234)
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        weekday[index],
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFF1B2938)
                              : const Color(0xFFAAC0CF),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemCount: days.length,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Today\'s Tasks',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const _ScheduleCard(
            title: 'User Interviews',
            time: '16:00 - 18:30',
            highlight: true,
            avatars: 3,
          ),
          const SizedBox(height: 8),
          const _ScheduleCard(
            title: 'Wireframe',
            time: '16:00 - 18:30',
            avatars: 3,
          ),
          const SizedBox(height: 8),
          const _ScheduleCard(
            title: 'Icons',
            time: '16:00 - 18:30',
            avatars: 1,
          ),
          const SizedBox(height: 8),
          const _ScheduleCard(
            title: 'Mockups',
            time: '16:00 - 18:30',
            avatars: 3,
          ),
          const SizedBox(height: 8),
          const _ScheduleCard(
            title: 'Testing',
            time: '16:00 - 18:30',
            avatars: 2,
          ),
        ],
      ),
    );
  }
}

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key, this.onCreate});

  final Future<void> Function(String title)? onCreate;

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController(text: 'Hi-Fi Wireframe');
  final _detailsController = TextEditingController(
    text:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBar(title: 'Create New Task'),
          const SizedBox(height: 14),
          const _FieldLabel('Task Title'),
          const SizedBox(height: 6),
          _FilledInput(controller: _titleController, maxLines: 1),
          const SizedBox(height: 12),
          const _FieldLabel('Task Details'),
          const SizedBox(height: 6),
          _FilledInput(controller: _detailsController, maxLines: 4),
          const SizedBox(height: 14),
          const _FieldLabel('Add team members'),
          const SizedBox(height: 6),
          Row(
            children: [
              const Expanded(
                child: _TagChip(
                  label: 'Robert',
                  initials: 'R',
                  color: Color(0xFFF5D8A5),
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: _TagChip(
                  label: 'Sophia',
                  initials: 'S',
                  color: Color(0xFFEAB5B5),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 34,
                height: 34,
                color: AppTheme.accent,
                child: const Icon(
                  Icons.add,
                  color: Color(0xFF182537),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _FieldLabel('Time & Date'),
          const SizedBox(height: 6),
          const Row(
            children: [
              Expanded(
                child: _MiniInput(icon: Icons.access_time, text: '10:30 AM'),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _MiniInput(
                  icon: Icons.calendar_month_outlined,
                  text: '15/11/2022',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Add New',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () async {
              final callback = widget.onCreate;
              if (callback != null && _titleController.text.trim().isNotEmpty) {
                await callback(_titleController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return notificationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Failed to load notifications: $error')),
      data: (items) {
        final newItems = items.where((item) => item.isNew).toList();
        final earlierItems = items.where((item) => !item.isNew).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(title: 'Notifications'),
              const SizedBox(height: 14),
              Text('New', style: AppTextTheme.sectionHeading),
              const SizedBox(height: 8),
              for (final item in newItems)
                _NotificationRow(
                  name: item.name,
                  action: item.action,
                  task: item.task,
                  time: item.time,
                  initials: item.initials,
                  color: Color(item.avatarColor),
                ),
              const SizedBox(height: 12),
              Text('Earlier', style: AppTextTheme.sectionHeading),
              const SizedBox(height: 8),
              for (final item in earlierItems)
                _NotificationRow(
                  name: item.name,
                  action: item.action,
                  task: item.task,
                  time: item.time,
                  initials: item.initials,
                  color: Color(item.avatarColor),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> createBackup() async {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in to create a backup.')),
        );
        return;
      }

      try {
        final tasks = await ref
            .read(taskServiceProvider)
            .fetchTasks(userId: user.id);
        final backupPath = await ref
            .read(offlineBackupServiceProvider)
            .createTaskBackup(userId: user.id, tasks: tasks);

        if (!context.mounted) return;
        final fileName = backupPath.split('/').last;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Offline backup created: $fileName')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup failed: $error')));
      }
    }

    Future<void> restoreBackup() async {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in to restore a backup.')),
        );
        return;
      }

      try {
        final restoredCount = await ref
            .read(offlineBackupServiceProvider)
            .restoreLatestTaskBackup(userId: user.id);
        await ref.read(taskControllerProvider.notifier).loadTasks();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restored $restoredCount tasks from offline backup.'),
          ),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Restore failed: $error')));
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A2A3F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          child: Column(
            children: [
              const _TopBar(title: 'Profile'),
              const SizedBox(height: 18),
              Stack(
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.accent, width: 2),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFFB7E7C5),
                      child: Text(
                        'FL',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFF1C2A3C),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 6,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A3E53),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _ProfileField(
                icon: Icons.person_outline,
                value: 'Fazil Laghari',
              ),
              const SizedBox(height: 10),
              const _ProfileField(
                icon: Icons.email_outlined,
                value: 'fazzzil7@gmail.com',
              ),
              const SizedBox(height: 10),
              const _ProfileField(icon: Icons.lock_outline, value: 'Password'),
              const SizedBox(height: 10),
              const _DropField(label: 'My Tasks'),
              const SizedBox(height: 10),
              const _DropField(label: 'Privacy'),
              const SizedBox(height: 10),
              const _DropField(label: 'Setting'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: createBackup,
                icon: const Icon(Icons.backup_outlined),
                label: const Text('Create Offline Backup'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: restoreBackup,
                icon: const Icon(Icons.restore_outlined),
                label: const Text('Restore Latest Backup'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppTheme.accent),
                  foregroundColor: AppTheme.accent,
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: () => ref.read(authServiceProvider).signOut(),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, this.trailingIcon});

  final String title;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextTheme.screenTitle,
          ),
        ),
        SizedBox(
          width: 40,
          child: trailingIcon == null
              ? null
              : IconButton(
                  onPressed: () {},
                  icon: Icon(trailingIcon, color: Colors.white),
                ),
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        color: selected ? AppTheme.accent : const Color(0xFF1F3646),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF152232) : const Color(0xFFD1D9E0),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MessageItem {
  const _MessageItem(
    this.name,
    this.subtitle,
    this.time,
    this.initials,
    this.color, {
    this.threadId,
  });

  final String name;
  final String subtitle;
  final String time;
  final String initials;
  final Color color;
  final String? threadId;
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.item, this.icon, this.onTap});

  final _MessageItem item;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: item.color,
              child: icon == null
                  ? Text(
                      item.initials,
                      style: const TextStyle(
                        color: Color(0xFF1C2B3D),
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Icon(icon, color: const Color(0xFF192638)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextTheme.chatListName),
                  if (item.subtitle.isNotEmpty)
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.chatListSubtitle,
                    ),
                ],
              ),
            ),
            if (item.time.isNotEmpty)
              Text(item.time, style: AppTextTheme.chatListTime),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.mine, this.seen = false});

  final String text;
  final bool mine;
  final bool seen;

  @override
  Widget build(BuildContext context) {
    final color = mine ? AppTheme.accent : const Color(0xFF1F3646);

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          color: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: mine
                    ? AppTextTheme.chatBubbleMine
                    : AppTextTheme.chatBubbleOther,
              ),
              if (seen) Text('Seen', style: AppTextTheme.chatSeen),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentStrip extends StatelessWidget {
  const _AttachmentStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      color: const Color(0xFF6FA3E8),
      padding: const EdgeInsets.all(3),
      child: Wrap(
        spacing: 3,
        runSpacing: 3,
        children: List.generate(
          8,
          (index) => Container(
            width: 75,
            height: 58,
            color: index.isEven ? Colors.white : const Color(0xFFCDD8E1),
          ),
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.title,
    required this.time,
    this.highlight = false,
    required this.avatars,
  });

  final String title;
  final String time;
  final bool highlight;
  final int avatars;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: highlight ? AppTheme.accent : const Color(0xFF1F3646),
      child: Row(
        children: [
          Container(width: 8, color: AppTheme.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: highlight ? const Color(0xFF1A2738) : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: highlight
                        ? const Color(0xFF243447)
                        : const Color(0xFFA8BAC8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          _AvatarStack(count: avatars),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _FilledInput extends StatelessWidget {
  const _FilledInput({required this.controller, required this.maxLines});

  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppTheme.surfaceAlt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF3A5364), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF3A5364), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.accent, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.initials,
    required this.color,
  });

  final String label;
  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.surfaceAlt,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: color,
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2B3C),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.close, color: AppTheme.textMuted, size: 16),
        ],
      ),
    );
  }
}

class _MiniInput extends StatelessWidget {
  const _MiniInput({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.surfaceAlt,
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Icon(icon, color: const Color(0xFF162436), size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.name,
    required this.action,
    required this.task,
    required this.time,
    required this.initials,
    required this.color,
  });

  final String name;
  final String action;
  final String task;
  final String time;
  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF1F3042),
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextTheme.notificationBase,
                children: [
                  TextSpan(text: name, style: AppTextTheme.notificationName),
                  TextSpan(text: ' $action\n'),
                  TextSpan(text: task, style: AppTextTheme.notificationTask),
                ],
              ),
            ),
          ),
          Text(time, style: AppTextTheme.notificationTime),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.surfaceAlt,
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.edit_outlined,
            color: AppTheme.accent.withValues(alpha: 0.6),
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _DropField extends StatelessWidget {
  const _DropField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.surfaceAlt,
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.settings_outlined, color: AppTheme.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFACC1CF)),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = <Color>[
      const Color(0xFFF5D8A5),
      const Color(0xFFC7D9F1),
      const Color(0xFFEAB5B5),
    ];

    return SizedBox(
      width: 16.0 * count + 10,
      height: 24,
      child: Stack(
        children: List.generate(count, (index) {
          return Positioned(
            left: index * 14,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: AppTheme.accent,
              child: CircleAvatar(
                radius: 9,
                backgroundColor: colors[index % colors.length],
                child: const Text(
                  '•',
                  style: TextStyle(color: Color(0xFF1A2738), fontSize: 8),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
