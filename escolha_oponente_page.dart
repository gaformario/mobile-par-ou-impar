import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'jogo_page.dart';

class EscolhaOponentePage extends StatefulWidget {
  final String jogadorAtual;
  EscolhaOponentePage({required this.jogadorAtual});

  @override
  _EscolhaOponentePageState createState() => _EscolhaOponentePageState();
}

class _EscolhaOponentePageState extends State<EscolhaOponentePage> {
  final String _baseUrl = 'https://par-impar.glitch.me';
  List<dynamic> _jogadores = [];

  @override
  void initState() {
    super.initState();
    _listarJogadores();
  }

  Future<void> _listarJogadores() async {
    final response = await http.get(Uri.parse('$_baseUrl/jogadores'));

    if (response.statusCode == 200) {
      setState(() {
        _jogadores = json.decode(response.body)['jogadores'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escolher Oponente'),
      ),
      body: ListView.builder(
        itemCount: _jogadores.length,
        itemBuilder: (context, index) {
          final jogador = _jogadores[index];
          if (jogador['username'] == widget.jogadorAtual) return SizedBox.shrink();
          return ListTile(
            title: Text(jogador['username']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JogoPage(
                    jogadorAtual: widget.jogadorAtual,
                    oponente: jogador['username'],
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
