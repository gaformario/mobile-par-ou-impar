import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _registerPlayer() async {
    final url = Uri.parse('https://par-impar.glitch.me/novo');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"username": _usernameController.text}),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BetScreen(
            currentPlayer: _usernameController.text,
            isFirstBet: true,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Jogador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nome do Jogador'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerPlayer,
              child: const Text('Cadastrar Jogador'),
            ),
          ],
        ),
      ),
    );
  }
}
