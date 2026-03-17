class ChatThread {
  const ChatThread({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.initials,
    required this.avatarColor,
    required this.isGroup,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String timeLabel;
  final String initials;
  final int avatarColor;
  final bool isGroup;

  factory ChatThread.fromMap(Map<String, dynamic> map) {
    return ChatThread(
      id: map['id'] as String,
      name: (map['name'] as String?) ?? 'Untitled',
      lastMessage: (map['last_message'] as String?) ?? '',
      timeLabel: (map['time_label'] as String?) ?? '',
      initials: (map['avatar_initials'] as String?) ?? 'NA',
      avatarColor:
          (map['avatar_color'] as int?) ??
          const int.fromEnvironment('k', defaultValue: 0xFFBCE6CF),
      isGroup: (map['is_group'] as bool?) ?? false,
    );
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.content,
    required this.isMine,
    required this.isSeen,
  });

  final String id;
  final String content;
  final bool isMine;
  final bool isSeen;

  factory ChatMessage.fromMap(
    Map<String, dynamic> map, {
    required String userId,
  }) {
    final senderId = map['sender_id'] as String?;
    return ChatMessage(
      id: map['id'] as String,
      content: (map['content'] as String?) ?? '',
      isMine: senderId != null && senderId == userId,
      isSeen: (map['is_seen'] as bool?) ?? false,
    );
  }
}

class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.name,
    required this.action,
    required this.task,
    required this.time,
    required this.initials,
    required this.avatarColor,
    required this.isNew,
  });

  final String id;
  final String name;
  final String action;
  final String task;
  final String time;
  final String initials;
  final int avatarColor;
  final bool isNew;

  factory AppNotificationItem.fromMap(Map<String, dynamic> map) {
    return AppNotificationItem(
      id: map['id'] as String,
      name: (map['name'] as String?) ?? 'Unknown',
      action: (map['action'] as String?) ?? 'updated',
      task: (map['task'] as String?) ?? 'Task',
      time: (map['time_label'] as String?) ?? '',
      initials: (map['avatar_initials'] as String?) ?? 'NA',
      avatarColor:
          (map['avatar_color'] as int?) ??
          const int.fromEnvironment('k', defaultValue: 0xFFBCE6CF),
      isNew: (map['is_new'] as bool?) ?? true,
    );
  }
}
