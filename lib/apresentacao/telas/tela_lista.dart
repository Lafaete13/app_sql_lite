import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/identidade.dart';
import '../../dominio/item.dart';
import '../../dominio/regras_item.dart';
import '../componentes/cartao_item.dart';
import '../componentes/faixa_offline.dart';
import '../providers.dart';

class TelaLista extends ConsumerWidget {
  const TelaLista({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itensAsync = ref.watch(itensProvider);
    final online = switch (ref.watch(conectividadeProvider)) {
      AsyncData(:final value) => value,
      _ => true,
    };
    final sincronizando = ref.watch(
      sincronizacaoProvider.select((estado) => estado.emAndamento),
    );

    ref.listen(conectividadeProvider, (anterior, atual) {
      final reconectou =
          anterior is AsyncData<bool> &&
          !anterior.value &&
          atual is AsyncData<bool> &&
          atual.value;
      if (reconectou) {
        ref.read(sincronizacaoProvider.notifier).sincronizar();
      }
    });

    ref.listen(sincronizacaoProvider, (anterior, atual) {
      final mensagem = atual.mensagem;
      if (!atual.emAndamento && mensagem != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(mensagem)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(Identidade.nomeDoApp),
        actions: [
          IconButton(
            tooltip: 'Enviar alterações',
            onPressed: sincronizando
                ? null
                : () => ref.read(sincronizacaoProvider.notifier).sincronizar(),
            icon: sincronizando
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
          ),
          IconButton(
            tooltip: 'Sobre o aplicativo',
            onPressed: () => context.go('/sobre'),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/item/novo'),
        icon: const Icon(Icons.add),
        label: const Text('Novo item'),
      ),
      body: Column(
        children: [
          if (!online) const FaixaOffline(),
          Expanded(
            child: itensAsync.when(
              data: (itens) => _Conteudo(itens: itens),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (erro, _) => _Falha(
                erro: erro,
                aoTentarNovamente: () => ref.invalidate(itensProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Conteudo extends StatelessWidget {
  const _Conteudo({required this.itens});
  final List<Item> itens;

  @override
  Widget build(BuildContext context) {
    if (itens.isEmpty) return const _EstadoVazio();

    final resumo = resumir(itens);
    final alturaDoCartao = MediaQuery.textScalerOf(context).scale(80);

    return LayoutBuilder(
      builder: (context, restricoes) {
        final colunas = restricoes.maxWidth < 600
            ? 1
            : restricoes.maxWidth < 840
            ? 2
            : 3;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _CabecalhoResumo(resumo: resumo)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: colunas,
                  mainAxisExtent: alturaDoCartao,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: itens.length,
                itemBuilder: (context, i) => CartaoItem(item: itens[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CabecalhoResumo extends StatelessWidget {
  const _CabecalhoResumo({required this.resumo});
  final Resumo resumo;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${resumo.comprados} de ${resumo.total} itens comprados',
            style: textos.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: resumo.progresso),
          if (resumo.aguardandoEnvio > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${resumo.aguardandoEnvio} alteração(ões) aguardando envio',
              style: textos.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket_outlined,
              size: 64,
              color: tema.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('A lista está vazia.', style: tema.textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Toque em "Novo item" para começar.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Falha extends StatelessWidget {
  const _Falha({required this.erro, required this.aoTentarNovamente});
  final Object erro;
  final VoidCallback aoTentarNovamente;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Não foi possível ler a lista salva no aparelho.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('$erro', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: aoTentarNovamente,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}