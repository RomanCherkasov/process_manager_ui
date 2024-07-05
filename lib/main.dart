import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/process_provider.dart';
import 'widgets/process_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProcessProvider(),
      child: MaterialApp(
        title: 'Process Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ProcessListScreen(),
      ),
    );
  }
}
