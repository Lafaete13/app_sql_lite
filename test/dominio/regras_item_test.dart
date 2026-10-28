import 'package:app_sql_lite/dominio/item.dart';
import 'package:app_sql_lite/dominio/regras_item.dart';
import 'package:flutter_test/flutter_test.dart';

Item _item(
  String nome,
  String categoria, {
  bool comprado = false,
  bool sincronizado = true,
}) {
  final data = DateTime(2026);
  return Item(
    nome: nome,
    categoria: categoria,
    comprado: comprado,
    sincronizado: sincronizado,
    criadoEm: data,
    atualizadoEm: data,
  );
}

void main() {
  group('validarNome', () {
    test('recusa nome vazio ou só com espaços', () {
      expect(validarNome('   '), isNotNull);
    });

    test('recusa nome curto demais', () {
      expect(validarNome('a'), isNotNull);
    });

    test('recusa nome longo demais', () {
      expect(validarNome('x' * (tamanhoMaximoNome + 1)), isNotNull);
    });

    test('aceita nome válido, ignorando espaços nas pontas', () {
      expect(validarNome('  Café  '), isNull);
    });
  });

  group('ajustarQuantidade', () {
    test('soma e subtrai dentro dos limites', () {
      expect(ajustarQuantidade(3, 1), 4);
      expect(ajustarQuantidade(3, -1), 2);
    });

    test('não ultrapassa os limites', () {
      expect(ajustarQuantidade(quantidadeMinima, -1), quantidadeMinima);
      expect(ajustarQuantidade(quantidadeMaxima, 1), quantidadeMaxima);
    });
  });

  test('ordena itens a comprar primeiro, depois por categoria e nome', () {
    final ordenados = ordenarParaExibicao([
      _item('Sabão', 'Limpeza', comprado: true),
      _item('Feijão', 'Mercearia'),
      _item('Alface', 'Hortifrúti'),
      _item('Arroz', 'Mercearia'),
    ]);
    expect(ordenados.map((item) => item.nome).toList(), [
      'Alface',
      'Arroz',
      'Feijão',
      'Sabão',
    ]);
  });

  test('resumo conta comprados e alterações aguardando envio', () {
    final resumo = resumir([
      _item('A', 'X', comprado: true),
      _item('B', 'X', sincronizado: false),
      _item('C', 'X'),
    ]);
    expect(resumo.total, 3);
    expect(resumo.comprados, 1);
    expect(resumo.aguardandoEnvio, 1);
    expect(resumo.progresso, closeTo(1 / 3, 0.001));
  });
}