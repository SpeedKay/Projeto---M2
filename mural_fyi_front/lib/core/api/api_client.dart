import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',    // Alterar depois
  );

  final http.Client _client;
  String? _accessToken;

  void setToken(String token) => _accessToken = token; // Lembrar dos metodos de Token

  void clearToken() => _accessToken = null;

  Uri buildUri(String path, {Map<String, String>? queryParameters}) {
    final root = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$root$normalizedPath')
        .replace(queryParameters: queryParameters);
  }

  Map<String, String> get authorizationHeaders => {
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Future<dynamic> get(
      String path, {
        Map<String, String>? queryParameters,
      }) async {
    try {
      final response = await _client.get(
        buildUri(path, queryParameters: queryParameters),
        headers: {'Accept': 'application/json', ...authorizationHeaders},
      );
      return _decodeResponse(response);
    } on http.ClientException catch (error) {
      throw ApiException('Falha na conexão com a API: ${error.message}');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        buildUri(path),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...authorizationHeaders,
        },
        body: jsonEncode(body),
      );
      return _decodeResponse(response);
    } on http.ClientException catch (error) {
      throw ApiException('Falha na conexão com a API: ${error.message}');
    }
  }

  dynamic _decodeResponse(http.Response response) {
    dynamic body;
    try {
      body = response.body.isEmpty ? null : jsonDecode(response.body);
    } on FormatException {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        throw const ApiException('A API retornou um JSON inválido.');
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    String message = 'Erro HTTP ${response.statusCode}';
    if (body is Map<String, dynamic>) {
      final detail = body['detail'];
      final title = body['title'];
      if (detail is String && detail.isNotEmpty) {
        message = detail;
      } else if (title is String && title.isNotEmpty) {
        message = title;
      }
    }
    throw ApiException(message, statusCode: response.statusCode);
  }

  void close() => _client.close();
}