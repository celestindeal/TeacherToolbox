import 'package:excel/excel.dart';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart'; // Pour Uint8List

void generateExcel(List<List<List<int>>> planning) async {
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
      row.add(state.join(", "));
    }
    sheet.appendRow(row);
  }

  var data = excel.encode();
  if (data == null) throw Exception('Failed to generate Excel file');
  await FileSaver.instance.saveFile(
    bytes: Uint8List.fromList(data),
    name: 'planning',
  );
}
