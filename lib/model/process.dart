class Process {
  final int id;
  final String command;
  final List<String> args;
  final bool running;
  final int pid;

  Process({
    required this.id,
    required this.command,
    required this.args,
    required this.running,
    required this.pid,
  });

  factory Process.fromJson(Map<String, dynamic> json) {
    return Process(
      id: json['id'],
      command: json['command'],
      args: List<String>.from(json['args']),
      running: json['running'],
      pid: json['pid'],
    );
  }
}
