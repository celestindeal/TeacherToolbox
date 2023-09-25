import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:app_teacher_tool_box/utils/localActivityManager.dart';
import 'package:app_teacher_tool_box/utils/localStudentsManager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

Future<void> generateExcel(List<List<List<int>>> planning,
    ActivityGroup activityGroup, StudentGroup studentGroups) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  // Add titles
  var rowIndex = 1;
  var titles = ['Activity'];
  for (int i = 0; i < planning[0].length; i++) {
    titles.add('State ${i + 1}');
  }

  for (int i = 0; i < titles.length; i++) {
    sheet.getRangeByIndex(rowIndex, i + 1).setText(titles[i]);
  }

  // Add data
  for (var activity in planning) {
    rowIndex++;
    sheet
        .getRangeByIndex(rowIndex, 1)
        .setText(activityGroup.getActivityById(rowIndex - 2).name);
    int colIndex = 2;

    for (var state in activity) {
      List<String> stateString = [];
      for (int id in state) {
        stateString.add(
            "${studentGroups.getStudentById(id).lastName} ${studentGroups.getStudentById(id).firstName}");
      }

      // Fetch the length of the longest string in stateString
      int maxSizeCol = stateString
          .map((s) => s.length)
          .fold(0, (prev, element) => element > prev ? element : prev);

      sheet.getRangeByIndex(rowIndex, colIndex).setText(stateString.join("\n"));
      if (sheet.getColumnWidth(colIndex) < maxSizeCol) {
        // Adjust the column width based on the length of the longest string.
        // Assuming average character width to be roughly 8 pixels, so multiplying by 8
        sheet.setColumnWidthInPixels(colIndex, maxSizeCol * 8);
      }
      colIndex++;
    }
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  String? outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Please select an output file:',
    allowedExtensions: ['xlsx'],
    fileName: 'Planning.xlsx',
  );

  if (outputFile != null) {
    File file = File(outputFile);
    await file.writeAsBytes(bytes);
  }
}

const _allowedExtensions = ['json'];
const _defaultFileName = 'dataBase.json';

Future<void> export_database() async {
  try {
    // Récupérer les données
    List<ActivityGroup> activityGroups =
        await ActivityDataManager.getActivityGroupsLocally();
    List<StudentGroup> studentGroups =
        await StudentDataManager.getStudentGroupsLocally();

    // Convertir en JSON
    Map<String, dynamic> dataToExport = {
      "activityGroups": activityGroups.map((e) => e.toJson()).toList(),
      "studentGroups": studentGroups.map((e) => e.toJson()).toList(),
    };
    String jsonString = jsonEncode(dataToExport);

    // Sauvegarder le fichier
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      allowedExtensions: _allowedExtensions,
      fileName: _defaultFileName,
    );

    if (outputFile != null) {
      File file = File(outputFile);
      await file.writeAsString(jsonString, encoding: utf8);
    }
  } catch (e) {
    print("An error occurred during export: $e");
  }
}

Future<void> import_database() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );

    if (result == null)
      return; // Early exit if the user canceled file selection.

    File file = File(result.files.first.path!);
    Uint8List fileBytes = await file.readAsBytes();
    String jsonString = utf8.decode(fileBytes);
    Map<String, dynamic> importedData = jsonDecode(jsonString);

    // Convertir et sauvegarder les données importées localement
    List<ActivityGroup> activityGroups =
        (importedData["activityGroups"] as List)
            .map((e) => ActivityGroup.fromJson(e))
            .toList();
    await ActivityDataManager.saveActivityGroupsLocally(activityGroups);

    List<StudentGroup> studentGroups = (importedData["studentGroups"] as List)
        .map((e) => StudentGroup.fromJson(e))
        .toList();
    await StudentDataManager.saveStudentGroupsLocally(studentGroups);
  } catch (e) {
    print("An error occurred during import: $e");
  }
}
