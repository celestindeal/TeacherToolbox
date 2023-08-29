import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/utils/localDataManager.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StudentGroup> studentGroups = [];

  @override
  void initState() {
    super.initState();
    _loadStudentGroups();
  }

  Future<void> _loadStudentGroups() async {
    List<StudentGroup> loadedGroups =
        await LocalDataManager.getStudentGroupsLocally();
    setState(() {
      studentGroups = loadedGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Workshop Planner!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/workshop');
              },
              child: Text('Go to Workshop'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              child: Text('Go to creation screen'),
            ),
            SizedBox(height: 20),
            Text(
              'Student Groups:',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: studentGroups.length,
                itemBuilder: (context, index) {
                  StudentGroup group = studentGroups[index];

                  // Génère une liste de noms et prénoms des étudiants
                  String studentNames = group.students
                      .map((student) =>
                          '${student.firstName} ${student.lastName}')
                      .join(', ');

                  return ListTile(
                    title: Text(group.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Number of Students: ${group.students.length}'),
                        Text('Students: $studentNames'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
