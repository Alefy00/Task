class Task {
  final int? id; // ID opcional
  final String title;
  final String? description;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'] as int?,
        title: json['title'] as String,
        description: json['description'] as String?,
        isCompleted: (json['isCompleted'] as int) == 1,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }
}
