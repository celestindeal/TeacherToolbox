import 'package:app_teacher_tool_box/models/Sudent.dart';
import 'package:app_teacher_tool_box/utils/localStudentsManager.dart';
import 'package:flutter/material.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';

class EditClassScreen extends StatefulWidget {
  final StudentGroup studentGroup;

  EditClassScreen({required this.studentGroup});

  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  late TextEditingController classNameController;
  List<TextEditingController> studentFirstNameControllers = [];
  List<TextEditingController> studentLastNameControllers = [];
  String lastName = '';

  @override
  void initState() {
    super.initState();
    classNameController = TextEditingController(text: widget.studentGroup.name);
    lastName = widget.studentGroup.name;
    for (var student in widget.studentGroup.students) {
      studentFirstNameControllers
          .add(TextEditingController(text: student.firstName));
      studentLastNameControllers
          .add(TextEditingController(text: student.lastName));
    }
  }

  @override
  void dispose() {
    // nétoyer et libérer la mémoire
    classNameController.dispose();
    for (var controller in studentFirstNameControllers) {
      controller.dispose();
    }
    for (var controller in studentLastNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier une classe')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: classNameController,
              onChanged: (value) {
                widget.studentGroup.name = value;
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
                // Add a new student
                setState(() {
                  widget.studentGroup.students.add(
                      Student('', '', widget.studentGroup.students.length));
                  studentFirstNameControllers.add(TextEditingController());
                  studentLastNameControllers.add(TextEditingController());
                });
              },
              child: Text('Ajouter un élève'),
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
    for (int i = 0; i < studentFirstNameControllers.length; i++) {
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
                controller: studentFirstNameControllers[index],
                onChanged: (value) {
                  // Update the corresponding student's first name
                  widget.studentGroup.students[index].firstName = value;
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
                controller: studentLastNameControllers[index],
                onChanged: (value) {
                  // Update the corresponding student's last name
                  widget.studentGroup.students[index].lastName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.studentGroup.students
                      .removeAt(index); // Supprimez l'élève du groupe d'élèves
                  studentFirstNameControllers.removeAt(index);
                  studentLastNameControllers.removeAt(index);
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
    StudentDataManager.updateStudentGroupLocally(widget.studentGroup, lastName);
    Navigator.pop(context, widget.studentGroup);
  }
}
