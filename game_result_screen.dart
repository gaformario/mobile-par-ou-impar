import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class GameResultScreen extends StatefulWidget {
  final String currentPlayer;
  final String opponent;

  const GameResultScreen({required this.currentPlayer, required this.opponent, super.key});

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  Map<String, dynamic>? gameResult;

  Future<void> _playGame() async {
    final url = Uri.parse('https://par-impar.glitch.me/jogar/${widget.currentPlayer}/${widget.opponent}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        gameResult = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _playGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado do Jogo')),
      body: gameResult == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (gameResult!['msg'] == 'Ninguem ganhou!') ...[
                const Text(
                  'Ninguém ganhou!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )
              ] else ...[
                Text(
                  'Vencedor: ${gameResult!['vencedor']['username']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Pontos ganhos: ${gameResult!['vencedor']['valor']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  'Perdedor: ${gameResult!['perdedor']['username']}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
              ],
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                  );
                },
                child: const Text('Voltar ao Início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
