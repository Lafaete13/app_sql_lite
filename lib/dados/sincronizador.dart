import '../dominio/item_repository.dart';
import 'remoto/nova_tentativa.dart';
import 'remoto/servico_remoto_simulado.dart';

class ResultadoSincronizacao {
  const ResultadoSincronizacao({required this.enviados, required this.falhas});

  final int enviados;
  final int falhas;
}

class Sincronizador {
  Sincronizador(this._repositorio, this._remoto);

  final ItemRepository _repositorio;
  final ServicoRemotoSimulado _remoto;

  Future<ResultadoSincronizacao> sincronizar() async {
    final pendentes = await _repositorio.listarNaoSincronizados();
    var enviados = 0, falhas = 0;
    for (final item in pendentes) {
      try {
        await comNovaTentativa(() => _remoto.enviar(item));
        await _repositorio.marcarComoSincronizado(item);
        enviados++;
      } on FalhaTransitoria {
        falhas++;
      }
    }
    return ResultadoSincronizacao(enviados: enviados, falhas: falhas);
  }
}