import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:flutter/material.dart';

class WorkshopScreen extends StatefulWidget {
  @override
  _WorkshopScreenState createState() => _WorkshopScreenState();
}

class _WorkshopScreenState extends State<WorkshopScreen> {
  List<ActivityGroup> activityGroups = []; // Liste des groupes d'activités

  final TextEditingController _groupNameController = TextEditingController();

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
              'Create Activity Group',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createActivityGroup();
              },
              child: Text('Create Group'),
            ),
            // Display existing activity groups
            if (activityGroups.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                'Existing Activity Groups:',
                style: TextStyle(fontSize: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: activityGroups.map((group) {
                  return Text(group.name);
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void createActivityGroup() {
    String groupName = _groupNameController.text;
    if (groupName.isNotEmpty) {
      ActivityGroup newGroup = ActivityGroup(groupName, []);
      setState(() {
        activityGroups.add(newGroup);
      });
      _groupNameController.clear();
    }
  }
}
