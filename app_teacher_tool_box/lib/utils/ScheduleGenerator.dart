// ignore_for_file: file_names

import 'dart:math';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/PlanningError.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';

class GenerateurEmploiDuTemps {
  // Note: Vous pouvez conserver la méthode de recuit simulé si vous envisagez de l'implémenter plus tard.

  /// Génère un emploi du temps en utilisant la force brute.
  static List<List<List<int>>> genererForceBrute(
      StudentGroup groupeEtudiants, ActivityGroup groupeActivites) {
    _controlerPossibilite(groupeActivites, groupeEtudiants);

    final planning = List.generate(
        groupeActivites.activities.length, (index) => <List<int>>[]);

    int indexStage = 0;

    _initialiserListeActiviteEtudiants(groupeEtudiants);

    while (!_estSolutionValide(groupeActivites, groupeEtudiants) &&
        indexStage < 20) {
      _ajouterNouvelEtat(planning);

      int nbTour = 0;
      int nbEtudiantPlace = 0;

      while (nbEtudiantPlace != groupeEtudiants.students.length &&
          nbTour < 10000) {
        nbTour++;
        _reinitialiserEtudiantsEtActivites(
            groupeEtudiants, planning, indexStage, groupeActivites);
        nbEtudiantPlace = _placerEtudiantsDansActivites(
            groupeEtudiants, groupeActivites, planning, indexStage);
      }
      if (nbTour == 10000) {
        throw PlanningError(
            "Impossible de générer un emploi du temps avec les contraintes données.");
      }

      indexStage++;
    }

    return planning;
  }

  static void _controlerPossibilite(
      ActivityGroup groupeActivites, StudentGroup groupeEtudiants) {
    for (var activite in groupeActivites.activities) {
      if (activite.number_students > groupeEtudiants.students.length) {
        throw PlanningError(
            "Le nombre d'étudiants dans l'activité ${activite.name} est supérieur au nombre d'étudiants dans le groupe.");
      }
    }

    if (groupeActivites.getNumberOfStudents() <
        groupeEtudiants.students.length) {
      throw PlanningError(
          "Le nombre d'étudiants est supérieur au nombre total possible dans les activités.");
    }
  }

  static void _initialiserListeActiviteEtudiants(StudentGroup groupeEtudiants) {
    for (final etudiant in groupeEtudiants.students) {
      etudiant.activities = [];
    }
  }

  static void _ajouterNouvelEtat(List<List<List<int>>> planning) {
    for (var element in planning) {
      element.add([]);
    }
  }

  static void _reinitialiserEtudiantsEtActivites(
      StudentGroup groupeEtudiants,
      List<List<List<int>>> planning,
      int indexStage,
      ActivityGroup groupeActivites) {
    for (var etudiant in groupeEtudiants.students) {
      if (etudiant.activities.length > indexStage) {
        etudiant.activities.removeAt(indexStage);
      }
    }
    for (var activite in groupeActivites.activities) {
      planning[activite.id][indexStage].clear();
    }
  }

  static int _placerEtudiantsDansActivites(
      StudentGroup groupeEtudiants,
      ActivityGroup groupeActivites,
      List<List<List<int>>> planning,
      int indexStage) {
    int nbEtudiantPlace = 0;

    final etudiants = List.from(groupeEtudiants.students);
    etudiants.shuffle(Random());

    for (final etudiant in etudiants) {
      final sortedActivities = List.from(groupeActivites.activities)
        ..sort((a, b) => a.number_students.compareTo(b.number_students));

      for (final activite in sortedActivities) {
        if (_peutPlacerEtudiant(activite, etudiant, planning, indexStage)) {
          planning[activite.id][indexStage].add(etudiant.id);
          etudiant.activities.add(activite);
          nbEtudiantPlace++;
          break;
        }
      }
    }

    return nbEtudiantPlace;
  }

  static bool _peutPlacerEtudiant(Activity activite, Student etudiant,
      List<List<List<int>>> planning, int indexStage) {
    return !etudiant.activities.contains(activite) &&
        !planning[activite.id][indexStage].contains(etudiant.id) &&
        activite.number_students > planning[activite.id][indexStage].length;
  }

  static bool _estSolutionValide(
      ActivityGroup groupeActivites, StudentGroup groupeEtudiants) {
    for (final etudiant in groupeEtudiants.students) {
      if (etudiant.activities.length != groupeActivites.activities.length) {
        return false;
      }
    }
    return true;
  }
}
