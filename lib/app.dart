import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'apresentacao/rotas.dart';
import 'config/identidade.dart';

class AppCompras extends ConsumerWidget {
  const AppCompras({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: Identidade.nomeDoApp,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Identidade.corSemente),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Identidade.corSemente,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: ref.watch(roteadorProvider),
    );
  }
}