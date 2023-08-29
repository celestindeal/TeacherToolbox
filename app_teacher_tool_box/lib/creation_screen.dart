import 'package:app_teacher_tool_box/models/Sudent.dart';
import 'package:app_teacher_tool_box/utils/localStudentsManager.dart';
import 'package:flutter/material.dart';

import 'package:app_teacher_tool_box/models/StudentGroup.dart';

class ClassCreationScreen extends StatefulWidget {
  @override
  _ClassCreationScreenState createState() => _ClassCreationScreenState();
}

class _ClassCreationScreenState extends State<ClassCreationScreen> {
  List<Student> students = [];
  List<Widget> studentFields = [];
  List<TextEditingController> studentFieldsControllers = [];
  String className = '';

  @override
  void initState() {
    super.initState();
    addStudentField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Class Creation')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Create a Class',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                className = value;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            Column(
              children: studentFields,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addStudentField();
                });
              },
              child: Text('Add Student'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createStudentGroup();
              },
              child: Text('Create Class'),
            ),
          ],
        ),
      ),
    );
  }

  void addStudentField() {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    studentFieldsControllers.add(firstNameController);
    studentFieldsControllers.add(lastNameController);

    studentFields.add(buildStudentField(
      studentFields.length,
      firstNameController,
      lastNameController,
    ));
  }

  Widget buildStudentField(
      int studentIndex,
      TextEditingController firstNameController,
      TextEditingController lastNameController) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text('${studentIndex + 1} '),
            Expanded(
              child: TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void createStudentGroup() async {
    students.clear();

    for (var i = 0; i < studentFieldsControllers.length; i += 2) {
      String firstName = studentFieldsControllers[i].text;
      String lastName = studentFieldsControllers[i + 1].text;

      if (firstName.isNotEmpty && lastName.isNotEmpty) {
        students.add(Student(firstName, lastName));
      }
    }

    if (students.isNotEmpty) {
      StudentGroup newStudentGroup = StudentGroup(className, students);
      newStudentGroup.logDetails();
      await LocalDataManager.saveStudentGroupLocally(newStudentGroup);
      Navigator.pop(context);
    }
  }
}
