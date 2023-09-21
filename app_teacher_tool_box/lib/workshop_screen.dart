import 'package:app_teacher_tool_box/models/Sudent.dart';
import 'package:flutter/material.dart';
import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/ScheduleGenerator.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/utils/export.dart';

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
  StudentGroup selectedStudentGroup = StudentGroup('', []);
  ActivityGroup selectedActivityGroup = ActivityGroup('', []);
  StudentGroup studentGroup = StudentGroup('', []);
  ActivityGroup activityGroup = ActivityGroup('', []);
  List<List<List<int>>> planning = [];

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

  Widget _buildClassSelectionDropdown() {
    return DropdownButton<StudentGroup>(
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
    );
  }

  Widget _buildActivitySelectionDropdown() {
    return DropdownButton<ActivityGroup>(
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
    );
  }

  Widget _buildCreatePlanningButton() {
    return ElevatedButton(
      onPressed: () {
        if (selectedStudentGroup != studentGroup ||
            selectedActivityGroup != activityGroup) {
          studentGroup = selectedStudentGroup;
          activityGroup = selectedActivityGroup;
          setState(() {
            planning = GenerateurEmploiDuTemps.genererForce(
              studentGroup,
              activityGroup,
            );
          });
        }
      },
      child: const Text('Créer le planning'),
    );
  }

  Widget _buildPlanningTable() {
    return planning.isEmpty
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
                          child: Container(),
                        ),
                        ...List.generate(
                          planning[0].length,
                          (index) {
                            return TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'State ${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    // Lignes d'activités avec leurs titres
                    ...planning.map((activity) {
                      return TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                ' ${activityGroup.getActivityById(planning.indexOf(activity)).name}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          ...activity.map((state) {
                            return TableCell(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: state.map((student) {
                                    return Text(
                                      '${studentGroup.getStudentById(student).firstName} ${studentGroup.getStudentById(student).lastName}',
                                    );
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
                    generateExcel(planning, activityGroup, studentGroup);
                  },
                  child: Text("Générer un Excel"),
                ),
              ],
            ),
          );
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
              'Sélectionner une classe et un groupe d\'activité',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            _buildClassSelectionDropdown(),
            SizedBox(height: 20),
            _buildActivitySelectionDropdown(),
            SizedBox(height: 20),
            _buildCreatePlanningButton(),
            Expanded(
              child: _buildPlanningTable(),
            ),
          ],
        ),
      ),
    );
  }
}
