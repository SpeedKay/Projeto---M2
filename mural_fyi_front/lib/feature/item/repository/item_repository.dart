import '../../../core/api/api_client.dart';
import '../model/item_create_request.dart';
import '../model/item_model.dart';

class ItemRepository {
  const ItemRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ItemModel>> findAll() async {
    final data = await _apiClient.get('/items') as List<dynamic>;
    return data
        .map((entry) => ItemModel.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<List<ItemModel>> findByName(String name) async {
    final data = await _apiClient.get(
      '/items',
      queryParameters: {'name': name},
    ) as List<dynamic>;
    return data
        .map((entry) => ItemModel.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<ItemModel> create(ItemCreateRequest request) async {
    final data = await _apiClient.post('/items', request.toJson());
    return ItemModel.fromJson(data as Map<String, dynamic>);
  }
}