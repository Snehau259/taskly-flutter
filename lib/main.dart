import 'package:flutter/material.dart';
import './pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly App',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: Home()
    );
  }
}

