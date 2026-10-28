class Item {
  const Item({
    this.id,
    required this.nome,
    this.quantidade = 1,
    required this.categoria,
    this.observacao = '',
    this.comprado = false,
    this.sincronizado = false,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  final int? id;
  final String nome;
  final int quantidade;
  final String categoria;
  final String observacao;
  final bool comprado;
  final bool sincronizado;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  Item copyWith({
    int? id,
    String? nome,
    int? quantidade,
    String? categoria,
    String? observacao,
    bool? comprado,
    bool? sincronizado,
    DateTime? atualizadoEm,
  }) {
    return Item(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      categoria: categoria ?? this.categoria,
      observacao: observacao ?? this.observacao,
      comprado: comprado ?? this.comprado,
      sincronizado: sincronizado ?? this.sincronizado,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}