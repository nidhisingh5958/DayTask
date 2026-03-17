import 'package:daytask_app/app/theme.dart';
import 'package:daytask_app/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _showGroups = false;

  static const _chatItems = <_MessageItem>[
    _MessageItem(
      'Olivia Anna',
      'Hi, please check the last task, that I....',
      '31 min',
    ),
    _MessageItem(
      'Emna',
      'Hi, please check the last task, that I....',
      '43 min',
    ),
    _MessageItem(
      'Robert Brown',
      'Hi, please check the last task, that I....',
      '6 Nov',
    ),
    _MessageItem(
      'James',
      'Hi, please check the last task, that I....',
      '8 Dec',
    ),
    _MessageItem(
      'Sophia',
      'Hi, please check the last task, that I....',
      '27 Dec',
    ),
    _MessageItem(
      'Isabella',
      'Hi, please check the last task, that I....',
      '31 min',
    ),
  ];

  static const _groupItems = <_MessageItem>[
    _MessageItem(
      'Android Developer',
      'Robert: Did you check the last task?',
      '15:35',
    ),
    _MessageItem(
      'iOS Developer',
      'Robert: Did you check the last task?',
      '15:35',
    ),
    _MessageItem(
      'Web Developer',
      'Robert: Did you check the last task?',
      '15:35',
    ),
    _MessageItem(
      'Back-End Team',
      'Robert: Did you check the last task?',
      '15:35',
    ),
    _MessageItem(
      'Front-End Team',
      'Robert: Did you check the last task?',
      '15:35',
    ),
    _MessageItem(
      'Personal Project',
      'Robert: Did you check the last task?',
      '15:35',
    ),
    _MessageItem(
      'School System Project',
      'Robert: Did you check the last task?',
      '15:35',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final active = _showGroups ? _groupItems : _chatItems;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TopBar(title: 'Messages', showBack: false),
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
                const SizedBox(height: 16),
                for (final item in active)
                  _MessageRow(
                    item: item,
                    onTap: () {
                      if (_showGroups) return;
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ChatConversationScreen(name: item.name),
                        ),
                      );
                    },
                  ),
                if (!_showGroups) ...[
                  const SizedBox(height: 22),
                  Center(
                    child: SizedBox(
                      width: 160,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const NewMessageScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: const Text('Start chat'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChatConversationScreen extends StatelessWidget {
  const ChatConversationScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101C2D),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFEAB5B5),
                    child: Text('OA'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Online',
                        style: TextStyle(
                          color: Color(0xFFA9BAC8),
                          fontSize: 12,
                        ),
                      ),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 16),
                child: Column(
                  children: const [
                    _Bubble(
                      text: 'Hi, please check the new task.',
                      mine: false,
                    ),
                    SizedBox(height: 10),
                    _Bubble(
                      text: 'Hi, please check the new task.',
                      mine: true,
                      seen: true,
                    ),
                    SizedBox(height: 10),
                    _Bubble(text: 'Got it. Thanks.', mine: false),
                    SizedBox(height: 10),
                    _Bubble(
                      text:
                          'Hi, please check the last task, that I have completed.',
                      mine: false,
                    ),
                    SizedBox(height: 10),
                    _AttachmentStrip(),
                    SizedBox(height: 10),
                    _Bubble(
                      text: 'Got it. Will check it soon.',
                      mine: true,
                      seen: true,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color(0xFF1B2A3B),
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Row(
                children: [
                  const Icon(Icons.widgets_outlined, color: AppTheme.accent),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Color(0xFF203646),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.send_outlined, color: AppTheme.accent),
                  const SizedBox(width: 8),
                  const Icon(Icons.mic_none_outlined, color: AppTheme.accent),
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
    const names = <String>[
      'Amelia',
      'Alexander',
      'Avery',
      'Asher',
      'Berrett',
      'Benjamin',
      'Brayden',
      'Berrett',
      'Braxton',
      'Charlotte',
      'Camelia',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF101C2D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
          child: Column(
            children: [
              const _TopBar(title: 'New Message'),
              const SizedBox(height: 14),
              const _MessageRow(
                item: _MessageItem('Create a group', '', ''),
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
                        _MessageRow(item: _MessageItem(names[index], '', '')),
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
          const _TopBar(title: 'Schedule', showBack: false),
          const SizedBox(height: 14),
          const Text(
            'November',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 58,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final selected = index == 3;
                return Container(
                  width: 38,
                  decoration: BoxDecoration(
                    color: selected ? AppTheme.accent : const Color(0xFF1E3546),
                    borderRadius: BorderRadius.circular(2),
                  ),
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
                        ),
                      ),
                      const SizedBox(height: 4),
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
              fontSize: 34,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          const _ScheduleCard(
            title: 'User Interviews',
            time: '16:00 - 18:30',
            highlight: true,
          ),
          const SizedBox(height: 8),
          const _ScheduleCard(title: 'Wireframe', time: '16:00 - 18:30'),
          const SizedBox(height: 8),
          const _ScheduleCard(title: 'Icons', time: '16:00 - 18:30'),
          const SizedBox(height: 8),
          const _ScheduleCard(title: 'Mockups', time: '16:00 - 18:30'),
          const SizedBox(height: 8),
          const _ScheduleCard(title: 'Testing', time: '16:00 - 18:30'),
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
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
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
          const _TopBar(title: 'Create New Task', showBack: false),
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
              const Expanded(child: _TagChip(label: 'Robert')),
              const SizedBox(width: 6),
              const Expanded(child: _TagChip(label: 'Sophia')),
              const SizedBox(width: 6),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
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
          Row(
            children: const [
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
                fontSize: 28,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TopBar(title: 'Notifications', showBack: false),
          SizedBox(height: 14),
          Text(
            'New',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          _NotificationRow(
            name: 'Olivia Anna',
            action: 'left a comment in task',
            task: 'Mobile App Design Project',
            time: '31 min',
          ),
          _NotificationRow(
            name: 'Robert Brown',
            action: 'left a comment in task',
            task: 'Mobile App Design Project',
            time: '31 min',
          ),
          _NotificationRow(
            name: 'Sophia',
            action: 'left a comment in task',
            task: 'Mobile App Design Project',
            time: '31 min',
          ),
          _NotificationRow(
            name: 'Anna',
            action: 'left a comment in task',
            task: 'Mobile App Design Project',
            time: '31 min',
          ),
          SizedBox(height: 12),
          Text(
            'Earlier',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          _NotificationRow(
            name: 'Robert Brown',
            action: 'marked the task',
            task: 'Mobile App Design Project as in process',
            time: '4 hours',
          ),
          _NotificationRow(
            name: 'Sophia',
            action: 'left a comment in task',
            task: 'Mobile App Design Project',
            time: '31 min',
          ),
          _NotificationRow(
            name: 'Anna',
            action: 'left a comment in task',
            task: 'Mobile App Design Project',
            time: '31 min',
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      child: Column(
        children: [
          const _TopBar(title: 'Profile', showBack: false),
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
                    style: TextStyle(fontSize: 28, color: Color(0xFF1C2A3C)),
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
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
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
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: () => ref.read(authServiceProvider).signOut(),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, this.showBack = true});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          )
        else
          const SizedBox(width: 40),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            if (title == 'Messages') {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const NewMessageScreen(),
                ),
              );
            }
          },
          icon: Icon(
            title == 'Messages' ? Icons.edit_outlined : Icons.search,
            color: Colors.white,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : const Color(0xFF1F3646),
          borderRadius: BorderRadius.circular(2),
        ),
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
  const _MessageItem(this.name, this.subtitle, this.time);

  final String name;
  final String subtitle;
  final String time;
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.item, this.icon, this.onTap});

  final _MessageItem item;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initials = item.name
        .trim()
        .split(' ')
        .map((w) => w[0])
        .take(2)
        .join();

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: icon == null
                  ? const Color(0xFFBCE6CF)
                  : AppTheme.accent,
              child: icon == null
                  ? Text(
                      initials,
                      style: const TextStyle(
                        color: Color(0xFF1C2B3D),
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Icon(icon, color: const Color(0xFF192638)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (item.subtitle.isNotEmpty)
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF9FB0BF)),
                    ),
                ],
              ),
            ),
            if (item.time.isNotEmpty)
              Text(
                item.time,
                style: const TextStyle(color: Color(0xFF9FB0BF), fontSize: 11),
              ),
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
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          color: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: mine ? const Color(0xFF1A2738) : Colors.white,
                  fontSize: 15,
                ),
              ),
              if (seen)
                const Text(
                  'Seen',
                  style: TextStyle(
                    color: Color(0xFF1A2738),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
      padding: const EdgeInsets.all(4),
      color: const Color(0xFF6FA3E8),
      child: SizedBox(
        width: 200,
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: List.generate(
            8,
            (index) => Container(
              width: 45,
              height: 45,
              color: index.isEven ? Colors.white : const Color(0xFFCDD8E1),
            ),
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
  });

  final String title;
  final String time;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: highlight ? AppTheme.accent : const Color(0xFF1E3546),
        border: Border(
          left: BorderSide(
            width: 6,
            color: highlight ? AppTheme.accent : AppTheme.accent,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: highlight ? const Color(0xFF1A2738) : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: highlight
                        ? const Color(0xFF243447)
                        : const Color(0xFFA8BAC8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF2A3E53),
            child: Text(
              'AL',
              style: TextStyle(color: AppTheme.accent, fontSize: 9),
            ),
          ),
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
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color(0xFF4A6676),
        border: InputBorder.none,
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFF4A6676),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 8,
            backgroundColor: Color(0xFFF9EFCF),
            child: Text('R', style: TextStyle(fontSize: 8)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Icon(Icons.close, color: Colors.white, size: 14),
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
      height: 40,
      color: const Color(0xFF4A6676),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            color: AppTheme.accent,
            child: Icon(icon, color: const Color(0xFF162436), size: 18),
          ),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
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
  });

  final String name;
  final String action;
  final String task;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFBCE6CF),
            child: Text(
              'RB',
              style: TextStyle(
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
                style: const TextStyle(color: Color(0xFF9FB0BF), height: 1.25),
                children: [
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' $action\n'),
                  TextSpan(
                    text: task,
                    style: const TextStyle(color: AppTheme.accent),
                  ),
                ],
              ),
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 11)),
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
      height: 46,
      color: const Color(0xFF4A6676),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFACC1CF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          const Icon(Icons.edit_outlined, color: Color(0xFFACC1CF), size: 18),
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
      height: 46,
      color: const Color(0xFF4A6676),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(
            Icons.settings_outlined,
            color: Color(0xFFACC1CF),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFFACC1CF)),
        ],
      ),
    );
  }
}
