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
      expect(TaskType.feature.displayName, "Feature");
      expect(TaskType.bug.displayName, "Bug");
      expect(TaskType.improvement.displayName, "Improvement");
      expect(TaskType.documentation.displayName, "Documentation");
      expect(TaskType.work.displayName, "Work");
      expect(TaskType.housework.displayName, "Housework");
      expect(TaskType.shopping.displayName, "Shopping");
      expect(TaskType.maintenance.displayName, "Maintenance");
      expect(TaskType.health.displayName, "Health");
      expect(TaskType.finance.displayName, "Finance");
      expect(TaskType.study.displayName, "Study");
      expect(TaskType.personal.displayName, "Personal");
      expect(TaskType.family.displayName, "Family");
      expect(TaskType.pet.displayName, "Pet");
      expect(TaskType.garden.displayName, "Garden");
      expect(TaskType.cooking.displayName, "Cooking");
      expect(TaskType.exercise.displayName, "Exercise");
      expect(TaskType.appointment.displayName, "Appointment");
      expect(TaskType.travel.displayName, "Travel");
      expect(TaskType.hobby.displayName, "Hobby");
      expect(TaskType.social.displayName, "Social");
      expect(TaskType.urgent.displayName, "Urgent");
      expect(TaskType.routine.displayName, "Routine");
      expect(TaskType.project.displayName, "Project");
      expect(TaskType.gift.displayName, "Gift");
      expect(TaskType.call.displayName, "Call");
    });

    test("should have correct description values", () {
      expect(TaskType.feature.description, "A new feature to be added.");
      expect(TaskType.bug.description, "A bug that needs to be fixed.");
      expect(TaskType.improvement.description, "An improvement to existing functionality.");
      expect(TaskType.documentation.description, "Documentation related task.");
      expect(TaskType.work.description, "Work related task.");
      expect(TaskType.housework.description, "Household chores.");
      expect(TaskType.shopping.description, "Shopping related task.");
      expect(TaskType.maintenance.description, "Maintenance task.");
      expect(TaskType.health.description, "Health related task.");
      expect(TaskType.finance.description, "Finance related task.");
      expect(TaskType.study.description, "Study related task.");
      expect(TaskType.personal.description, "Personal task.");
      expect(TaskType.family.description, "Family related task.");
      expect(TaskType.pet.description, "Pet care task.");
      expect(TaskType.garden.description, "Gardening task.");
      expect(TaskType.cooking.description, "Cooking related task.");
      expect(TaskType.exercise.description, "Exercise related task.");
      expect(TaskType.appointment.description, "Appointment related task.");
      expect(TaskType.travel.description, "Travel related task.");
      expect(TaskType.hobby.description, "Hobby related task.");
      expect(TaskType.social.description, "Social activity task.");
      expect(TaskType.urgent.description, "Urgent task that needs immediate attention.");
      expect(TaskType.routine.description, "Routine daily task.");
      expect(TaskType.project.description, "Project related task.");
      expect(TaskType.gift.description, "Gift related task.");
      expect(TaskType.call.description, "Phone call related task.");
    });

    test("should have correct icon values", () {
      expect(TaskType.feature.icon, Icons.star);
      expect(TaskType.bug.icon, Icons.bug_report);
      expect(TaskType.improvement.icon, Icons.thumb_up);
      expect(TaskType.documentation.icon, Icons.description);
      expect(TaskType.work.icon, Icons.work);
      expect(TaskType.housework.icon, Icons.home);
      expect(TaskType.shopping.icon, Icons.shopping_cart);
      expect(TaskType.maintenance.icon, Icons.build);
      expect(TaskType.health.icon, Icons.health_and_safety);
      expect(TaskType.finance.icon, Icons.attach_money);
      expect(TaskType.study.icon, Icons.book);
      expect(TaskType.personal.icon, Icons.person);
      expect(TaskType.family.icon, Icons.family_restroom);
      expect(TaskType.pet.icon, Icons.pets);
      expect(TaskType.garden.icon, Icons.park);
      expect(TaskType.cooking.icon, Icons.kitchen);
      expect(TaskType.exercise.icon, Icons.fitness_center);
      expect(TaskType.appointment.icon, Icons.event);
      expect(TaskType.travel.icon, Icons.travel_explore);
      expect(TaskType.hobby.icon, Icons.palette);
      expect(TaskType.social.icon, Icons.group);
      expect(TaskType.urgent.icon, Icons.warning);
      expect(TaskType.routine.icon, Icons.schedule);
      expect(TaskType.project.icon, Icons.business_center);
      expect(TaskType.gift.icon, Icons.card_giftcard);
      expect(TaskType.call.icon, Icons.call);
    });

    test("should have correct color", () {
      expect(TaskType.feature.color, Colors.blue);
      expect(TaskType.bug.color, Colors.red);
      expect(TaskType.improvement.color, Colors.green);
      expect(TaskType.documentation.color, Colors.orange);
      expect(TaskType.work.color, Colors.indigo);
      expect(TaskType.housework.color, Colors.brown);
      expect(TaskType.shopping.color, Colors.pink);
      expect(TaskType.maintenance.color, Colors.grey);
      expect(TaskType.health.color, Colors.teal);
      expect(TaskType.finance.color, Colors.indigo);
      expect(TaskType.study.color, Colors.cyan);
      expect(TaskType.personal.color, Colors.lime);
      expect(TaskType.family.color, Colors.amber);
      expect(TaskType.pet.color, Colors.deepOrange);
      expect(TaskType.garden.color, Colors.lightGreen);
      expect(TaskType.cooking.color, Colors.deepPurple);
      expect(TaskType.exercise.color, Colors.lightBlue);
      expect(TaskType.appointment.color, Colors.yellow);
      expect(TaskType.travel.color, Colors.blueGrey);
      expect(TaskType.hobby.color, Colors.redAccent);
      expect(TaskType.social.color, Colors.greenAccent);
      expect(TaskType.urgent.color, Colors.orangeAccent);
      expect(TaskType.routine.color, Colors.purpleAccent);
      expect(TaskType.project.color, Colors.brown[300]);
      expect(TaskType.gift.color, Colors.pinkAccent);
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

    test("description should be unique for each TaskType", () {
      final descriptions = TaskType.values.map((e) => e.description).toList();
      final uniqueDescriptions = descriptions.toSet();
      expect(descriptions.length, uniqueDescriptions.length);
    });
  });
}