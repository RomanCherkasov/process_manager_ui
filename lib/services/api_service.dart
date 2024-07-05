import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proc_manager/model/process.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final host = prefs.getString('host') ?? 'localhost';
    final port = prefs.getInt('port') ?? 8080;
    return 'http://$host:$port';
  }

  Future<List<Process>> getProcesses() async {
    final baseUrl = await _getBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/processes'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Process.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load processes');
    }
  }

  Future<void> startProcess(String command, List<String> args) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/processes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'command': command, 'args': args}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to start process');
    }
  }

  Future<void> stopProcess(int id) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.delete(Uri.parse('$baseUrl/processes/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to stop process');
    }
  }

  Future<void> rerunProcess(int id) async {
    final baseUrl = await _getBaseUrl();
    final response = await http.post(
      Uri.parse('$baseUrl/processes/rerun/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to rerun process');
    }
  }
}
