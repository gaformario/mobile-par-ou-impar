import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const ParOuImparApp());
}

class ParOuImparApp extends StatelessWidget {
  const ParOuImparApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo de Par ou Ímpar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}