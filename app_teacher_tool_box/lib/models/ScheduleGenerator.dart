import 'dart:math';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';
import 'package:collection/collection.dart';

class ScheduleGenerator {
  StudentGroup studentGroups;
  ActivityGroup activityGroups;

  Map<Activity, Map<int, List<Student>>> schedule = {};

  ScheduleGenerator(this.studentGroups, this.activityGroups);

  bool areListsEqual(List<Student> list1, List<Student> list2) {
    if (list1.length != list2.length) {
      return false;
    }

    var listEquality = ListEquality<Student>();
    return listEquality.equals(list1, list2);
  }

  bool isSolution(Map<Activity, Map<int, List<Student>>> schedule) {
    // pour chaque étudiant
    for (Map<int, List<Student>> listStudents in schedule.values) {
      // faire la list de toute les etudiant qui font cette activité
      List<Student> student = [];
      for (int state in listStudents.keys) {
        student.addAll(listStudents[state]!);
      }
      if (!areListsEqual(student, studentGroups.students)) {
        return false;
      }
    }
    // la solution est valide
    print("solution valide");
    return true;
  }

void generateSchedule() {
  Map<Activity, Map<int, List<Student>>> newSchedule = {};

  for (Activity activity in activityGroups.activities) {
    newSchedule[activity] = {};
  }

  List<Student> allStudents = List.from(studentGroups.students);
  int state = 1;

  // Continuez à créer des états tant que tous les étudiants n'ont pas participé à toutes les activités
  while (anyStudentHasPendingActivities(allStudents)) {
    // Pour chaque étudiant, essayez de le placer dans une activité pour cet état
    for (Student student in List.from(allStudents)) {
      for (Activity activity in activityGroups.activities) {
        if (!student.activities.contains(activity)) {
          int currentParticipants = newSchedule[activity]![state]?.length ?? 0;

          if (currentParticipants < activity.number_students) {
            if (newSchedule[activity]![state] == null) {
              newSchedule[activity]![state] = [];
            }
            
            newSchedule[activity]![state]!.add(student);
            student.activities.add(activity);
            break; // L'étudiant a été placé pour cet état, passer à l'étudiant suivant
          }
        }
      }
    }

    state++;
  }

  this.schedule = newSchedule;
}

bool anyStudentHasPendingActivities(List<Student> students) {
  for (Student student in students) {
    if (student.activities.length < activityGroups.activities.length) {
      return true;
    }
  }
  return false;
}

}
