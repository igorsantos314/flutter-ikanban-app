import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';

class TaskItemList extends StatelessWidget {
  final TaskModel taskModel;
  const TaskItemList({super.key, required this.taskModel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(taskModel.title),
      subtitle: Text(taskModel.description ?? 'No description'),
      trailing: Text(taskModel.status.toString().split('.').last),
    );
  }
}
