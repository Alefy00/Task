import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../core/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Carregar tarefas do banco de dados
  Future<void> fetchTasks({bool completed = false}) async {
    _isLoading = true;
    notifyListeners();
    
    _tasks = await _repository.getTasks(completed: completed);
    
    _isLoading = false;
    notifyListeners();
  }

  // Adicionar uma nova tarefa
  Future<void> addTask(String title, String? description) async {
    final task = Task(title: title, description: description);
    await _repository.addTask(task);
    await fetchTasks();
  }

  // Atualizar uma tarefa (Marcar como concluída)
  Future<void> toggleTaskCompletion(Task task) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: !task.isCompleted,
    );

    await _repository.updateTask(updatedTask);
    await fetchTasks();
  }

  // Deletar uma tarefa
  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
    await fetchTasks();
  }
}
