// ignore_for_file: file_names

import 'package:app_teacher_tool_box/models/Sudent.dart';

class StudentGroup {
  String name;
  List<Student> students;

  //constructeur
  StudentGroup(this.name, this.students);

  Student getStudentById(int id) {
    return students.firstWhere((student) => student.id == id);
  }

  void logDetails() {
    print('Student Group Name: $name');
    print('Number of Students: ${students.length}');

    for (var student in students) {
      print('Student: ${student.firstName} ${student.lastName}');
    }
  }

  // Méthode de sérialisation
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'students': students.map((student) => student.toJson()).toList(),
    };
  }

  // Méthode de désérialisation
  static StudentGroup fromJson(Map<String, dynamic> json) {
    final List<Student> studentsList =
        (json['students'] as List?)?.map((studentJson) {
              return Student.fromJson(studentJson);
            }).toList() ??
            []; // Utiliser une liste vide par défaut si 'students' est nul.

    return StudentGroup(json['name'], studentsList);
  }
}
