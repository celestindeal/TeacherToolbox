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
  Map<Activity, Map<int, List<Student>>> schedule = {};

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
                ScheduleGenerator scheduleGenerator = ScheduleGenerator(
                  selectedStudentGroup,
                  selectedActivityGroup,
                );
                scheduleGenerator.generateSchedule();
                setState(() {
                  schedule = scheduleGenerator.schedule;
                });
              },
              child: Text('Generate Workshop'),
            ),
            schedule.length != 0
                ? Container(
                    height: 300, // Adjust the height as per your needs
                    child: Table(
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      children: [
                        TableRow(
                          children: [
                            TableCell(child: Text('Activity')),
                            for (var i = 1; i <= getMaxStates(schedule); i++)
                              TableCell(child: Text('State $i')),
                          ],
                        ),
                        for (var activityEntry in schedule.entries)
                          TableRow(
                            children: [
                              TableCell(child: Text(activityEntry.key.name)),
                              for (var i = 1; i <= getMaxStates(schedule); i++)
                                TableCell(
                                  child: activityEntry.value.containsKey(i)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: activityEntry.value[i]!
                                              .map((student) => Text(
                                                  '${student.firstName} ${student.lastName}'))
                                              .toList(),
                                        )
                                      : Container(), // empty cell if state doesn't exist for activity
                                ),
                            ],
                          ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
