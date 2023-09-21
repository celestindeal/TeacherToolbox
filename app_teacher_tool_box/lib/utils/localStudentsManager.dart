import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StudentDataManager {
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

  static Future<void> updateStudentGroupLocally(
      StudentGroup updatedStudentGroup, String lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<StudentGroup> existingStudentGroups = await getStudentGroupsLocally();

    // Recherchez l'index du groupe d'étudiants à mettre à jour
    int groupIndex =
        existingStudentGroups.indexWhere((group) => group.name == lastName);
    print(groupIndex);
    if (groupIndex != -1) {
      // Mettez à jour le groupe d'étudiants dans la liste
      existingStudentGroups[groupIndex] = updatedStudentGroup;

      // Enregistrez la liste mise à jour localement
      final studentGroupsJson =
          existingStudentGroups.map((group) => group.toJson()).toList();
      print(studentGroupsJson);
      await prefs.setString('studentGroups', jsonEncode(studentGroupsJson));
    }
  }
}
