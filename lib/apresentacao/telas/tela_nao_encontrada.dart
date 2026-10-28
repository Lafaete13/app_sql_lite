import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TelaNaoEncontrada extends StatelessWidget {
  const TelaNaoEncontrada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página não encontrada')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'O endereço solicitado não corresponde a nenhum item da lista.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Ir para a lista'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}