import 'package:flutter/material.dart';
import '../views/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile RF Drive Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Dashboard(), // Dashboard as the main screen
    );
  }
}
