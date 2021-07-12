import '../Networking/ApiProvider.dart';
import 'dart:async';
import '../ApiResponses/LoginResponse.dart';

class MainRepository {
  ApiProvider _provider = ApiProvider();

  Future<LoginResponse> fetchLoginData(String body) async {
    final response = await _provider.post("api/v2/auth/login",body);
    return LoginResponse.fromJson(response);
  }
}