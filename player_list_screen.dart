import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';
import 'game_result_screen.dart';

class PlayerListScreen extends StatefulWidget {
  final String currentPlayer;

  const PlayerListScreen({required this.currentPlayer, super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  List<dynamic> bettingPlayers = [];

  Future<void> _fetchPlayers() async {
    final url = Uri.parse('https://par-impar.glitch.me/todos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        bettingPlayers = json.decode(response.body)['jogadores'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    // Filtra para remover o jogador atual da lista de oponentes
    List<dynamic> availableOpponents = bettingPlayers
        .where((player) => player['username'] != widget.currentPlayer)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Escolha um Oponente')),
      body: availableOpponents.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nenhum oponente disponível.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                );
              },
              child: const Text('Voltar ao Início e Cadastrar Mais Jogadores'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: availableOpponents.length,
        itemBuilder: (context, index) {
          final player = availableOpponents[index];
          return ListTile(
            title: Text(player['username']),
            subtitle: Text('Pontos: ${player['pontos']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameResultScreen(
                    currentPlayer: widget.currentPlayer,
                    opponent: player['username'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
