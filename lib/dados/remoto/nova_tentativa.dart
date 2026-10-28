import 'dart:math';

class FalhaTransitoria implements Exception {
  const FalhaTransitoria(this.mensagem);
  final String mensagem;

  @override
  String toString() => 'FalhaTransitoria: $mensagem';
}

Future<T> comNovaTentativa<T>(
  Future<T> Function() operacao, {
  int maxTentativas = 3,
  Duration esperaBase = const Duration(milliseconds: 500),
  Random? aleatorio,
}) async {
  final sorteio = aleatorio ?? Random();
  var tentativa = 0;
  while (true) {
    try {
      return await operacao();
    } on FalhaTransitoria {
      tentativa++;
      if (tentativa >= maxTentativas) rethrow;
      final exponencial = esperaBase * (1 << (tentativa - 1));
      final limiteDoJitter = esperaBase.inMilliseconds;
      final jitter = Duration(
        milliseconds: limiteDoJitter > 0 ? sorteio.nextInt(limiteDoJitter) : 0,
      );
      await Future<void>.delayed(exponencial + jitter);
    }
  }
}