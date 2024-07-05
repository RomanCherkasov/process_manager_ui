import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proc_manager/model/process.dart';
import 'package:proc_manager/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProcessProvider with ChangeNotifier {
  List<Process> _processes = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  Timer? _timer;

  List<Process> get processes => _processes;
  bool get isLoading => _isLoading;
  void _showProcessStillRunningDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('ОК'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> fetchProcesses() async {
    _setLoading(true);
    try {
      _processes = await _apiService.getProcesses();
      _processes.sort((a, b) => a.id.compareTo(b.id));
    } catch (error) {
      // Обработайте ошибку
    } finally {
      _setLoading(false);
    }
    notifyListeners();
  }

  Future<void> startProcess(String command, List<String> args) async {
    await _apiService.startProcess(command, args);
    fetchProcesses();
  }

  Future<void> stopProcess(int id) async {
    await _apiService.stopProcess(id);
    fetchProcesses();
  }

  Future<void> rerunProcess(BuildContext context, int id) async {
    try {
      await _apiService.rerunProcess(id);
      fetchProcesses();
    } catch (error) {
      if (error.toString().contains('Failed to rerun process')) {
        _showProcessStillRunningDialog(context, 'Предупреждение', 'Процесс все ещё работает и не был перезапущен');
      }
      // Обработайте ошибку
    }
  }

  Future<void> initializeAutoRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshRate = prefs.getInt('refreshRate') ?? 1;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: refreshRate), (timer) {
      fetchProcesses();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
