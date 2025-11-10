// models/kanban_task.dart
import 'package:flutter/material.dart';

enum TaskType {
  feature,
  bug,
  improvement,
  documentation,
  work,
  housework,
  shopping,
  maintenance,
  health,
  finance,
  study,
  personal,
  family,
  pet,
  garden,
  cooking,
  exercise,
  appointment,
  travel,
  hobby,
  social,
  urgent,
  routine,
  project,
  gift,
  call,
}

extension TaskTypeExtension on TaskType {
  // Ícone para cada tipo
  IconData get icon {
    switch (this) {
      case TaskType.feature:
        return Icons.star;
      case TaskType.bug:
        return Icons.bug_report;
      case TaskType.improvement:
        return Icons.trending_up;
      case TaskType.documentation:
        return Icons.description;
      case TaskType.work:
        return Icons.work;
      case TaskType.housework:
        return Icons.home_work;
      case TaskType.shopping:
        return Icons.shopping_cart;
      case TaskType.maintenance:
        return Icons.build;
      case TaskType.health:
        return Icons.favorite;
      case TaskType.finance:
        return Icons.attach_money;
      case TaskType.study:
        return Icons.school;
      case TaskType.personal:
        return Icons.person;
      case TaskType.family:
        return Icons.family_restroom;
      case TaskType.pet:
        return Icons.pets;
      case TaskType.garden:
        return Icons.local_florist;
      case TaskType.cooking:
        return Icons.restaurant;
      case TaskType.exercise:
        return Icons.fitness_center;
      case TaskType.appointment:
        return Icons.event;
      case TaskType.travel:
        return Icons.flight;
      case TaskType.hobby:
        return Icons.palette;
      case TaskType.social:
        return Icons.groups;
      case TaskType.urgent:
        return Icons.priority_high;
      case TaskType.routine:
        return Icons.replay;
      case TaskType.project:
        return Icons.lightbulb;
      case TaskType.gift:
        return Icons.card_giftcard;
      case TaskType.call:
        return Icons.phone;
    }
  }

  // Cor para cada tipo
  Color get color {
    switch (this) {
      case TaskType.feature:
        return Colors.blue;
      case TaskType.bug:
        return Colors.red;
      case TaskType.improvement:
        return Colors.green;
      case TaskType.documentation:
        return Colors.purple;
      case TaskType.work:
        return Colors.indigo;
      case TaskType.housework:
        return Colors.brown;
      case TaskType.shopping:
        return Colors.orange;
      case TaskType.maintenance:
        return Colors.grey;
      case TaskType.health:
        return Colors.pink;
      case TaskType.finance:
        return Colors.green[700]!;
      case TaskType.study:
        return Colors.indigo;
      case TaskType.personal:
        return Colors.teal;
      case TaskType.family:
        return Colors.amber;
      case TaskType.pet:
        return Colors.brown[300]!;
      case TaskType.garden:
        return Colors.lightGreen;
      case TaskType.cooking:
        return Colors.deepOrange;
      case TaskType.exercise:
        return Colors.cyan;
      case TaskType.appointment:
        return Colors.blue[700]!;
      case TaskType.travel:
        return Colors.lightBlue;
      case TaskType.hobby:
        return Colors.deepPurple;
      case TaskType.social:
        return Colors.pink[300]!;
      case TaskType.urgent:
        return Colors.red[700]!;
      case TaskType.routine:
        return Colors.blueGrey;
      case TaskType.project:
        return Colors.yellow[700]!;
      case TaskType.gift:
        return Colors.red[300]!;
      case TaskType.call:
        return Colors.green;
    }
  }

