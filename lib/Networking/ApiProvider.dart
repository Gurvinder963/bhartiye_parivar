
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import '../Networking/CustomException.dart';


class ApiProvider {
  final String _baseUrl = "http://bankjaal.in/";
  final String _baseUrlWithoutHTTP = "bankjaal.in";


  Future<dynamic> get(String url,var queryParameters) async {
    Map<String, String> headerParams = {
      "Content-Type": 'application/json'
    };
    var uri =
    Uri.https(_baseUrl, url, queryParameters);

    var responseJson;
    try {
      final response = await http.get(uri,headers: headerParams);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> getWithToken(String url,var queryParameters,token) async {
    print("my url"+url);
    print("queryParameters"+queryParameters.toString());
    print("token"+token);



    Map<String, String> headerParams = {
      "Content-Type": 'application/json',
      "Authorization":'Bearer '+token
    };
    var uri =
    Uri.http(_baseUrlWithoutHTTP, url, queryParameters);

    var responseJson;
    try {
      final response = await http.get(uri,headers: headerParams);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, String body) async {

    Map<String, String> headerParams = {
      "Content-Type": 'application/json',

    };
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: headerParams,
          body:body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> postWithToken(String url, String body,String token) async {

    Map<String, String> headerParams = {
      "Content-Type": 'application/json',
      "Authorization":'Bearer '+token
    };
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url,
          headers: headerParams,
          body:body);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }



  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}