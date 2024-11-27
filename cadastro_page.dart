import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'escolha_oponente_page.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final String _baseUrl = 'https://par-impar.glitch.me';
  List<Map<String, dynamic>> _jogadoresComPontos = [];

  @override
  void initState() {
    super.initState();
    _listarJogadoresComPontos();
  }

  // Função para cadastrar novo jogador e redirecionar para escolha de oponente
  Future<void> _cadastrarJogador(String nome) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/novo'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': nome}),
    );

    if (response.statusCode == 200) {
      // Atualizar a lista com o novo jogador
      _listarJogadoresComPontos();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EscolhaOponentePage(jogadorAtual: nome)),
      );
    }
  }

  // Função para buscar todos os jogadores e suas pontuações
  Future<void> _listarJogadoresComPontos() async {
    final response = await http.get(Uri.parse('$_baseUrl/jogadores'));

    if (response.statusCode == 200) {
      final jogadores = json.decode(response.body)['jogadores'];
      List<Map<String, dynamic>> jogadoresComPontos = [];

      for (var jogador in jogadores) {
        final pontosResponse = await http.get(Uri.parse('$_baseUrl/pontos/${jogador['username']}'));
        if (pontosResponse.statusCode == 200) {
          final pontosData = json.decode(pontosResponse.body);
          jogadoresComPontos.add({
            'username': pontosData['username'],
            'pontos': pontosData['pontos'],
          });
        }
      }

      setState(() {
        _jogadoresComPontos = jogadoresComPontos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Jogador'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Jogador'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _cadastrarJogador(_nomeController.text);
              },
              child: Text('Cadastrar e Escolher Oponente'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _jogadoresComPontos.length,
                itemBuilder: (context, index) {
                  final jogador = _jogadoresComPontos[index];
                  return ListTile(
                    title: Text(jogador['username']),
                    subtitle: Text('Pontos: ${jogador['pontos']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
