class TaskModel {
  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.isCompleted,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final bool isCompleted;
  final DateTime? createdAt;

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      isCompleted: (map['is_completed'] as bool?) ?? false,
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'is_completed': isCompleted,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
