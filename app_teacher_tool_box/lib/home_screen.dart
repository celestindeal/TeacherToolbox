import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Workshop Planner!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/workshop');
              },
              child: Text('Go to Workshop'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              child: Text('Go to creation screen'),
            ),
          ],
        ),
      ),
    );
  }
}
