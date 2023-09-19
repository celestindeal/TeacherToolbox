import 'dart:math';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';

class GenerateurEmploiDuTemps {
  // La première liste représente l'activité.
  // La deuxième liste représente les stages.
  // La troisième liste représente les étudiants.
  late List<List<List<int>>> planning = [[]];

  GenerateurEmploiDuTemps();

  void genererEmploiDuTempsAvecRecuitSimule() {
    // L'implémentation du recuit simulé n'est pas fournie.
  }

  // Générer un emploi du temps en utilisant la force brute.
  void genererForce(
      StudentGroup groupeEtudiants, ActivityGroup groupeActivites) {
    planning.clear();
    planning = List.generate(
        groupeActivites.activities.length, (index) => <List<int>>[]);

    int indexStage = 0;

    // Continuer à générer la solution jusqu'à ce qu'une solution valide soit trouvée
    // ou que l'indexEtat dépasse une limite prédéfinie.
    while (
        !solutionValide(groupeActivites, groupeEtudiants) && indexStage < 10) {
      // Ajouter un nouvel état.
      planning.forEach((element) {
        element.add([]);
      });

      for (Student etudiant in groupeEtudiants.students) {
        // Tenter de placer l'étudiant dans une activité.
        for (Activity activite in groupeActivites.activities) {
          // Contrôler que l'étudiant n'a pas déjà participé à l'activité.
          // Qu'il reste de la place dans cette activité.

          if (!etudiant.activities.contains(activite) &&
              !planning[activite.id][indexStage].contains(etudiant.id) &&
              activite.number_students >
                  planning[activite.id][indexStage].length) {
            // Attribuer l'étudiant à l'activité dans l'état actuel.
            planning[activite.id][indexStage].add(etudiant.id);
            etudiant.activities.add(activite);
            break; // Arrêter après avoir attribué l'étudiant à une activité dans l'état actuel.
          }
        }
      }
      indexStage++;
    }
  }

  bool solutionValide(
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
