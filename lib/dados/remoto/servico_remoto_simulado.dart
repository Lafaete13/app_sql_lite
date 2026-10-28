import 'dart:math';
import '../../dominio/item.dart';
import 'nova_tentativa.dart';

class ServicoRemotoSimulado {
  ServicoRemotoSimulado({this.taxaDeFalha = 0.3, Random? aleatorio})
      : _aleatorio = aleatorio ?? Random();

  final double taxaDeFalha;
  final Random _aleatorio;

  Future<void> enviar(Item item) async {
    await Future<void>.delayed(
      Duration(milliseconds: 200 + _aleatorio.nextInt(600)),
    );
    if (_aleatorio.nextDouble() < taxaDeFalha) {
      throw const FalhaTransitoria('Servidor indisponível (simulação).');
    }
  }
}