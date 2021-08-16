import '../Networking/ApiProvider.dart';
import 'dart:async';
import '../ApiResponses/LoginResponse.dart';
import '../ApiResponses/VideoListResponse.dart';
import '../ApiResponses/BookListResponse.dart';
import '../ApiResponses/OTPResponse.dart';
import '../ApiResponses/BookGroupListResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/OrderResponse.dart';
import '../ApiResponses/TxnResponse.dart';
import '../ApiResponses/PinCodeResponse.dart';
import '../ApiResponses/HomeAPIResponse.dart';
import '../ApiResponses/TrackOrderResponse.dart';
import '../ApiResponses/ShippingAddressResponse.dart';

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
    final response = await _provider.getWithToken("public/api/v1/userCarts",body,token);
    return BookListResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchAddCartData(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/userCarts",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchDeleteCartData(String id,String token) async {
    final response = await _provider.deleteWithToken("public/api/v1/userCarts/"+id,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchUpdateQTYCartData(String id,var body,String token) async {
    final response = await _provider.putWithToken("public/api/v1/userCarts/"+id,body,token);
    return AddToCartResponse.fromJson(response);
  }

  Future<OrderResponse> fetchAddOrderData(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/orders",body,token);
    return OrderResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchPaymentBookData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/payments",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<BookListResponse> fetchMyBooksData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/mybooks",body,token);
    return BookListResponse.fromJson(response);
  }

  Future<TxnResponse> fetchPostTxnToken(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/create-checksumhash",body,token);
    return TxnResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchVerifyMissCall(var body) async {
    final response = await _provider.get("public/api/v1/auth/verify-miscall",body);
    return AddToCartResponse.fromJson(response);
  }

  Future<PinCodeResponse> fetchPinAddress(var body) async {
    final response = await _provider.get("public/api/v1/get-address",body);
    return PinCodeResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchUpdateOrder(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/payments",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<HomeAPIResponse> fetchHomeData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/auth/home",body,token);
    return HomeAPIResponse.fromJson(response);
  }

  Future<TrackOrderResponse> fetchTrackOrderData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/orders",body,token);
    return TrackOrderResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchAddShippingAddress(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/shipping-addresses",body,token);
    return AddToCartResponse.fromJson(response);
  }

  Future<ShippingAddressResponse> fetchShippingAddressList(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/shipping-addresses",body,token);
    return ShippingAddressResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchUpdateShippingAddress(String id,var body,String token) async {
    final response = await _provider.putWithToken("public/api/v1/shipping-addresses/"+id,body,token);
    return AddToCartResponse.fromJson(response);
  }
}