import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/utils/localActivityManager.dart';
import 'package:flutter/material.dart';

class EditActivityScreen extends StatefulWidget {
  ActivityGroup activityGroup;

  EditActivityScreen({required this.activityGroup});

  @override
  _EditActivityScreenState createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  late TextEditingController classNameController;
  List<TextEditingController> activityNameControllers = [];
  List<TextEditingController> activityNbStudentsControllers = [];
  String lastName = '';

  @override
  void initState() {
    super.initState();
    classNameController =
        TextEditingController(text: widget.activityGroup.name);
    lastName = widget.activityGroup.name;
    for (var activities in widget.activityGroup.activities) {
      activityNameControllers.add(TextEditingController(text: activities.name));
      activityNbStudentsControllers.add(
          TextEditingController(text: activities.number_students.toString()));
    }
  }

  @override
  void dispose() {
    // nétoyer et libérer la mémoire
    classNameController.dispose();
    for (var controller in activityNameControllers) {
      controller.dispose();
    }
    for (var controller in activityNbStudentsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier l\'activité')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: classNameController,
              onChanged: (value) {
                widget.activityGroup.name = value;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: buildStudentFields(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.activityGroup.activities.add(Activity(
                      '', 0, true, widget.activityGroup.activities.length));
                  activityNameControllers.add(TextEditingController());
                  activityNbStudentsControllers.add(TextEditingController());
                });
              },
              child: Text('Ajouter une activité'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save changes and navigate back
                saveChanges(lastName);
              },
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildStudentFields() {
    List<Widget> fields = [];
    for (int i = 0; i < activityNameControllers.length; i++) {
      fields.add(buildStudentField(i));
    }
    return fields;
  }

  Widget buildStudentField(int index) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text('${index + 1} '),
            SizedBox(
                width: 10), // Espacement entre le numéro et le champ de prénom
            Expanded(
              child: TextField(
                controller: activityNameControllers[index],
                onChanged: (value) {
                  // Update the corresponding student's first name
                  widget.activityGroup.activities[index].name = value;
                },
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
                width: 10), // Espacement entre les champs de prénom et de nom
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: activityNbStudentsControllers[index],
                onChanged: (value) {
                  // Update the corresponding student's last name
                  widget.activityGroup.activities[index].number_students =
                      int.parse(value);
                },
                decoration: InputDecoration(
                  labelText: 'Nombre d\'élèves',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.activityGroup.activities.removeAt(index);
                  activityNameControllers.removeAt(index);
                  activityNbStudentsControllers.removeAt(index);
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: Text('Supprimer', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  void saveChanges(String lastName) {
    ActivityDataManager.updateActivityGroupLocally(
        widget.activityGroup, lastName);
    Navigator.pop(context, widget.activityGroup);
  }
}
