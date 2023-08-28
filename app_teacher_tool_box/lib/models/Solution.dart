import 'package:app_teacher_tool_box/models/Activity.dart';
import 'package:app_teacher_tool_box/models/Sudent.dart';

class Solution {
  final Map<Student, Map<Activity, bool>>
      studentActivityMap; // Map des activités pour chaque élève

  Solution(this.studentActivityMap);
}
