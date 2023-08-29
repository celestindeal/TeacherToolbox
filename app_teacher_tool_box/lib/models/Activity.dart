class Activity {
  final String name;
  final bool isMandatory;

  Activity(this.name, this.isMandatory);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isMandatory': isMandatory,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(json['name'], json['isMandatory']);
  }
}
