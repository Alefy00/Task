import 'package:flutter/material.dart';
import 'views/todo_screen.dart';
import 'views/create_screen.dart'; // Importando a tela Create
import 'views/done_screen.dart';
import 'views/search_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<TodoScreenState> _todoScreenKey =
      GlobalKey<TodoScreenState>();

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        _todoScreenKey.currentState
            ?.loadTasks(); // Atualiza as tarefas ao voltar para Todo
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      TodoScreen(
        key: _todoScreenKey,
        onCreateTask: () {
          _onTabSelected(1);
        },
      ),
      CreateScreen(
        onTaskCreated: () {
          _onTabSelected(0);
        },
      ),
      const SearchScreen(), // Substituir com a tela de Search
      const DoneScreen(), // Aba Done
    ];

   return Scaffold(
  body: _screens[_selectedIndex],
  bottomNavigationBar: Container(
    decoration: BoxDecoration(
      color: Colors.white, // Adicionando fundo branco ao tab menu
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.0), // Sombra leve
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onTabSelected,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white, // Fundo branco no BottomNavigationBar
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.format_list_bulleted_rounded),
          label: 'Todo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.done),
          label: 'Done',
        ),
      ],
    ),
  ),
);

  }
}
