import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalDataManager {
  static Future<void> saveStudentGroupsLocally(
      List<StudentGroup> studentGroups) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentGroupsJson =
        studentGroups.map((group) => group.toJson()).toList();
    await prefs.setString('studentGroups', jsonEncode(studentGroupsJson));
  }

  static Future<void> saveStudentGroupLocally(
      StudentGroup newStudentGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<StudentGroup> existingStudentGroups = await getStudentGroupsLocally();
    existingStudentGroups.add(newStudentGroup);

    final studentGroupsJson =
        existingStudentGroups.map((group) => group.toJson()).toList();
    await prefs.setString('studentGroups', jsonEncode(studentGroupsJson));
  }

  static Future<List<StudentGroup>> getStudentGroupsLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentGroupsJson = prefs.getString('studentGroups');
    if (studentGroupsJson != null) {
      final List<dynamic> studentGroupsList = jsonDecode(studentGroupsJson);
      return studentGroupsList
          .map((groupJson) => StudentGroup.fromJson(groupJson))
          .toList();
    }
    return [];
  }

  static Future<void> removeStudentGroupLocally(
      StudentGroup studentGroup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<StudentGroup> existingStudentGroups = await getStudentGroupsLocally();

    existingStudentGroups
        .removeWhere((group) => group.name == studentGroup.name);

    final studentGroupsJson =
        existingStudentGroups.map((group) => group.toJson()).toList();
    await prefs.setString('studentGroups', jsonEncode(studentGroupsJson));
  }
}
