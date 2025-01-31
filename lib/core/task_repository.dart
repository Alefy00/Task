import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';
import 'database.dart';

class TaskRepository {
  Future<int> addTask(Task task) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getTasks({bool completed = false}) async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'isCompleted = ?',
      whereArgs: [completed ? 1 : 0],
      orderBy: 'id DESC',
    );

    return maps.map((task) => Task.fromMap(task)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await DatabaseHelper.instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> deleteAllCompletedTasks() async {
  final db = await DatabaseHelper.instance.database;
  return await db.delete(
    'tasks',
    where: 'isCompleted = ?',
    whereArgs: [1], // Apenas tarefas marcadas como concluídas
  );
}

}
