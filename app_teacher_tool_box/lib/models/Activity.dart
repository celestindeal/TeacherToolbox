class Activity {
  final String name;
  final int number_students;
  final bool isMandatory;

  Activity(this.name, this.number_students, this.isMandatory);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number_students': number_students,
      'isMandatory': isMandatory,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    String name = json['name'] ?? '';
    int numberStudents =
        json.containsKey('number_students') ? json['number_students'] : 0;
    bool isMandatory =
        json.containsKey('isMandatory') ? json['isMandatory'] : false;

    return Activity(name, numberStudents, isMandatory);
  }
}
