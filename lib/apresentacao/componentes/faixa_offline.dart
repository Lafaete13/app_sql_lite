import 'package:flutter/material.dart';

class FaixaOffline extends StatelessWidget {
  const FaixaOffline({super.key});

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Semantics(
      liveRegion: true,
      child: Material(
        color: cores.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.wifi_off, size: 20, color: cores.onSecondaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sem conexão. As alterações ficam salvas no aparelho e serão enviadas depois.',
                  style: TextStyle(color: cores.onSecondaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}