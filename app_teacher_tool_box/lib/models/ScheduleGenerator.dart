import 'dart:math';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';

class ScheduleGenerator {
  StudentGroup studentGroups;
  ActivityGroup activityGroups;

  Map<Activity, Map<int, List<Student>>> schedule = {};

  ScheduleGenerator(this.studentGroups, this.activityGroups);

  void generateScheduleUsingSimulatedAnnealing() {
    // Initialisation
    Map<Activity, Map<int, List<Student>>> currentSolution = {};
    // ... (autres initialisations)

    double temperature = 1000; // Température initiale
    double coolingRate = 0.99; // Taux de refroidissement

    while (temperature > 0.1) {
      // Critère d'arrêt (par exemple)
      // Générer un voisinage de la solution actuelle (par exemple, en échangeant des étudiants entre activités)
      Map<Activity, Map<int, List<Student>>> newSolution =
          generateNeighboringSolution(currentSolution);

      // Calculer la différence de coût entre la nouvelle solution et la solution actuelle
      double currentCost =
          calculateCost(currentSolution); // Votre fonction de coût actuelle
      double newCost = calculateCost(newSolution);

      // Si la nouvelle solution est meilleure ou en fonction de la probabilité, accepter la nouvelle solution
      if (newCost < currentCost ||
          shouldAcceptNewSolution(currentCost, newCost, temperature)) {
        currentSolution = newSolution;
      }

      // Refroidissement
      temperature *= coolingRate;
    }

    this.schedule = currentSolution;
  }

  // ... (autres méthodes existantes)

  Map<Activity, Map<int, List<Student>>> generateNeighboringSolution(
      Map<Activity, Map<int, List<Student>>> currentSolution) {
    Map<Activity, Map<int, List<Student>>> newSolution =
        {}; // Nouvelle solution voisine

    // Copier la solution actuelle dans la nouvelle solution
    for (var activity in currentSolution.keys) {
      newSolution[activity] = {};
      for (var state in currentSolution[activity]!.keys) {
        newSolution[activity]![state] =
            List.from(currentSolution[activity]![state]!);
      }
    }

    // Répéter l'opération d'échange jusqu'à ce qu'un nombre maximum de tentatives soit atteint
    int maxAttempts = 1000;
    int attempts = 0;

    while (attempts < maxAttempts) {
      // Sélectionner une activité et un état aléatoirement
      Activity randomActivity =
          newSolution.keys.elementAt(Random().nextInt(newSolution.length));
      int randomState = newSolution[randomActivity]!
          .keys
          .elementAt(Random().nextInt(newSolution[randomActivity]!.length));

      // Sélectionner un étudiant aléatoirement dans cet état
      List<Student> studentsInState =
          newSolution[randomActivity]![randomState]!;
      if (studentsInState.isEmpty) {
        attempts++;
        continue;
      }
      Student randomStudent =
          studentsInState[Random().nextInt(studentsInState.length)];

      // Trouver les activités non encore faites par l'étudiant
      List<Activity> remainingActivities = [];
      for (var activity in activityGroups.activities) {
        if (!randomStudent.activities.contains(activity)) {
          remainingActivities.add(activity);
        }
      }

      // Choisir une activité parmi celles non encore faites
      Activity? chosenActivity = remainingActivities.isEmpty
          ? null
          : remainingActivities[Random().nextInt(remainingActivities.length)];

      if (chosenActivity != null) {
        int participantsCount =
            newSolution[chosenActivity]![randomState]?.length ?? 0;
        if (participantsCount < chosenActivity.number_students) {
          // Ajouter l'étudiant à la nouvelle activité et le retirer de l'ancienne
          newSolution[chosenActivity]![randomState]!.add(randomStudent);
          newSolution[randomActivity]![randomState]!.remove(randomStudent);
          randomStudent.activities.remove(randomActivity);
          randomStudent.activities.add(chosenActivity);
          break; // Sortir de la boucle, car un échange a été effectué
        }
      }

      attempts++;
    }

    return newSolution;
  }

  double calculateCost(Map<Activity, Map<int, List<Student>>> solution) {
    int totalStates = solution.values.first.length; // Nombre total d'états
    int totalStudents =
        studentGroups.students.length; // Nombre total d'étudiants
    int studentsWithGaps =
        countStudentsWithGaps(solution); // Nombre d'étudiants avec des trous

    // Vous pouvez attribuer des poids différents à ces critères en fonction de leur importance
    double weightStates = 1.0; // Poids pour le nombre d'états
    double weightGaps = 1.0; // Poids pour le nombre d'étudiants avec des trous

    // Calculer le coût total en combinant les critères pondérés
    double cost =
        (weightStates * totalStates) + (weightGaps * studentsWithGaps);

    return cost;
  }

  int countStudentsWithGaps(Map<Activity, Map<int, List<Student>>> solution) {
    int studentsWithGaps = 0;

    for (var student in studentGroups.students) {
      bool hasGaps = true;
      for (var state in solution.values.first.keys) {
        bool foundActivity = false;
        for (var activitiesByState in solution.values) {
          if (activitiesByState[state]!.any((s) => s == student)) {
            foundActivity = true;
            break;
          }
        }
        if (!foundActivity) {
          hasGaps = false;
          break;
        }
      }
      if (!hasGaps) {
        studentsWithGaps++;
      }
    }

    return studentsWithGaps;
  }

  bool shouldAcceptNewSolution(
      double currentCost, double newCost, double temperature) {
    if (newCost < currentCost) {
      return true; // Accepter la nouvelle solution si elle est meilleure
    }

    double probability = exp((currentCost - newCost) / temperature);
    double randomValue = Random().nextDouble(); // Valeur aléatoire entre 0 et 1

    // Accepter la nouvelle solution avec une probabilité égale à "probability"
    return randomValue < probability;
  }
}
