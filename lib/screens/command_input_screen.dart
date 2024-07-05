import 'package:flutter/material.dart';

class CommandInputScreen extends StatefulWidget {
  const CommandInputScreen({super.key});

  @override
  State<CommandInputScreen> createState() => _CommandInputScreenState();
}

class _CommandInputScreenState extends State<CommandInputScreen> {
  final _commandController = TextEditingController();
  final _argsController = TextEditingController();

  void _startProcess() {
    final command = _commandController.text;
    final args = _argsController.text.split(' '); // Разделение аргументов по пробелу
    Navigator.of(context).pop({'command': command, 'args': args});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Process'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _commandController,
              decoration: const InputDecoration(labelText: 'Command'),
            ),
            TextField(
              controller: _argsController,
              decoration: const InputDecoration(labelText: 'Arguments (space-separated)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startProcess,
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
