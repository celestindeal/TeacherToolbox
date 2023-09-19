import 'package:app_teacher_tool_box/models/Activity.dart';

class Student {
  final int id;
  final String firstName;
  final String lastName;
  List<Activity> activities = [];

  Student(this.firstName, this.lastName, this.id);

  // Méthode de sérialisation
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'id': id,
    };
  }

  // Méthode de désérialisationx
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(json['firstName'], json['lastName'], json['id']);
  }
}
