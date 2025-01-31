import 'package:flutter/material.dart';
import '../core/task_repository.dart';
import '../models/task_model.dart';

class TodoScreen extends StatefulWidget {
  final VoidCallback onCreateTask;

  const TodoScreen({super.key, required this.onCreateTask});

  @override
  TodoScreenState createState() => TodoScreenState();
}

class TodoScreenState extends State<TodoScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  List<Task> _tasks = [];
  Set<int> _expandedTasks = {}; // Controle de expansão para descrição

  @override
  void initState() {
    super.initState();
    loadTasks(); // Carregar as tarefas ao iniciar a tela
  }

  Future<void> loadTasks() async {
    final tasks = await _taskRepository.getTasks(completed: false);
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> markTaskAsDone(Task task) async {
    if (task.id == null) return; // Garante que o ID não é nulo

    final updatedTask = Task(
      id: task.id!,
      title: task.title,
      description: task.description,
      isCompleted: true,
    );

    await _taskRepository.updateTask(updatedTask);
    loadTasks(); // Atualiza a lista de tarefas
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Welcome, ',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'John.',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Create tasks to achieve more.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _tasks.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insert_drive_file, size: 100, color: Colors.blue.shade200),
                      const SizedBox(height: 16),
                      const Text(
                        'You have no task listed.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final isExpanded = task.id != null && _expandedTasks.contains(task.id!);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (task.id != null) {
                              if (isExpanded) {
                                _expandedTasks.remove(task.id!);
                              } else {
                                _expandedTasks.add(task.id!);
                              }
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: task.isCompleted,
                                    onChanged: (_) => markTaskAsDone(task),
                                  ),
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
                                ],
                              ),
                              if (isExpanded && task.description != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    task.description!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: GestureDetector(
              onTap: widget.onCreateTask,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Create task',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
