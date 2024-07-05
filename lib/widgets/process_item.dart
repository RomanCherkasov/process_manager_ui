import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proc_manager/model/process.dart';
import 'package:proc_manager/providers/process_provider.dart';

class ProcessItem extends StatelessWidget {
  final Process process;
  const ProcessItem(this.process, {super.key});

  @override
  Widget build(BuildContext context) {
    final processProvider = Provider.of<ProcessProvider>(context, listen: false);

    return Card(
      child: ListTile(
        title: Text('${process.command} ${process.args.join(' ')}'),
        subtitle: Text(process.running ? 'Running' : 'Stopped'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('PID: ${process.pid}'),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                processProvider.confirmStopProcess(context, process.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: () {
                processProvider.rerunProcess(context, process.id);
              },
            )
          ],
        ),
      ),
    );
  }
}
