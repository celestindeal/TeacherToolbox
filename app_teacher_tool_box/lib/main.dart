import 'package:app_teacher_tool_box/home_screen.dart';
import 'package:app_teacher_tool_box/workshop_screen.dart';
import 'package:app_teacher_tool_box/creation_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workshop Planner',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF008080, // Code RVB du bleu canard
          <int, Color>{
            50: Color(0xFFE0F2F2),
            100: Color(0xFFB3E0E0),
            200: Color(0xFF80C7C7),
            300: Color(0xFF4DAAAA),
            400: Color(0xFF269090),
            500: Color(0xFF008080),
            600: Color(0xFF007373),
            700: Color(0xFF006666),
            800: Color(0xFF005757),
            900: Color(0xFF003C3C),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/workshop': (context) => WorkshopScreen(),
        '/create': (context) => ClassCreationScreen(),
      },
    );
  }
}
