import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'player_list_screen.dart';

class BetScreen extends StatefulWidget {
  final String currentPlayer;
  final bool isFirstBet;

  const BetScreen({required this.currentPlayer, this.isFirstBet = false, super.key});

  @override
  State<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  final TextEditingController _betController = TextEditingController();
  int selectedNumber = 1;
  String selectedOption = "Ímpar";

  Future<void> _makeBet() async {
    final url = Uri.parse('https://par-impar.glitch.me/aposta');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "username": widget.currentPlayer,
        "valor": int.parse(_betController.text),
        "parimpar": selectedOption == "Par" ? 2 : 1,
        "numero": selectedNumber,
      }),
    );

    if (response.statusCode == 200) {
      if (widget.isFirstBet) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlayerListScreen(currentPlayer: widget.currentPlayer)),
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fazer Aposta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _betController,
              decoration: const InputDecoration(labelText: 'Valor da Aposta'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            DropdownButton<int>(
              value: selectedNumber,
              items: [1, 2, 3, 4, 5]
                  .map((number) => DropdownMenuItem(value: number, child: Text('Número: $number')))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedNumber = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedOption,
              items: ["Ímpar", "Par"]
                  .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _makeBet,
              child: const Text('Realizar Aposta'),
            ),
          ],
        ),
      ),
    );
  }
}
