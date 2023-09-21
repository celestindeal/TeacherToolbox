import 'dart:io';
import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/ActivityGroup.dart';
import 'package:app_teacher_tool_box/models/StudentGroup.dart';
import 'package:file_picker/file_picker.dart';
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
