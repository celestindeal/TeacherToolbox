import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/utils/localActivityManager.dart';
import 'package:app_teacher_tool_box/workshop_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/utils/localStudentsManager.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StudentGroup> studentGroups = [];
  List<ActivityGroup> activityGroups = []; // Liste des groupes d'activités

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<StudentGroup> loadedStudentGroups =
        await LocalDataManager.getStudentGroupsLocally();
    List<ActivityGroup> loadedActivityGroups =
        await ActivityDataManager.getActivityGroupsLocally();

    setState(() {
      studentGroups = loadedStudentGroups;
      activityGroups = loadedActivityGroups;
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkshopScreen(
                      studentGroups: studentGroups,
                      activityGroups: activityGroups,
                    ),
                  ),
                );
              },
              child: Text('Go to Workshop'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              child: Text('Go to creation screen'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_Activity');
              },
              child: Text('Go to creation Activity screen'),
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
                    subtitle: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                LocalDataManager.removeStudentGroupLocally(
                                    group);
                              });
                            },
                            child: Text('Delete')),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Number of Students: ${group.students.length}'),
                            Text('Students: $studentNames'),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Activity Groups:', // Titre pour les groupes d'activités
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: activityGroups.length,
                itemBuilder: (context, index) {
                  ActivityGroup group = activityGroups[index];

                  // Générer une liste de noms d'activités
                  String activityNames = group.activities
                      .map((activity) => activity.name)
                      .join(', ');

                  return ListTile(
                    title: Text(group.name),
                    subtitle: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                ActivityDataManager.removeActivityGroupLocally(
                                    group);
                              });
                            },
                            child: Text('Delete')),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Number of Activities: ${group.activities.length}'),
                            Text('Activities: $activityNames'),
                          ],
                        ),
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
