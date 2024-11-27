import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cadastro_page.dart';

class JogoPage extends StatefulWidget {
  final String jogadorAtual;
  final String oponente;

  JogoPage({required this.jogadorAtual, required this.oponente});

  @override
  _JogoPageState createState() => _JogoPageState();
}

class _JogoPageState extends State<JogoPage> {
  final TextEditingController _apostaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  String _escolhaParImpar = 'Par';
  final String _baseUrl = 'https://par-impar.glitch.me';

  Future<void> _efetuarAposta() async {
    final parimpar = _escolhaParImpar == 'Par' ? 2 : 1;

    await http.post(
      Uri.parse('$_baseUrl/aposta'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': widget.jogadorAtual,
        'valor': int.parse(_apostaController.text),
        'parimpar': parimpar,
        'numero': int.parse(_numeroController.text),
      }),
    );

    final response = await http.get(
      Uri.parse('$_baseUrl/jogar/${widget.jogadorAtual}/${widget.oponente}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final vencedor = data['vencedor'];
      final perdedor = data['perdedor'];

      String resultado = 'Vencedor: ${vencedor['username']} com ${vencedor['valor']} pontos.\n'
          'Perdedor: ${perdedor['username']} com ${perdedor['valor']} pontos.';

      // Exibe o resultado e redireciona para a tela inicial
      _mostrarResultado(resultado);
    }
  }

  // Função para exibir o resultado e retornar para a tela inicial
  void _mostrarResultado(String resultado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado do Jogo'),
          content: Text(resultado),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => CadastroPage()),
                      (Route<dynamic> route) => false,
                ); // Volta para a tela inicial
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo de Par ou Ímpar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _apostaController,
              decoration: InputDecoration(labelText: 'Valor da Aposta'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _numeroController,
              decoration: InputDecoration(labelText: 'Número (1-5)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _escolhaParImpar,
              onChanged: (value) {
                setState(() {
                  _escolhaParImpar = value!;
                });
              },
              items: <String>['Par', 'Ímpar'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _efetuarAposta,
              child: Text('Jogar!'),
            ),
          ],
        ),
      ),
    );
  }
}
