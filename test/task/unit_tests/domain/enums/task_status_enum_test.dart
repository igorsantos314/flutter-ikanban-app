import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_status.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_status_enum_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskStatus enum", () {
    test("should contain all expected values", () {
      expect(TaskStatus.values.length, 10);
      expect(TaskStatus.values, containsAll([
        TaskStatus.all,
        TaskStatus.backlog,
        TaskStatus.todo,
        TaskStatus.inProgress,
        TaskStatus.blocked,
        TaskStatus.review,
        TaskStatus.testing,
        TaskStatus.done,
        TaskStatus.cancelled,
        TaskStatus.archived,
      ]));
    });

    test("should have correct statusValue values", () {
      expect(TaskStatus.all.statusValue, 0);
      expect(TaskStatus.backlog.statusValue, 10);
      expect(TaskStatus.todo.statusValue, 20);
      expect(TaskStatus.inProgress.statusValue, 30);
      expect(TaskStatus.blocked.statusValue, 40);
      expect(TaskStatus.review.statusValue, 50);
      expect(TaskStatus.testing.statusValue, 60);
      expect(TaskStatus.done.statusValue, 70);
      expect(TaskStatus.cancelled.statusValue, 80);
      expect(TaskStatus.archived.statusValue, 90);
    });

    test("should have correct display names", () {
      expect(TaskStatus.all.displayName, "Todos");
      expect(TaskStatus.backlog.displayName, "Backlog");
      expect(TaskStatus.todo.displayName, "A Fazer");
      expect(TaskStatus.inProgress.displayName, "Em Progresso");
      expect(TaskStatus.blocked.displayName, "Bloqueado");
      expect(TaskStatus.review.displayName, "Em Revisão");
      expect(TaskStatus.testing.displayName, "Em Teste");
      expect(TaskStatus.done.displayName, "Concluído");
      expect(TaskStatus.cancelled.displayName, "Cancelado");
      expect(TaskStatus.archived.displayName, "Arquivado");
    });

    test("should have correct description values", () {
      expect(TaskStatus.all.description, "Todos os status");
      expect(TaskStatus.backlog.description, "Ideias e tarefas futuras");
      expect(TaskStatus.todo.description, "Pronto para começar");
      expect(TaskStatus.inProgress.description, "Trabalhando nisso");
      expect(TaskStatus.blocked.description, "Impedido de continuar");
      expect(TaskStatus.review.description, "Aguardando revisão");
      expect(TaskStatus.testing.description, "Em fase de testes");
      expect(TaskStatus.done.description, "Tarefa finalizada");
      expect(TaskStatus.cancelled.description, "Tarefa cancelada");
      expect(TaskStatus.archived.description, "Tarefa arquivada");
    });

    test("should have correct icon values", () {
      expect(TaskStatus.all.icon, Icons.list);
      expect(TaskStatus.backlog.icon, Icons.inventory_2);
      expect(TaskStatus.todo.icon, Icons.playlist_add_check);
      expect(TaskStatus.inProgress.icon, Icons.hourglass_empty);
      expect(TaskStatus.blocked.icon, Icons.block);
      expect(TaskStatus.review.icon, Icons.rate_review);
      expect(TaskStatus.testing.icon, Icons.science);
      expect(TaskStatus.done.icon, Icons.check_circle);
      expect(TaskStatus.cancelled.icon, Icons.cancel);
      expect(TaskStatus.archived.icon, Icons.archive);
    });

    test("should have correct color", () {
      expect(TaskStatus.all.color, Colors.grey);
      expect(TaskStatus.backlog.color, Colors.grey);
      expect(TaskStatus.todo.color, Colors.blue);
      expect(TaskStatus.inProgress.color, Colors.orange);
      expect(TaskStatus.blocked.color, Colors.red);
      expect(TaskStatus.review.color, Colors.purple);
      expect(TaskStatus.testing.color, Colors.amber);
      expect(TaskStatus.done.color, Colors.green);
      expect(TaskStatus.cancelled.color, Colors.grey[700]);
      expect(TaskStatus.archived.color, Colors.brown);
    });

    test("should have correct progressPercentage values", () {
      expect(TaskStatus.all.progressPercentage, 0.0);
      expect(TaskStatus.backlog.progressPercentage, 0.0);
      expect(TaskStatus.todo.progressPercentage, 0.1);
      expect(TaskStatus.inProgress.progressPercentage, 0.5);
      expect(TaskStatus.blocked.progressPercentage, 0.3);
      expect(TaskStatus.review.progressPercentage, 0.75);
      expect(TaskStatus.testing.progressPercentage, 0.85);
      expect(TaskStatus.done.progressPercentage, 1.0);
      expect(TaskStatus.cancelled.progressPercentage, 0.0);
      expect(TaskStatus.archived.progressPercentage, 0.0);
    });

    test("should have correct isActive values", () {
      expect(TaskStatus.all.isActive, true);
      expect(TaskStatus.backlog.isActive, true);
      expect(TaskStatus.todo.isActive, true);
      expect(TaskStatus.inProgress.isActive, true);
      expect(TaskStatus.blocked.isActive, true);
      expect(TaskStatus.review.isActive, true);
      expect(TaskStatus.testing.isActive, true);
      expect(TaskStatus.done.isActive, false);
      expect(TaskStatus.cancelled.isActive, false);
      expect(TaskStatus.archived.isActive, true);
    });

    test("should have correct isFinished values", () {
      expect(TaskStatus.all.isFinished, false);
      expect(TaskStatus.backlog.isFinished, false);
      expect(TaskStatus.todo.isFinished, false);
      expect(TaskStatus.inProgress.isFinished, false);
      expect(TaskStatus.blocked.isFinished, false);
      expect(TaskStatus.review.isFinished, false);
      expect(TaskStatus.testing.isFinished, false);
      expect(TaskStatus.done.isFinished, true);
      expect(TaskStatus.cancelled.isFinished, true);
      expect(TaskStatus.archived.isFinished, false);
    });

    test("should have correct isInProgress values", () {
      expect(TaskStatus.all.isInProgress, false);
      expect(TaskStatus.backlog.isInProgress, false);
      expect(TaskStatus.todo.isInProgress, false);
      expect(TaskStatus.inProgress.isInProgress, true);
      expect(TaskStatus.blocked.isInProgress, false);
      expect(TaskStatus.review.isInProgress, true);
      expect(TaskStatus.testing.isInProgress, true);
      expect(TaskStatus.done.isInProgress, false);
      expect(TaskStatus.cancelled.isInProgress, false);
      expect(TaskStatus.archived.isInProgress, false);
    });

    test("should have correct nextStatus values", () {
      expect(TaskStatus.backlog.nextStatus, TaskStatus.todo);
      expect(TaskStatus.todo.nextStatus, TaskStatus.inProgress);
      expect(TaskStatus.inProgress.nextStatus, TaskStatus.review);
      expect(TaskStatus.blocked.nextStatus, TaskStatus.inProgress);
      expect(TaskStatus.review.nextStatus, TaskStatus.done);
      expect(TaskStatus.testing.nextStatus, TaskStatus.done);
      expect(TaskStatus.done.nextStatus, null);
      expect(TaskStatus.cancelled.nextStatus, null);
      expect(TaskStatus.archived.nextStatus, null);
    });

    test("should have correct previousStatus values", () {
      expect(TaskStatus.backlog.previousStatus, null);
      expect(TaskStatus.todo.previousStatus, TaskStatus.backlog);
      expect(TaskStatus.inProgress.previousStatus, TaskStatus.todo);
      expect(TaskStatus.blocked.previousStatus, TaskStatus.todo);
      expect(TaskStatus.review.previousStatus, TaskStatus.inProgress);
      expect(TaskStatus.testing.previousStatus, TaskStatus.review);
      expect(TaskStatus.done.previousStatus, TaskStatus.review);
      expect(TaskStatus.cancelled.previousStatus, null);
      expect(TaskStatus.archived.previousStatus, null);
    });

    test("statusValue should be unique for each TaskStatus", () {
      final statusValues = TaskStatus.values.map((e) => e.statusValue).toList();
      final uniqueStatusValues = statusValues.toSet();
      expect(statusValues.length, uniqueStatusValues.length);
    });

    test("displayName should be unique for each TaskStatus", () {
      final displayNames = TaskStatus.values.map((e) => e.displayName).toList();
      final uniqueDisplayNames = displayNames.toSet();
      expect(displayNames.length, uniqueDisplayNames.length);
    });

    test("description should be unique for each TaskStatus", () {
      final descriptions = TaskStatus.values.map((e) => e.description).toList();
      final uniqueDescriptions = descriptions.toSet();
      expect(descriptions.length, uniqueDescriptions.length);
    });

    test("progressPercentage should be between 0.0 and 1.0", () {
      for (var status in TaskStatus.values) {
        expect(status.progressPercentage >= 0.0 && status.progressPercentage <= 1.0, true,
            reason: '${status.displayName} progress should be between 0.0 and 1.0');
      }
    });

    test("done status should have 100% progress", () {
      expect(TaskStatus.done.progressPercentage, 1.0);
    });

    test("workflow progression should be logical", () {
      // backlog -> todo -> inProgress -> review -> done
      expect(TaskStatus.backlog.nextStatus, TaskStatus.todo);
      expect(TaskStatus.todo.nextStatus, TaskStatus.inProgress);
      expect(TaskStatus.inProgress.nextStatus, TaskStatus.review);
      expect(TaskStatus.review.nextStatus, TaskStatus.done);
      
      // Reverse check
      expect(TaskStatus.done.previousStatus, TaskStatus.review);
      expect(TaskStatus.review.previousStatus, TaskStatus.inProgress);
      expect(TaskStatus.inProgress.previousStatus, TaskStatus.todo);
      expect(TaskStatus.todo.previousStatus, TaskStatus.backlog);
    });

    test("blocked status should return to inProgress", () {
      expect(TaskStatus.blocked.nextStatus, TaskStatus.inProgress);
    });

    test("finished statuses should have no next status", () {
      expect(TaskStatus.done.nextStatus, null);
      expect(TaskStatus.cancelled.nextStatus, null);
    });

    test("initial statuses should have no previous status", () {
      expect(TaskStatus.backlog.previousStatus, null);
      expect(TaskStatus.cancelled.previousStatus, null);
    });
  });
}
