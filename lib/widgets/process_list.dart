import 'package:flutter/material.dart';
import 'package:proc_manager/screens/command_input_screen.dart';
import 'package:provider/provider.dart';
import '../providers/process_provider.dart';
import 'process_item.dart';
import 'package:proc_manager/screens/settings_screen.dart';

class ProcessListScreen extends StatefulWidget {
  const ProcessListScreen({super.key});

  @override
  State<ProcessListScreen> createState() => _ProcessListScreenState();
}

class _ProcessListScreenState extends State<ProcessListScreen> {
  @override
  void initState() {
    super.initState();
    // Используем отложенный вызов для загрузки данных после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProcessProvider>(context, listen: false).fetchProcesses();
    });
  }

  Future<void> _openCommandInputScreen(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CommandInputScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final command = result['command'] as String;
      final args = result['args'] as List<String>;

      Provider.of<ProcessProvider>(context, listen: false).startProcess(command, args);
    }
  }

  Future<void> _openSettingsScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
    // Перезапускаем таймер с новой частотой после возвращения с экрана настроек
    Provider.of<ProcessProvider>(context, listen: false).initializeAutoRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final processProvider = Provider.of<ProcessProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              processProvider.fetchProcesses();
            },
          ),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _openSettingsScreen(context);
              }),
        ],
      ),
      body: processProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ProcessProvider>(
              builder: (ctx, processProvider, _) {
                if (processProvider.processes.isEmpty) {
                  return const Center(
                    child: Text('Нет запущенных процессов'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: processProvider.processes.length,
                    itemBuilder: (ctx, i) => ProcessItem(processProvider.processes[i]),
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openCommandInputScreen(context),
      ),
    );
  }
}
