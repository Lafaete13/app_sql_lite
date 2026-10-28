import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../dominio/item.dart';
import '../providers.dart';

class CartaoItem extends ConsumerWidget {
  const CartaoItem({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cores = Theme.of(context).colorScheme;
    final notifier = ref.read(itensProvider.notifier);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: cores.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: cores.onErrorContainer),
      ),
      onDismissed: (_) => notifier.excluir(item),
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          onTap: () => context.go('/item/${item.id}'),
          leading: Checkbox(
            value: item.comprado,
            onChanged: (_) => notifier.alternarComprado(item),
          ),
          title: Text(
            item.nome,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: item.comprado
                ? const TextStyle(decoration: TextDecoration.lineThrough)
                : null,
          ),
          subtitle: Text(
            '${item.categoria} · ${item.quantidade} un.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(
            item.sincronizado
                ? Icons.cloud_done_outlined
                : Icons.cloud_upload_outlined,
            color: item.sincronizado ? cores.primary : cores.outline,
            semanticLabel: item.sincronizado
                ? 'Enviado ao servidor'
                : 'Aguardando envio',
          ),
        ),
      ),
    );
  }
}