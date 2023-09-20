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
      appBar: AppBar(title: Text('Boite à outils de l\'enseignant')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create');
                  },
                  child: Text('Créer un groupe d\'étudiants'),
                ),
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
                  child: Text('Générer un emploi du temps',
                      style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create_Activity');
                  },
                  child: Text('Créer un groupe d\'activités'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Liste des groupes d\'étudiants :',
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: studentGroups.length,
                itemBuilder: (context, index) {
                  StudentGroup group = studentGroups[index];

                  // Génère une liste de noms et prénoms des étudiants
                  List<String> studentNamesList = group.students
                      .map((student) =>
                          '${student.firstName} ${student.lastName}')
                      .toList();

                  String displayNames;
                  if (studentNamesList.length <= 3) {
                    displayNames = studentNamesList.join(', ');
                  } else {
                    displayNames =
                        studentNamesList.sublist(0, 3).join(', ') + '...';
                  }

                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    elevation: 5.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15.0),
                      title: Text(group.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Nombre d\'étudiant(s): ${group.students.length}'),
                          SizedBox(height: 5),
                          Text('Etudiant : $displayNames'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            LocalDataManager.removeStudentGroupLocally(group);
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: Text('Supprimer',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Liste d\'activitées :', // Titre pour les groupes d'activités
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: activityGroups.length,
                itemBuilder: (context, index) {
                  ActivityGroup group = activityGroups[index];

                  // Générer une liste de noms d'activités
                  List<String> activityNamesList = group.activities
                      .map((activity) => activity.name)
                      .toList();

                  String displayNames;
                  if (activityNamesList.length <= 3) {
                    displayNames = activityNamesList.join(', ');
                  } else {
                    displayNames =
                        activityNamesList.sublist(0, 3).join(', ') + '...';
                  }

                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    elevation: 5.0,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15.0),
                      title: Text(group.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Nombre d\'activitée (s) : ${group.activities.length}'),
                          SizedBox(height: 5),
                          Text('Activitée (s) : $displayNames'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            ActivityDataManager.removeActivityGroupLocally(
                                group);
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        child: Text('Supprimer',
                            style: TextStyle(color: Colors.white)),
                      ),
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
