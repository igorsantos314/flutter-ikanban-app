import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_priority.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/domain/model/task_model.dart';
import 'package:flutter_ikanban_app/features/task/presentation/colors/task_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Test access of attributes", () {
    final TaskModel task = TaskModel(
      id: 1,
      title: "Test Task",
      description: "This is a test task",
      createdAt: DateTime.now(),
    );

    test("Access attributes", () {
      expect(task.id, 1);
      expect(task.title, "Test Task");
      expect(task.description, "This is a test task");
      expect(task.status, TaskStatus.backlog);
      expect(task.priority, TaskPriority.low);
      expect(task.complexity, TaskComplexity.easy);
      expect(task.type, TaskType.personal);
      expect(task.color, TaskColors.defaultColor);
      expect(task.isActive, true);  
    },);
  },);
}