
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import '../Networking/CustomException.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ApiProvider {
  bool isDialogShowing=false;
  final String _baseUrl = "http://bankjaal.in/";
  final String _SMSbaseUrl = "smppsmshub.in";
  final String _baseUrlWithoutHTTP = "bankjaal.in";


  Future<dynamic> get(String url,var queryParameters) async {
    Map<String, String> headerParams = {
      "Content-Type": 'application/json'
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

  Future<dynamic> getSMS(String url,var queryParameters) async {
    Map<String, String> headerParams = {
      "Content-Type": 'application/json'
    };
    var uri =
    Uri.https(_SMSbaseUrl, url, queryParameters);

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
    print("my_uri"+uri.toString());
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
    print("my_uri---"+url.toString());
    print("body---"+body.toString());
    print("token---"+token);
    Map<String, String> headerParams = {
      "Content-Type": 'application/json',
      'Accept': 'application/json',
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
  Future<dynamic> deleteWithToken(String url,String token) async {

    Map<String, String> headerParams = {
      "Content-Type": 'application/json',
      "Authorization":'Bearer '+token
    };
    var responseJson;
    try {
      final response = await http.delete(_baseUrl + url,
          headers: headerParams,
          );
      responseJson = _response(response);
      print(responseJson.toString());
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> putWithToken(String url, String body,String token) async {

    print("my_uri---"+url.toString());
    print("body---"+body.toString());
    print("token---"+token);


    Map<String, String> headerParams = {
      "Content-Type": 'application/json',
      "Authorization":'Bearer '+token
    };
    var responseJson;
    try {
      final response = await http.put(_baseUrl + url,
        headers: headerParams,
          body:body
      );
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
        print("---print context:${NavigationService.navigatorKey.currentContext}");
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        isDialogShowing=false;
        print("---print context:${NavigationService.navigatorKey.currentContext}");
        return responseJson;
      case 204:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        isDialogShowing=false;
        return responseJson;
      case 422:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;

      case 400:
        throw BadRequestException(response.body.toString());
      case 401:

      case 403:
        if(!isDialogShowing){
          isDialogShowing=true;
        showAlertDialogValidation();
        }
        throw UnauthorisedException(response.body.toString());
      case 500:
        var responseJson = json.decode(response.body.toString());
        print(responseJson);
        return responseJson;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
  removeFromSF(var context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pop(context, true);
    exit(0);
  }

  showAlertDialogValidation() {

    var context=NavigationService.navigatorKey.currentContext;

    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        removeFromSF(context);


      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oops!"),
      content: Text("Looks like you are logged-in with different location or another variant of bhartiya pariwar app."),
      actions: [
        okButton,
      ],
    );


    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}