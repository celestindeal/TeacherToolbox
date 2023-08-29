import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/utils/localActivityManager.dart';
import 'package:flutter/material.dart';

class ActivityCreationScreen extends StatefulWidget {
  @override
  _ActivityCreationScreenState createState() => _ActivityCreationScreenState();
}

class _ActivityCreationScreenState extends State<ActivityCreationScreen> {
  List<Activity> activities = [];
  List<Widget> activityFields = [];
  List<TextEditingController> activityFieldsControllers = [];
  String groupName = '';

  @override
  void initState() {
    super.initState();
    addActivityField();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity Creation')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Create an Activity Group',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                groupName = value;
              },
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            Column(
              children: activityFields,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  addActivityField();
                });
              },
              child: Text('Add Activity'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createActivityGroup();
              },
              child: Text('Create Activity Group'),
            ),
          ],
        ),
      ),
    );
  }

  void addActivityField() {
    TextEditingController activityNameController = TextEditingController();
    activityFieldsControllers.add(activityNameController);
    activityFields
        .add(buildActivityField(activityFields.length, activityNameController));
  }

  Widget buildActivityField(
      int activityIndex, TextEditingController controller) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text('${activityIndex + 1} '),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Activity Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Add more fields for activity details if needed
          ],
        ),
      ],
    );
  }

  void createActivityGroup() async {
    activities.clear();

    for (var i = 0; i < activityFieldsControllers.length; i++) {
      String activityName = activityFieldsControllers[i].text;

      if (activityName.isNotEmpty) {
        activities.add(Activity(
            activityName, true)); // You can adjust the parameters as needed
      }
    }

    if (activities.isNotEmpty) {
      ActivityGroup newActivityGroup = ActivityGroup(groupName, activities);
      // Save the new activity group using your data manager utility
      await ActivityDataManager.saveActivityGroupLocally(newActivityGroup);
      Navigator.pop(context);
    }
  }
}
