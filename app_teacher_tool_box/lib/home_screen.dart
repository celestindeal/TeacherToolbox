import 'package:flutter/material.dart';
import 'package:app_teacher_tool_box/editActivityScreen.dart';
import 'package:app_teacher_tool_box/editClassScreen.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/utils/localActivityManager.dart';
import 'package:app_teacher_tool_box/utils/localStudentsManager.dart';
import 'package:app_teacher_tool_box/workshop_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<StudentGroup> studentGroups = [];
  List<ActivityGroup> activityGroups = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<StudentGroup> loadedStudentGroups =
        await StudentDataManager.getStudentGroupsLocally();
    List<ActivityGroup> loadedActivityGroups =
        await ActivityDataManager.getActivityGroupsLocally();

    setState(() {
      studentGroups = loadedStudentGroups;
      activityGroups = loadedActivityGroups;
    });
  }

  Widget _buildStudentGroupList() {
    return Expanded(
      child: ListView.builder(
        itemCount: studentGroups.length,
        itemBuilder: (context, index) {
          StudentGroup group = studentGroups[index];
          return _buildGroupCard(
            group.name,
            "Élèves",
            group.students
                .map((student) => '${student.firstName} ${student.lastName}')
                .toList(),
            () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditClassScreen(studentGroup: group),
                ),
              );
              _loadData();
            },
            () async {
              await StudentDataManager.removeStudentGroupLocally(group);
              _loadData();
            },
          );
        },
      ),
    );
  }

  Widget _buildActivityGroupList() {
    return Expanded(
      child: ListView.builder(
        itemCount: activityGroups.length,
        itemBuilder: (context, index) {
          ActivityGroup group = activityGroups[index];
          return _buildGroupCard(
            group.name,
            "Activités",
            group.activities.map((activity) => activity.name).toList(),
            () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditActivityScreen(activityGroup: group),
                ),
              );
              _loadData();
            },
            () {
              ActivityDataManager.removeActivityGroupLocally(group);
              _loadData();
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupCard(
    String title,
    String text,
    List<String> itemNames,
    VoidCallback editCallback,
    VoidCallback deleteCallback,
  ) {
    String displayNames = itemNames.length <= 3
        ? itemNames.join(', ')
        : itemNames.sublist(0, 3).join(', ') + '...';

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Nombre : ${itemNames.length}'),
                  SizedBox(height: 5),
                  Text(text + ' :'),
                  for (String itemName in itemNames) Text('- $itemName'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        elevation: 5.0,
        child: ListTile(
          contentPadding: EdgeInsets.all(15.0),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre : ${itemNames.length}'),
              SizedBox(height: 5),
              Text(text + ' : $displayNames'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: editCallback,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('Modifier', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: deleteCallback,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: Text('Supprimer', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
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
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/create');
                    _loadData();
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
                  child: Text(
                    'Générer un emploi du temps',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.pushNamed(context, '/create_Activity');
                    _loadData();
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
            _buildStudentGroupList(),
            SizedBox(height: 20),
            Text(
              'Liste d\'activités :',
              style: TextStyle(fontSize: 20),
            ),
            _buildActivityGroupList(),
          ],
        ),
      ),
    );
  }
}
