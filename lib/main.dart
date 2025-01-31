import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/viewmodels/task_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}