  // Nome amigável em português
  String get displayName {
    switch (this) {
      case TaskType.feature:
        return 'Nova Funcionalidade';
      case TaskType.bug:
        return 'Correção de Bug';
      case TaskType.improvement:
        return 'Melhoria';
      case TaskType.documentation:
        return 'Documentação';
      case TaskType.work:
        return 'Trabalho';
      case TaskType.housework:
        return 'Trabalho Doméstico';
      case TaskType.shopping:
        return 'Compras';
      case TaskType.maintenance:
        return 'Manutenção';
      case TaskType.health:
        return 'Saúde';
      case TaskType.finance:
        return 'Financeiro';
      case TaskType.study:
        return 'Estudos';
      case TaskType.personal:
        return 'Pessoal';
      case TaskType.family:
        return 'Família';
      case TaskType.pet:
        return 'Pet';
      case TaskType.garden:
        return 'Jardim';
      case TaskType.cooking:
        return 'Culinária';
      case TaskType.exercise:
        return 'Exercício';
      case TaskType.appointment:
        return 'Compromisso';
      case TaskType.travel:
        return 'Viagem';
      case TaskType.hobby:
        return 'Hobby';
      case TaskType.social:
        return 'Social';
      case TaskType.urgent:
        return 'Urgente';
      case TaskType.routine:
        return 'Rotina';
      case TaskType.project:
        return 'Projeto';
      case TaskType.gift:
        return 'Presente';
      case TaskType.call:
        return 'Ligação';
    }
  }

  // Descrição do tipo
  String get description {
    switch (this) {
      case TaskType.housework:
        return 'Limpeza, organização e tarefas domésticas';
      case TaskType.shopping:
        return 'Lista de compras e itens a comprar';
      case TaskType.maintenance:
        return 'Reparos e manutenção da casa';
      case TaskType.health:
        return 'Saúde, exercícios e bem-estar';
      case TaskType.finance:
        return 'Contas, pagamentos e finanças';
      case TaskType.study:
        return 'Estudos, cursos e aprendizado';
      case TaskType.personal:
        return 'Autocuidado e desenvolvimento pessoal';
      case TaskType.family:
        return 'Atividades e compromissos familiares';
      case TaskType.pet:
        return 'Cuidados com animais de estimação';
      case TaskType.garden:
        return 'Jardinagem e cuidado com plantas';
      case TaskType.cooking:
        return 'Receitas, refeições e culinária';
      case TaskType.exercise:
        return 'Atividades físicas e treinos';
      case TaskType.appointment:
        return 'Consultas, reuniões e compromissos';
      case TaskType.travel:
        return 'Planejamento e organização de viagens';
      case TaskType.hobby:
        return 'Hobbies e atividades de lazer';
      case TaskType.social:
        return 'Eventos sociais e encontros';
      case TaskType.urgent:
        return 'Tarefas urgentes e prioritárias';
      case TaskType.routine:
        return 'Tarefas do dia a dia e rotinas';
      case TaskType.project:
        return 'Projetos pessoais e ideias';
      case TaskType.gift:
        return 'Presentes para comprar ou fazer';
      case TaskType.call:
        return 'Ligações e contatos a fazer';
      case TaskType.feature:
        return 'Tarefa relacionada ao desenvolvimento de software';
      case TaskType.bug:
        return 'Tarefa relacionada ao desenvolvimento de software';
      case TaskType.improvement:
        return 'Tarefa relacionada ao desenvolvimento de software';
      case TaskType.documentation:
        return 'Tarefa relacionada a documentação';
      case TaskType.work:
        return 'Tarefa relacionada ao trabalho';
    }
  }

  int get typeValue {
    return switch(this) {
      TaskType.feature => 0,
      TaskType.bug => 1,
      TaskType.improvement => 2,
      TaskType.documentation => 3,
      TaskType.work => 4,
      TaskType.housework => 5,
      TaskType.shopping => 6,
      TaskType.maintenance => 7,
      TaskType.health => 8,
      TaskType.finance => 9,
      TaskType.study => 10,
      TaskType.personal => 11,
      TaskType.family => 12,
      TaskType.pet => 13,
      TaskType.garden => 14,
      TaskType.cooking => 15,
      TaskType.exercise => 16,
      TaskType.appointment => 17,
      TaskType.travel => 18,
      TaskType.hobby => 19,
      TaskType.social => 20,
      TaskType.urgent => 21,
      TaskType.routine => 22,
      TaskType.project => 23,
      TaskType.gift => 24,
      TaskType.call => 25,
    };
  }
}