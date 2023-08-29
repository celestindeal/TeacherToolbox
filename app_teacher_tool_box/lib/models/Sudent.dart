class Student {
  final String firstName;
  final String lastName;

  Student(this.firstName, this.lastName);

  // Méthode de sérialisation
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  // Méthode de désérialisation
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(json['firstName'], json['lastName']);
  }
}
