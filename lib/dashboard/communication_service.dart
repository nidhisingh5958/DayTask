import 'package:daytask_app/dashboard/communication_model.dart';
import 'package:daytask_app/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunicationService {
  static const String _threadsTable = 'chat_threads';
  static const String _messagesTable = 'chat_messages';
  static const String _notificationsTable = 'notifications';

  Future<List<ChatThread>> fetchThreads({required String userId}) async {
    try {
      final rows = await SupabaseService.client
          .from(_threadsTable)
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return rows.map<ChatThread>((row) => ChatThread.fromMap(row)).toList();
    } on PostgrestException {
      return _fallbackThreads;
    } catch (_) {
      return _fallbackThreads;
    }
  }

  Future<List<ChatMessage>> fetchMessages({
    required String threadId,
    required String userId,
  }) async {
    try {
      final rows = await SupabaseService.client
          .from(_messagesTable)
          .select()
          .eq('thread_id', threadId)
          .order('created_at');

      return rows
          .map<ChatMessage>((row) => ChatMessage.fromMap(row, userId: userId))
          .toList();
    } on PostgrestException {
      return _fallbackMessages;
    } catch (_) {
      return _fallbackMessages;
    }
  }

  Future<List<AppNotificationItem>> fetchNotifications({
    required String userId,
  }) async {
    try {
      final rows = await SupabaseService.client
          .from(_notificationsTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return rows
          .map<AppNotificationItem>((row) => AppNotificationItem.fromMap(row))
          .toList();
    } on PostgrestException {
      return _fallbackNotifications;
    } catch (_) {
      return _fallbackNotifications;
    }
  }

  static const List<ChatThread> _fallbackThreads = <ChatThread>[
    ChatThread(
      id: 't1',
      name: 'Olivia Anna',
      lastMessage: 'Hi, please check the last task, that I....',
      timeLabel: '31 min',
      initials: 'OA',
      avatarColor: 0xFFEAB5B5,
      isGroup: false,
    ),
    ChatThread(
      id: 't2',
      name: 'Robert Brown',
      lastMessage: 'Hi, please check the last task, that I....',
      timeLabel: '6 Nov',
      initials: 'RB',
      avatarColor: 0xFFC8BDF0,
      isGroup: false,
    ),
    ChatThread(
      id: 'g1',
      name: 'Android Developer',
      lastMessage: 'Robert: Did you check the last task?',
      timeLabel: '15:35',
      initials: 'AD',
      avatarColor: 0xFFC8BDF0,
      isGroup: true,
    ),
    ChatThread(
      id: 'g2',
      name: 'Back-End Team',
      lastMessage: 'Robert: Did you check the last task?',
      timeLabel: '15:35',
      initials: 'BE',
      avatarColor: 0xFFEAB5B5,
      isGroup: true,
    ),
  ];

  static const List<ChatMessage> _fallbackMessages = <ChatMessage>[
    ChatMessage(
      id: 'm1',
      content: 'Hi, please check the new task.',
      isMine: false,
      isSeen: false,
    ),
    ChatMessage(
      id: 'm2',
      content: 'Hi, please check the new task.',
      isMine: true,
      isSeen: true,
    ),
    ChatMessage(
      id: 'm3',
      content: 'Got it. Thanks.',
      isMine: false,
      isSeen: false,
    ),
  ];

  static const List<AppNotificationItem> _fallbackNotifications =
      <AppNotificationItem>[
        AppNotificationItem(
          id: 'n1',
          name: 'Olivia Anna',
          action: 'left a comment in task',
          task: 'Mobile App Design Project',
          time: '31 min',
          initials: 'OA',
          avatarColor: 0xFFEAB5B5,
          isNew: true,
        ),
        AppNotificationItem(
          id: 'n2',
          name: 'Robert Brown',
          action: 'marked the task',
          task: 'Mobile App Design Project as in process',
          time: '4 hours',
          initials: 'RB',
          avatarColor: 0xFFBCE6CF,
          isNew: false,
        ),
      ];
}
