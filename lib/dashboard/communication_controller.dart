import 'package:daytask_app/auth/auth_controller.dart';
import 'package:daytask_app/dashboard/communication_model.dart';
import 'package:daytask_app/dashboard/communication_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communicationServiceProvider = Provider<CommunicationService>(
  (ref) => CommunicationService(),
);

final chatThreadsProvider = FutureProvider<List<ChatThread>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const <ChatThread>[];
  }

  return ref.read(communicationServiceProvider).fetchThreads(userId: user.id);
});

final chatMessagesProvider = FutureProvider.family<List<ChatMessage>, String>((
  ref,
  threadId,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const <ChatMessage>[];
  }

  return ref
      .read(communicationServiceProvider)
      .fetchMessages(threadId: threadId, userId: user.id);
});

final notificationsProvider = FutureProvider<List<AppNotificationItem>>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return const <AppNotificationItem>[];
  }

  return ref
      .read(communicationServiceProvider)
      .fetchNotifications(userId: user.id);
});
