import 'dart:math';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';

class ScheduleGenerator {
  // la première list est l'activity
  // la deuxième list est les state
  // la troisième list est les étudients
  late List<List<List<int>>> planning = [
    [[]]
  ];

  ScheduleGenerator();

  void generateScheduleUsingSimulatedAnnealing() {}

  // générer un planning avec un liste d'étudiant et une liste d'activity
  void generateForce(StudentGroup studentGroup, ActivityGroup activityGroup) {
    planning.clear();
    planning = List.generate(
        activityGroup.activities.length, (index) => <List<int>>[]);

    // on vas brut force state par state
    // pour chaque state on doit mettre tous les étudients
    int stateIndex = 0;
    while (valideSolution(activityGroup, studentGroup) || stateIndex < 10) {
      // on ajoute un state
      planning.forEach((element) {
        element.add([]);
      });
      // on doit mettre tous les étudients dans le state
      for (Student student in studentGroup.students) {
        // trouver une place pour l'étudient
        for (Activity activity in activityGroup.activities) {
          // si l'étudient n'est pas dans l'activity
          if (!student.activities.contains(activity)) {
            // si l'activity n'est pas dans le state
            if (!planning[activity.id][stateIndex].contains(student.id)) {
              // on ajoute l'étudient dans l'activity
              planning[activity.id][stateIndex].add(student.id);
              student.activities.add(activity);
              break;
            }
          }
        }
      }
      stateIndex++;
    }
  }

  bool valideSolution(ActivityGroup activityGroup, StudentGroup studentGroup) {
    // tous les etudients doivent avoir le bon nombre d'activity
    for (Student student in studentGroup.students) {
      if (student.activities.length != activityGroup.activities.length) {
        return false;
      }
    }
    return true;
  }
}
