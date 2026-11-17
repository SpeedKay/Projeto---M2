import 'package:flutter/foundation.dart';

import '../../../core/api/api_client.dart';
import '../repository/auth_repository.dart';


class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository, this._apiClient);

  final AuthRepository _repository;
  final ApiClient _apiClient;

  bool isLoading = false;
  String? errorMessage;
  DateTime? _expiresAt;
  String? _accessToken;

  bool get isAuthenticated =>
      _accessToken != null &&
          _expiresAt != null &&
          DateTime.now().isBefore(_expiresAt!);

  Future<bool> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.login(username, password);
      _accessToken = response.accessToken;
      _expiresAt = DateTime.now().add(
        Duration(minutes: response.expiresInMinutes),
      );
      _apiClient.setToken(response.accessToken);
      return true;
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _accessToken = null;
    _expiresAt = null;
    errorMessage = null;
    _apiClient.clearToken();
    notifyListeners();
  }
}