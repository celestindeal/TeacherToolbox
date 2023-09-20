import 'dart:io';

import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart'; // Pour Uint8List
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';

void generateExcel(List<List<List<int>>> planning, ActivityGroup activityGroup,
    StudentGroup studentGroups) async {
  var excel = Excel.createExcel();
  var sheet = excel['Planning'];

  // Ajouter les titres
  var rowIndex = 0;
  var titles = ['Activity'];
  for (int i = 0; i < planning[0].length; i++) {
    titles.add('State ${i + 1}');
  }

  sheet.appendRow(titles);

  // Ajouter les données
  for (var activity in planning) {
    rowIndex++;
    var row = ['Activity $rowIndex'];
    for (var state in activity) {
      List<String> stateString = [];
      for (int id in state) {
        stateString.add(
            "${studentGroups.getStudentById(id).lastName} ${studentGroups.getStudentById(id).firstName}");
      }
      row.add(stateString.join("\n"));
    }
    sheet.appendRow(row);
  }
  excel.delete('Sheet1');
  List<int>? data = excel.encode();
  if (data == null) throw Exception('Failed to generate Excel file');

  final directory = await getApplicationDocumentsDirectory();
  String path = directory.path;

  final file = File('$path/Planning.xlsx');
  file.writeAsBytes(data);
}
