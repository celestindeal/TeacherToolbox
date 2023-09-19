import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/ScheduleGenerator.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';
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
      appBar: AppBar(title: Text('Workshop')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Select Student Group and Activity Group',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          DropdownButton<StudentGroup>(
            value: selectedStudentGroup,
            hint: Text('Select Student Group'),
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
            hint: Text('Select Activity Group'),
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
              GenerateurEmploiDuTemps scheduleGenerator =
                  GenerateurEmploiDuTemps();
              scheduleGenerator.genererForce(
                  selectedStudentGroup, selectedActivityGroup);
              print("Planning: ${scheduleGenerator.planning}");
              setState(() {
                planning = scheduleGenerator.planning;
              });
            },
            child: Text('Generate Workshop'),
          ),
          Expanded(
              child: planning.length == 0
                  ? Container()
                  : SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        children: planning.map((activity) {
                          return TableRow(
                            children: activity.map((state) {
                              return TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: state.map((student) {
                                      return Text(selectedStudentGroup
                                          .getStudentById(student)
                                          .lastName);
                                    }).toList(),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ))
        ],
      ),
    );
  }
}
