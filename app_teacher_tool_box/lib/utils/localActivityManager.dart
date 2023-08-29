import 'dart:convert';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityDataManager {
  static Future<void> saveActivityGroupsLocally(
      List<ActivityGroup> activityGroups) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final activityGroupsJson =
        activityGroups.map((group) => group.toJson()).toList();
    await prefs.setString('activityGroups', jsonEncode(activityGroupsJson));
  }

  static Future<List<ActivityGroup>> getActivityGroupsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final activityGroupsJson = prefs.getString('activityGroups');
    if (activityGroupsJson != null) {
      final List<dynamic> activityGroupsList = jsonDecode(activityGroupsJson);
      return activityGroupsList
          .map((groupJson) => ActivityGroup.fromJson(groupJson))
          .toList();
    }
    return [];
  }

  static Future<void> saveActivityLocally(Activity activity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Activity> existingActivities = await getActivitiesLocally();
    existingActivities.add(activity);

    final activitiesJson =
        existingActivities.map((activity) => activity.toJson()).toList();
    await prefs.setString('activities', jsonEncode(activitiesJson));
  }

  static Future<void> saveActivityGroupLocally(
      ActivityGroup newActivityGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ActivityGroup> existingActivityGroups =
        await getActivityGroupsLocally();
    existingActivityGroups.add(newActivityGroup);

    final activityGroupsJson =
        existingActivityGroups.map((group) => group.toJson()).toList();
    await prefs.setString('activityGroups', jsonEncode(activityGroupsJson));
  }

  static Future<List<Activity>> getActivitiesLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final activitiesJson = prefs.getString('activities');
    if (activitiesJson != null) {
      final List<dynamic> activitiesList = jsonDecode(activitiesJson);
      return activitiesList
          .map((activityJson) => Activity.fromJson(activityJson))
          .toList();
    }
    return [];
  }

  static Future<void> removeActivityGroupLocally(
      ActivityGroup activityGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ActivityGroup> existingActivityGroups =
        await getActivityGroupsLocally();

    existingActivityGroups
        .removeWhere((group) => group.name == activityGroup.name);

    final activityGroupsJson =
        existingActivityGroups.map((group) => group.toJson()).toList();
    await prefs.setString('activityGroups', jsonEncode(activityGroupsJson));
  }
}
