import 'item.dart';

abstract interface class ItemRepository {
  Future<List<Item>> listar();
  Future<Item> salvar(Item item);
  Future<void> excluir(int id);
  Future<List<Item>> listarNaoSincronizados();
  Future<void> marcarComoSincronizado(Item item);
}