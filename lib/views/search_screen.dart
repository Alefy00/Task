import 'package:flutter/material.dart';
import '../core/task_repository.dart';
import '../models/task_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TaskRepository _taskRepository = TaskRepository();
  final TextEditingController _searchController = TextEditingController();
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskRepository.getTasks(completed: false);
    setState(() {
      _tasks = tasks;
      _filteredTasks = tasks;
    });
  }

  void _filterTasks(String query) {
    final filtered = _tasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredTasks = filtered;
    });
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: _filterTasks,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _filterTasks('');
                        },
                      )
                    : null,
                hintText: 'Search tasks',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredTasks.isEmpty
              ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insert_drive_file, size: 100, color: Colors.blue.shade200),
                        const SizedBox(height: 16),
                        const Text(
                          'No result found.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                      itemCount: _filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _filteredTasks[index];

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
