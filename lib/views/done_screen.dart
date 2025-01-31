import 'package:flutter/material.dart';
import '../core/task_repository.dart';
import '../models/task_model.dart';

class DoneScreen extends StatefulWidget {
  const DoneScreen({super.key});

  @override
  _DoneScreenState createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks(); // Carregar as tarefas concluídas ao iniciar a tela
  }

  Future<void> loadTasks() async {
    final tasks = await _taskRepository.getTasks(completed: true);
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> deleteTask(Task task) async {
    if (task.id != null) {
      await _taskRepository.deleteTask(task.id!);
      loadTasks(); // Atualiza a lista de tarefas concluídas
    }
  }

  Future<void> deleteAllTasks() async {
    await _taskRepository.deleteAllCompletedTasks();
    loadTasks(); // Remove todas as tarefas concluídas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
 appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Taski',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'John',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/perfil.jpg'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Completed Tasks',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: deleteAllTasks,
                  child: const Text(
                    'Delete all',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 100, color: Colors.green.shade200),
                        const SizedBox(height: 16),
                        const Text(
                          'No completed tasks yet.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_box_rounded,
                              color: Colors.grey,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                task.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => deleteTask(task),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
