import 'package:flutter/material.dart';

class Integrante {
  const Integrante({required this.nome, required this.matricula});

  final String nome;
  final String matricula;
}

abstract final class Identidade {
  static const nomeDoApp = 'Minha Lista de Compras';
  static const descricao =
      'Lista de compras com armazenamento local em SQLite e envio posterior ao servidor.';
  static const turma = 'Desenvolvimento para Dispositivos Móveis — 2026';

  static const integrantes = [
    Integrante(nome: 'Lafaete Dias Alves', matricula: '000000000'),
  ];

  static const corSemente = Color(0xFF00796B);
  static const categorias = ['Hortifrúti', 'Mercearia', 'Limpeza', 'Higiene'];
}
