import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/ScheduleGenerator.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';
import 'package:app_teacher_tool_box/utils/export.dart';
import 'package:flutter/material.dart';

class WorkshopScreen extends StatefulWidget {
  final List<StudentGroup> studentGroups;
  final List<ActivityGroup> activityGroups;

  WorkshopScreen({
    required this.studentGroups,
    required this.activityGroups,
  });

  @override
  _WorkshopScreenState createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  late StudentGroup selectedStudentGroup;
  late ActivityGroup selectedActivityGroup;
  late StudentGroup studentGroupPlanning;
  late ActivityGroup activityGroupPlanning;
  // la première list est l'activity
  // la deuxième list est les state
  // la troisième list est les étudients
  late List<List<List<int>>> planning = [];

  @override
  void initState() {
    super.initState();
    selectedStudentGroup = widget.studentGroups.isNotEmpty
        ? widget.studentGroups.first
        : StudentGroup('', []);
    selectedActivityGroup = widget.activityGroups.isNotEmpty
        ? widget.activityGroups.first
        : ActivityGroup('', []);
  }

  int getMaxStates(Map<Activity, Map<int, List<Student>>> schedule) {
    int maxStates = 0;
    for (var activity in schedule.values) {
      if (activity.keys.length > maxStates) {
        maxStates = activity.keys.length;
      }
    }
    return maxStates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emploi du temps')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Selectionner une classe et un groupe d\'activité',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            DropdownButton<StudentGroup>(
              value: selectedStudentGroup,
              onChanged: (newValue) {
                setState(() {
                  selectedStudentGroup = newValue!;
                });
              },
              items: widget.studentGroups.map<DropdownMenuItem<StudentGroup>>(
                (StudentGroup group) {
                  return DropdownMenuItem<StudentGroup>(
                    value: group,
                    child: Text(group.name),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20),
            DropdownButton<ActivityGroup>(
              value: selectedActivityGroup,
              onChanged: (newValue) {
                setState(() {
                  selectedActivityGroup = newValue!;
                });
              },
              items: widget.activityGroups.map<DropdownMenuItem<ActivityGroup>>(
                (ActivityGroup group) {
                  return DropdownMenuItem<ActivityGroup>(
                    value: group,
                    child: Text(group.name),
                  );
                },
              ).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (planning.isEmpty ||
                    selectedStudentGroup != studentGroupPlanning ||
                    selectedActivityGroup != activityGroupPlanning) {
                  planning.clear();
                  studentGroupPlanning = selectedStudentGroup;
                  activityGroupPlanning = selectedActivityGroup;
                  GenerateurEmploiDuTemps scheduleGenerator =
                      GenerateurEmploiDuTemps();
                  scheduleGenerator.genererForce(
                      studentGroupPlanning, activityGroupPlanning);
                  setState(() {
                    planning = scheduleGenerator.planning;
                  });
                }
              },
              child: const Text('Créer le planning'),
            ),
            Expanded(
                child: planning.length == 0
                    ? Container()
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Table(
                              border: TableBorder.all(color: Colors.grey),
                              children: [
                                // Titres des colonnes
                                TableRow(
                                  children: [
                                    TableCell(
                                      // Cette cellule est vide pour laisser de l'espace pour les titres des lignes.
                                      child: Container(),
                                    ),
                                    ...List.generate(
                                        planning[0].length,
                                        (index) => // Supposant que toutes les activités ont le même nombre d'états.
                                            TableCell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    'State ${index + 1}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )),
                                  ],
                                ),
                                // Lignes d'activités avec leurs titres
                                ...planning.map((activity) {
                                  return TableRow(
                                    children: [
                                      // Titre de l'activité
                                      TableCell(
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              ' ${activityGroupPlanning.getActivityById(planning.indexOf(activity)).name}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      // Cellules d'états pour l'activité
                                      ...activity.map((state) {
                                        return TableCell(
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              children: state.map((student) {
                                                return Text(
                                                    '${studentGroupPlanning.getStudentById(student).firstName} ${studentGroupPlanning.getStudentById(student).lastName}');
                                                ;
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                generateExcel(planning, selectedActivityGroup,
                                    selectedStudentGroup);
                              },
                              child: Text("Générer un Excel"),
                            )
                          ],
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}
