import 'package:ditonton/common/https_shared.dart';
import 'package:http/http.dart' as http;

class HttpsPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await HttpsShared.createLEClient();

  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }
}
