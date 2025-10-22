import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_complexity_.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/complexity_selector.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/status_selector.dart';
import 'package:flutter_ikanban_app/features/task/presentation/widgets/trask_type_selector.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StatusSelector(selectedStatus: TaskStatus.todo, onStatusSelected: (status) {

            },),
            const SizedBox(height: 16),
            ComplexitySelector(selectedComplexity: TaskComplexity.medium, onComplexitySelected: (complexity) {

            },),
            const SizedBox(height: 16),
            
            // VERSÃO 2: Grid (Recomendado - Mais Visual)
            TaskTypeGridSelector(
              selectedType: TaskType.appointment,
              onTypeSelected: (type) {
              },
              showTechnicalTypes: false,
              crossAxisCount: 3, // Ajustável
            ),
            
            const Divider(height: 40),

            // VERSÃO 3: Lista (Para muitas opções)
            TaskTypeListSelector(
              selectedType: TaskType.cooking,
              onTypeSelected: (type) {
                
              },
              showTechnicalTypes: false,
            ),
            
          ],
        ),
      ),
    );
  }
}