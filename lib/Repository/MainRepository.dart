import '../Networking/ApiProvider.dart';
import 'dart:async';
import '../ApiResponses/LoginResponse.dart';
import '../ApiResponses/VideoListResponse.dart';
import '../ApiResponses/BookListResponse.dart';
import '../ApiResponses/OTPResponse.dart';
import '../ApiResponses/BookGroupListResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';

class MainRepository {
  ApiProvider _provider = ApiProvider();

  Future<OTPResponse> fetchOTPData(var body) async {
    final response = await _provider.getSMS("api/mt/SendSMS",body);
    return OTPResponse.fromJson(response);
  }


  Future<LoginResponse> fetchLoginData(String body) async {
    final response = await _provider.post("public/api/v1/auth/login",body);
    return LoginResponse.fromJson(response);
  }

  Future<LoginResponse> fetchProfileData(String body) async {
    final response = await _provider.post("public/api/v1/auth/register",body);
    return LoginResponse.fromJson(response);
  }
  Future<VideoListResponse> fetchVideoData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/videos",body,token);
    return VideoListResponse.fromJson(response);
  }
  Future<BookListResponse> fetchBooksData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/books",body,token);
    return BookListResponse.fromJson(response);
  }
  Future<BookGroupListResponse> fetchBooksGroupData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/books-collection",body,token);
    return BookGroupListResponse.fromJson(response);
  }
  Future<BookListResponse> fetchCartListBooksData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/user-carts",body,token);
    return BookListResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchAddCartData(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/user-carts",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchDeleteCartData(String id,String token) async {
    final response = await _provider.deleteWithToken("public/api/v1/user-carts/"+id,token);
    return AddToCartResponse.fromJson(response);
  }
}