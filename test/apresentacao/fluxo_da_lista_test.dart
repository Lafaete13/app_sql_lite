import 'package:app_sql_lite/app.dart';
import 'package:app_sql_lite/apresentacao/providers.dart';
import 'package:app_sql_lite/dominio/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../apoio/repositorio_em_memoria.dart';

void main() {
  testWidgets('lista os itens salvos e adiciona um item novo', (tester) async {
    final data = DateTime(2026, 1, 1);
    final repositorio = RepositorioEmMemoria([
      Item(
        id: 1,
        nome: 'Arroz',
        categoria: 'Mercearia',
        criadoEm: data,
        atualizadoEm: data,
      ),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        // Substitui o SQLite e o plugin de conectividade por versões de teste.
        overrides: [
          itemRepositoryProvider.overrideWithValue(repositorio),
          conectividadeProvider.overrideWith((ref) => Stream.value(true)),
        ],
        child: const AppCompras(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Arroz'), findsOneWidget);

    // Salvar sem nome: a regra de domínio recusa e a mensagem aparece.
    await tester.tap(find.text('Novo item'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar à lista'));
    await tester.pump();
    expect(find.text('Informe o nome do item.'), findsOneWidget);

    // Com nome preenchido, o item é salvo e a lista volta a ser exibida.
    await tester.enterText(find.byType(TextFormField).first, 'Café');
    await tester.tap(find.text('Adicionar à lista'));
    await tester.pumpAndSettle();
    expect(find.text('Café'), findsOneWidget);
    expect(find.text('Arroz'), findsOneWidget);
  });
}