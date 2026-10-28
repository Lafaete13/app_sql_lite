import 'package:app_sql_lite/dados/remoto/nova_tentativa.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('repete falhas transitórias até obter sucesso', () async {
    var chamadas = 0;
    final resultado = await comNovaTentativa(() async {
      chamadas++;
      if (chamadas < 3) throw const FalhaTransitoria('rede instável');
      return 'ok';
    }, esperaBase: Duration.zero);
    expect(resultado, 'ok');
    expect(chamadas, 3);
  });

  test('desiste após o número máximo de tentativas', () async {
    var chamadas = 0;
    await expectLater(
      comNovaTentativa<void>(
        () async {
          chamadas++;
          throw const FalhaTransitoria('servidor fora do ar');
        },
        maxTentativas: 2,
        esperaBase: Duration.zero,
      ),
      throwsA(isA<FalhaTransitoria>()),
    );
    expect(chamadas, 2);
  });
}