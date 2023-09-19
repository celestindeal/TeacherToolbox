import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/utils/localActivityManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    TextEditingController studentCountController = TextEditingController();
    TextEditingController isMandatoryController = TextEditingController();

    activityFieldsControllers.add(activityNameController);
    activityFieldsControllers.add(studentCountController);
    activityFieldsControllers.add(isMandatoryController);

    activityFields.add(buildActivityField(
      activityFields.length,
      activityNameController,
      studentCountController,
      isMandatoryController,
    ));
  }

  Widget buildActivityField(
    int activityIndex,
    TextEditingController nameController,
    TextEditingController studentCountController,
    TextEditingController isMandatoryController,
  ) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text('${activityIndex + 1} '),
            Expanded(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Activity Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Text('Student Count: '),
            Expanded(
              child: TextField(
                controller: studentCountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ], // Permet uniquement les chiffres
                decoration: InputDecoration(
                  labelText: 'Number of Students',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void createActivityGroup() async {
    activities.clear();
    int index = 0;
    for (int i = 0; i < activityFieldsControllers.length; i += 3) {
      String activityName = activityFieldsControllers[i].text;
      String studentCountText = activityFieldsControllers[i + 1].text;

      int studentCount = int.tryParse(studentCountText) ?? 0;

      if (activityName.isNotEmpty && studentCount > 0) {
        activities.add(Activity(activityName, studentCount, true, index));
        index++;
      }
    }

    if (activities.isNotEmpty) {
      ActivityGroup newActivityGroup = ActivityGroup(groupName, activities);
      await ActivityDataManager.saveActivityGroupLocally(newActivityGroup);
      Navigator.pop(context);
    }
  }
}
