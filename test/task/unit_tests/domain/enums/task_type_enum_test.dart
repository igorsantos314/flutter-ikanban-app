import 'package:flutter/material.dart';
import 'package:flutter_ikanban_app/features/task/domain/enums/task_type.dart';
import 'package:flutter_ikanban_app/features/task/presentation/extensions/task_type_enum_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("TaskType enum", () {
    test("should contain all expected values", () {
      expect(TaskType.values.length, 26);
      expect(TaskType.values, containsAll([
        TaskType.feature,
        TaskType.bug,
        TaskType.improvement,
        TaskType.documentation,
        TaskType.work,
        TaskType.housework,
        TaskType.shopping,
        TaskType.maintenance,
        TaskType.health,
        TaskType.finance,
        TaskType.study,
        TaskType.personal,
        TaskType.family,
        TaskType.pet,
        TaskType.garden,
        TaskType.cooking,
        TaskType.exercise,
        TaskType.appointment,
        TaskType.travel,
        TaskType.hobby,
        TaskType.social,
        TaskType.urgent,
        TaskType.routine,
        TaskType.project,
        TaskType.gift,
        TaskType.call,
      ]));
    });

    test("should have correct typeValue values", () {
      expect(TaskType.feature.typeValue, 0);
      expect(TaskType.bug.typeValue, 1);
      expect(TaskType.improvement.typeValue, 2);
      expect(TaskType.documentation.typeValue, 3);
      expect(TaskType.work.typeValue, 4);
      expect(TaskType.housework.typeValue, 5);
      expect(TaskType.shopping.typeValue, 6);
      expect(TaskType.maintenance.typeValue, 7);
      expect(TaskType.health.typeValue, 8);
      expect(TaskType.finance.typeValue, 9);
      expect(TaskType.study.typeValue, 10);
      expect(TaskType.personal.typeValue, 11);
      expect(TaskType.family.typeValue, 12);
      expect(TaskType.pet.typeValue, 13);
      expect(TaskType.garden.typeValue, 14);
      expect(TaskType.cooking.typeValue, 15);
      expect(TaskType.exercise.typeValue, 16);
      expect(TaskType.appointment.typeValue, 17);
      expect(TaskType.travel.typeValue, 18);
      expect(TaskType.hobby.typeValue, 19);
      expect(TaskType.social.typeValue, 20);
      expect(TaskType.urgent.typeValue, 21);
      expect(TaskType.routine.typeValue, 22);
      expect(TaskType.project.typeValue, 23);
      expect(TaskType.gift.typeValue, 24);
      expect(TaskType.call.typeValue, 25);
    });

    test("should have correct display values", () {
      expect(TaskType.feature.displayName, "Nova Funcionalidade");
      expect(TaskType.bug.displayName, "Correção de Bug");
      expect(TaskType.improvement.displayName, "Melhoria");
      expect(TaskType.documentation.displayName, "Documentação");
      expect(TaskType.work.displayName, "Trabalho");
      expect(TaskType.housework.displayName, "Trabalho Doméstico");
      expect(TaskType.shopping.displayName, "Compras");
      expect(TaskType.maintenance.displayName, "Manutenção");
      expect(TaskType.health.displayName, "Saúde");
      expect(TaskType.finance.displayName, "Financeiro");
      expect(TaskType.study.displayName, "Estudos");
      expect(TaskType.personal.displayName, "Pessoal");
      expect(TaskType.family.displayName, "Família");
      expect(TaskType.pet.displayName, "Pet");
      expect(TaskType.garden.displayName, "Jardim");
      expect(TaskType.cooking.displayName, "Culinária");
      expect(TaskType.exercise.displayName, "Exercício");
      expect(TaskType.appointment.displayName, "Compromisso");
      expect(TaskType.travel.displayName, "Viagem");
      expect(TaskType.hobby.displayName, "Hobby");
      expect(TaskType.social.displayName, "Social");
      expect(TaskType.urgent.displayName, "Urgente");
      expect(TaskType.routine.displayName, "Rotina");
      expect(TaskType.project.displayName, "Projeto");
      expect(TaskType.gift.displayName, "Presente");
      expect(TaskType.call.displayName, "Ligação");
    });

    test("should have correct description values", () {
      expect(TaskType.feature.description, "Tarefa relacionada ao desenvolvimento de software");
      expect(TaskType.bug.description, "Tarefa relacionada ao desenvolvimento de software");
      expect(TaskType.improvement.description, "Tarefa relacionada ao desenvolvimento de software");
      expect(TaskType.documentation.description, "Tarefa relacionada a documentação");
      expect(TaskType.work.description, "Tarefa relacionada ao trabalho");
      expect(TaskType.housework.description, "Limpeza, organização e tarefas domésticas");
      expect(TaskType.shopping.description, "Lista de compras e itens a comprar");
      expect(TaskType.maintenance.description, "Reparos e manutenção da casa");
      expect(TaskType.health.description, "Saúde, exercícios e bem-estar");
      expect(TaskType.finance.description, "Contas, pagamentos e finanças");
      expect(TaskType.study.description, "Estudos, cursos e aprendizado");
      expect(TaskType.personal.description, "Autocuidado e desenvolvimento pessoal");
      expect(TaskType.family.description, "Atividades e compromissos familiares");
      expect(TaskType.pet.description, "Cuidados com animais de estimação");
      expect(TaskType.garden.description, "Jardinagem e cuidado com plantas");
      expect(TaskType.cooking.description, "Receitas, refeições e culinária");
      expect(TaskType.exercise.description, "Atividades físicas e treinos");
      expect(TaskType.appointment.description, "Consultas, reuniões e compromissos");
      expect(TaskType.travel.description, "Planejamento e organização de viagens");
      expect(TaskType.hobby.description, "Hobbies e atividades de lazer");
      expect(TaskType.social.description, "Eventos sociais e encontros");
      expect(TaskType.urgent.description, "Tarefas urgentes e prioritárias");
      expect(TaskType.routine.description, "Tarefas do dia a dia e rotinas");
      expect(TaskType.project.description, "Projetos pessoais e ideias");
      expect(TaskType.gift.description, "Presentes para comprar ou fazer");
      expect(TaskType.call.description, "Ligações e contatos a fazer");
    });

    test("should have correct icon values", () {
      expect(TaskType.feature.icon, Icons.star);
      expect(TaskType.bug.icon, Icons.bug_report);
      expect(TaskType.improvement.icon, Icons.trending_up);
      expect(TaskType.documentation.icon, Icons.description);
      expect(TaskType.work.icon, Icons.work);
      expect(TaskType.housework.icon, Icons.home_work);
      expect(TaskType.shopping.icon, Icons.shopping_cart);
      expect(TaskType.maintenance.icon, Icons.build);
      expect(TaskType.health.icon, Icons.favorite);
      expect(TaskType.finance.icon, Icons.attach_money);
      expect(TaskType.study.icon, Icons.school);
      expect(TaskType.personal.icon, Icons.person);
      expect(TaskType.family.icon, Icons.family_restroom);
      expect(TaskType.pet.icon, Icons.pets);
      expect(TaskType.garden.icon, Icons.local_florist);
      expect(TaskType.cooking.icon, Icons.restaurant);
      expect(TaskType.exercise.icon, Icons.fitness_center);
      expect(TaskType.appointment.icon, Icons.event);
      expect(TaskType.travel.icon, Icons.flight);
      expect(TaskType.hobby.icon, Icons.palette);
      expect(TaskType.social.icon, Icons.groups);
      expect(TaskType.urgent.icon, Icons.priority_high);
      expect(TaskType.routine.icon, Icons.replay);
      expect(TaskType.project.icon, Icons.lightbulb);
      expect(TaskType.gift.icon, Icons.card_giftcard);
      expect(TaskType.call.icon, Icons.phone);
    });

    test("should have correct color", () {
      expect(TaskType.feature.color, Colors.blue);
      expect(TaskType.bug.color, Colors.red);
      expect(TaskType.improvement.color, Colors.green);
      expect(TaskType.documentation.color, Colors.purple);
      expect(TaskType.work.color, Colors.indigo);
      expect(TaskType.housework.color, Colors.brown);
      expect(TaskType.shopping.color, Colors.orange);
      expect(TaskType.maintenance.color, Colors.grey);
      expect(TaskType.health.color, Colors.pink);
      expect(TaskType.finance.color, Colors.green[700]);
      expect(TaskType.study.color, Colors.indigo);
      expect(TaskType.personal.color, Colors.teal);
      expect(TaskType.family.color, Colors.amber);
      expect(TaskType.pet.color, Colors.brown[300]);
      expect(TaskType.garden.color, Colors.lightGreen);
      expect(TaskType.cooking.color, Colors.deepOrange);
      expect(TaskType.exercise.color, Colors.cyan);
      expect(TaskType.appointment.color, Colors.blue[700]);
      expect(TaskType.travel.color, Colors.lightBlue);
      expect(TaskType.hobby.color, Colors.deepPurple);
      expect(TaskType.social.color, Colors.pink[300]);
      expect(TaskType.urgent.color, Colors.red[700]);
      expect(TaskType.routine.color, Colors.blueGrey);
      expect(TaskType.project.color, Colors.yellow[700]);
      expect(TaskType.gift.color, Colors.red[300]);
      expect(TaskType.call.color, Colors.green);
    });

    test("typeValue should be unique for each TaskType", () {
      final typeValues = TaskType.values.map((e) => e.typeValue).toList();
      final uniqueTypeValues = typeValues.toSet();
      expect(typeValues.length, uniqueTypeValues.length);
    });

    test("displayName should be unique for each TaskType", () {
      final displayNames = TaskType.values.map((e) => e.displayName).toList();
      final uniqueDisplayNames = displayNames.toSet();
      expect(displayNames.length, uniqueDisplayNames.length);
    });
  });
}