// ignore_for_file: file_names

import 'dart:math';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/PlanningError.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';

class GenerateurEmploiDuTemps {
  // La première liste représente l'activité.
  // La deuxième liste représente les stages.
  // La troisième liste représente les étudiants.
  // List<List<List<int>>> planning = [];

  // Rendez la classe GenerateurEmploiDuTemps statique.
  static void genererEmploiDuTempsAvecRecuitSimule() {
    // L'implémentation du recuit simulé n'est pas fournie.
  }

  // Générer un emploi du temps en utilisant la force brute.
  static List<List<List<int>>> genererForce(
      StudentGroup groupeEtudiants, ActivityGroup groupeActivites) {
    controleImposibilite(groupeActivites, groupeEtudiants);
    List<List<List<int>>> planning = [[]];
    planning = List.generate(
        groupeActivites.activities.length, (index) => <List<int>>[]);

    int indexStage = 0;

    // Init la liste activité des etudients
    for (Student etudiant in groupeEtudiants.students) {
      etudiant.activities = [];
    }

    // Continuer à générer la solution jusqu'à ce qu'une solution valide soit trouvée
    // ou que l'indexEtat dépasse une limite prédéfinie.
    while (
        !solutionValide(groupeActivites, groupeEtudiants) && indexStage < 10) {
      // Ajouter un nouvel état.
      for (var element in planning) {
        element.add([]);
      }

      int nb_tour = 0;
      int nb_sudent_place =
          0; // Continuer à générer la solution jusqu'à ce que tous les étudiants soient placés.
      while (
          nb_sudent_place != groupeEtudiants.students.length && nb_tour < 100) {
        nb_sudent_place = 0;
        nb_tour++;

        // Nettoyer la liste d'activités des étudiants et la liste des étudiants dans les activités qui ont été attribuées dans l'état précédent.
        reinitialiserEtudiantsEtActivites(
            groupeEtudiants, planning, indexStage, groupeActivites);

        // Mélanger la liste des étudiants.
        List<Student> etudiants = List.from(groupeEtudiants.students);
        etudiants.shuffle(Random());

        nb_sudent_place = placerEtudiantsDansActivites(
            etudiants, groupeActivites, planning, indexStage);
      }

      indexStage++;
    }
    return planning;
  }

  static void reinitialiserEtudiantsEtActivites(
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

  static void controleImposibilite(
      ActivityGroup groupeActivites, StudentGroup groupeEtudiants) {
    for (var activite in groupeActivites.activities) {
      if (activite.number_students > groupeEtudiants.students.length) {
        throw PlanningError(
            "Le nombre d'étudiants dans l'activité ${activite.name} est supérieur au nombre d'étudiants dans le groupe d'étudiants.");
      }
    }

    if (groupeActivites.getNumberOfStudents() <
        groupeEtudiants.students.length) {
      throw PlanningError(
          "Le nombre d'étudiants est supérieur au nombre d'étudiants possible dans les activités.");
    }
  }

  static int placerEtudiantsDansActivites(
      List<Student> etudiants,
      ActivityGroup groupeActivites,
      List<List<List<int>>> planning,
      int indexStage) {
    int nb_sudent_place = 0;
    for (var etudiant in etudiants) {
      var sortedActivities = List.from(groupeActivites.activities)
        ..sort((a, b) => a.number_students.compareTo(b.number_students));

      for (var activite in sortedActivities) {
        if (!etudiant.activities.contains(activite) &&
            !planning[activite.id][indexStage].contains(etudiant.id) &&
            activite.number_students >
                planning[activite.id][indexStage].length) {
          planning[activite.id][indexStage].add(etudiant.id);
          etudiant.activities.add(activite);
          nb_sudent_place++;
          break;
        }
      }
    }
    return nb_sudent_place;
  }

  static bool solutionValide(
      ActivityGroup groupeActivites, StudentGroup groupeEtudiants) {
    // Chaque étudiant doit avoir participé à toutes les activités.
    for (Student etudiant in groupeEtudiants.students) {
      if (etudiant.activities.length != groupeActivites.activities.length) {
        return false;
      }
    }
    return true;
  }
}
