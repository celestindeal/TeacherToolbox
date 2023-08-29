import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
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

  @override
  void initState() {
    super.initState();
    selectedStudentGroup = widget.studentGroups.isNotEmpty
        ? widget.studentGroups.first
        : StudentGroup('', []); // Remplacez les valeurs par défaut appropriées
    selectedActivityGroup = widget.activityGroups.isNotEmpty
        ? widget.activityGroups.first
        : ActivityGroup('', []); // Remplacez les valeurs par défaut appropriées
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
                // Appeler votre algorithme ici et afficher le planning
                // (code à ajouter)
              },
              child: Text('Generate Workshop'),
            ),
            // Affichage du planning (code à ajouter)
          ],
        ),
      ),
    );
  }
}
