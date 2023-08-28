import 'package:app_teacher_tool_box/models/Sudent.dart';

class StudentGroup {
  final String name;
  final List<Student> students;

  StudentGroup(this.name, this.students);

  void logDetails() {
    print('Student Group Name: $name');
    print('Number of Students: ${students.length}');

    for (var student in students) {
      print('Student: ${student.firstName} ${student.lastName}');
    }
  }
}
