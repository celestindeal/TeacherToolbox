import 'package:app_teacher_tool_box/models/Sudent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentGroup {
  final String name;
  final List<Student> students;

  //constructeur
  StudentGroup(this.name, this.students);

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
  factory StudentGroup.fromJson(Map<String, dynamic> json) {
    final studentsList = (json['students'] as List).map((studentJson) {
      return Student.fromJson(studentJson);
    }).toList();

    return StudentGroup(json['name'], studentsList);
  }

}
