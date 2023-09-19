import 'package:app_teacher_tool_box/models/Activity.dart';

class ActivityGroup {
  final String name;
  final List<Activity> activities;

  ActivityGroup(this.name, this.activities);

  void logDetails() {
    print('Student Group Name: $name');
    print('Number of Students: ${activities.length}');

    for (var student in activities) {
      print('Student: ${student.name} ${student.isMandatory}');
    }
  }

  Activity getActivityById(int id) {
    return activities.firstWhere((activity) => activity.id == id);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }

  factory ActivityGroup.fromJson(Map<String, dynamic> json) {
    final activitiesList = (json['activities'] as List).map((activityJson) {
      return Activity.fromJson(activityJson);
    }).toList();

    return ActivityGroup(json['name'], activitiesList);
  }
}
