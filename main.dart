import 'package:flutter/material.dart';
import 'cadastro_page.dart';

void main() {
  runApp(ParOuImparApp());
}

class ParOuImparApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Par ou Ímpar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CadastroPage(),
    );
  }
}
