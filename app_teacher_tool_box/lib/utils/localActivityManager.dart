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

  static Future<void> updateActivityGroupLocally(
      ActivityGroup updatedActivityGroup, String lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<ActivityGroup> existingActivityGroups =
        await getActivityGroupsLocally();

    // Recherchez l'index du groupe d'étudiants à mettre à jour
    int groupIndex =
        existingActivityGroups.indexWhere((group) => group.name == lastName);
    print(groupIndex);
    if (groupIndex != -1) {
      // Mettez à jour le groupe d'étudiants dans la liste
      existingActivityGroups[groupIndex] = updatedActivityGroup;

      // Enregistrez la liste mise à jour localement
      final activityGroupsJson =
          existingActivityGroups.map((group) => group.toJson()).toList();
      print(activityGroupsJson);
      await prefs.setString('activityGroups', jsonEncode(activityGroupsJson));
    }
  }

  static Future<List<String>> getAllActivityGroupNamesLocally() async {
    List<ActivityGroup> activityGroups =
        await ActivityDataManager.getActivityGroupsLocally();
    List<String> activityGroupNames =
        activityGroups.map((group) => group.name).toList();
    return activityGroupNames;
  }
}
