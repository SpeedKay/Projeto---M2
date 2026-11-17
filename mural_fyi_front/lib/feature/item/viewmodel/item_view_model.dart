import 'package:flutter/foundation.dart';

import '../model/item_create_request.dart';
import '../model/item_model.dart';
import '../repository/item_repository.dart';


class ItemViewModel extends ChangeNotifier {
  ItemViewModel(this._repository);

  final ItemRepository _repository;

  List<ItemModel> items = [];
  bool isLoading = false;
  String? errorMessage;
  String currentSearch = '';

  Future<void> loadItems() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      items = currentSearch.isEmpty
          ? await _repository.findAll()
          : await _repository.findByName(currentSearch);
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchItems(String name) async {
    currentSearch = name.trim();
    await loadItems();
  }

  Future<ItemModel> createItem(ItemCreateRequest request) async {
    final created = await _repository.create(request);
    await loadItems();
    return created;
  }
}