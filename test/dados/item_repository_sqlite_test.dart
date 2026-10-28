import 'package:app_sql_lite/dados/local/banco_de_dados.dart';
import 'package:app_sql_lite/dados/local/item_repository_sqlite.dart';
import 'package:app_sql_lite/dominio/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late BancoDeDados banco;
  late ItemRepositorySqlite repositorio;

  setUpAll(sqfliteFfiInit);

  setUp(() {
    // Banco em memória: cada teste começa vazio e nada é gravado em disco.
    banco = BancoDeDados(
      fabrica: databaseFactoryFfi,
      caminho: inMemoryDatabasePath,
    );
    repositorio = ItemRepositorySqlite(banco);
  });

  tearDown(() => banco.fechar());

  Item novo(String nome) {
    final data = DateTime(2026, 3, 1);
    return Item(
      nome: nome,
      categoria: 'Mercearia',
      criadoEm: data,
      atualizadoEm: data,
    );
  }

  test('insere e lê de volta todos os campos', () async {
    final salvo = await repositorio.salvar(
      novo('Café').copyWith(quantidade: 2, observacao: 'Torra média'),
    );
    expect(salvo.id, isNotNull);

    final lido = (await repositorio.listar()).single;
    expect(lido.id, salvo.id);
    expect(lido.nome, 'Café');
    expect(lido.quantidade, 2);
    expect(lido.observacao, 'Torra média');
    expect(lido.comprado, isFalse);
    expect(lido.sincronizado, isFalse);
  });

  test('atualiza um item existente sem duplicá-lo', () async {
    final salvo = await repositorio.salvar(novo('Leite'));
    await repositorio.salvar(salvo.copyWith(comprado: true));

    final itens = await repositorio.listar();
    expect(itens, hasLength(1));
    expect(itens.single.comprado, isTrue);
  });

  test('exclui pelo id', () async {
    final salvo = await repositorio.salvar(novo('Pão'));
    await repositorio.excluir(salvo.id!);
    expect(await repositorio.listar(), isEmpty);
  });

  test('marca como enviada a versão que foi enviada', () async {
    await repositorio.salvar(novo('Sal'));
    final enviado = (await repositorio.listarNaoSincronizados()).single;
    await repositorio.marcarComoSincronizado(enviado);
    expect(await repositorio.listarNaoSincronizados(), isEmpty);
  });

  test('não marca como enviada uma versão alterada durante o envio', () async {
    final salvo = await repositorio.salvar(novo('Ovos'));
    final enviado = (await repositorio.listarNaoSincronizados()).single;

    // Alteração feita depois da leitura para envio e antes da confirmação.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await repositorio.salvar(salvo.copyWith(quantidade: 12));
    await repositorio.marcarComoSincronizado(enviado);

    expect(await repositorio.listarNaoSincronizados(), hasLength(1));
  });
}