import 'dart:io';
import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';

Future<void> generateExcel(List<List<List<int>>> planning,
    ActivityGroup activityGroup, StudentGroup studentGroups) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  // Ajouter les titres
  var rowIndex = 1; // Dans xlsio, l'indexation commence à 1
  var titles = ['Activity'];
  for (int i = 0; i < planning[0].length; i++) {
    titles.add('State ${i + 1}');
  }

  for (int i = 0; i < titles.length; i++) {
    sheet.getRangeByIndex(rowIndex, i + 1).setText(titles[i]);
  }

  // Ajouter les données
  for (var activity in planning) {
    rowIndex++;
    sheet.getRangeByIndex(rowIndex, 1).setText('Activity ${rowIndex - 1}');
    int colIndex = 2; // Car la première colonne est pour 'Activity'

    for (var state in activity) {
      int maxSizeCol = 0; // Pour ajuster la largeur de la colonne
      List<String> stateString = [];
      for (int id in state) {
        stateString.add(
            "${studentGroups.getStudentById(id).lastName} ${studentGroups.getStudentById(id).firstName}");
        if (stateString.last.length > maxSizeCol) {
          // Pour ajuster la largeur de la colonne
          maxSizeCol = stateString.last.length;
        }
      }
      sheet.getRangeByIndex(rowIndex, colIndex).setText(stateString.join("\n"));
      if (sheet.getColumnWidth(colIndex) < 10 * maxSizeCol) {
        // Pour ajuster la largeur de la colonne
        sheet.setColumnWidthInPixels(colIndex, 10 * maxSizeCol);
      }
      colIndex++;
    }
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final file = File('$path/Planning.xlsx');
  await file.writeAsBytes(bytes);
}
