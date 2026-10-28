import 'item.dart';

const tamanhoMinimoNome = 2;
const tamanhoMaximoNome = 40;
const quantidadeMinima = 1;
const quantidadeMaxima = 99;

String? validarNome(String nome) {
  final texto = nome.trim();
  if (texto.isEmpty) return 'Informe o nome do item.';
  if (texto.length < tamanhoMinimoNome) return 'Use ao menos $tamanhoMinimoNome caracteres.';
  if (texto.length > tamanhoMaximoNome) return 'Use no máximo $tamanhoMaximoNome caracteres.';
  return null;
}

int ajustarQuantidade(int atual, int variacao) =>
    (atual + variacao).clamp(quantidadeMinima, quantidadeMaxima);

List<Item> ordenarParaExibicao(Iterable<Item> itens) {
  final lista = itens.toList();
  lista.sort((a, b) {
    if (a.comprado != b.comprado) return a.comprado ? 1 : -1;
    final porCategoria = a.categoria.toLowerCase().compareTo(b.categoria.toLowerCase());
    if (porCategoria != 0) return porCategoria;
    return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
  });
  return lista;
}

class Resumo {
  const Resumo({required this.total, required this.comprados, required this.aguardandoEnvio});
  final int total;
  final int comprados;
  final int aguardandoEnvio;
  double get progresso => total == 0 ? 0.0 : comprados / total;
}

Resumo resumir(Iterable<Item> itens) {
  var total = 0, comprados = 0, aguardandoEnvio = 0;
  for (final item in itens) {
    total++;
    if (item.comprado) comprados++;
    if (!item.sincronizado) aguardandoEnvio++;
  }
  return Resumo(total: total, comprados: comprados, aguardandoEnvio: aguardandoEnvio);
}