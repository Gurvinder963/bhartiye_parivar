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
import '../ApiResponses/BookDetailResponse.dart';
import '../ApiResponses/NewsResponse.dart';
import '../ApiResponses/VideoDetailResponse.dart';
import '../ApiResponses/NewsDetailResponse.dart';
import '../ApiResponses/BookMarkSaveResponse.dart';
import '../ApiResponses/BookmarkResponse.dart';
import '../ApiResponses/SearchResponse.dart';
import '../ApiResponses/NotificationListResponse.dart';

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
  Future<VideoDetailResponse> fetchVideoDetailData(String id,var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/videos/"+id,body,token);
    return VideoDetailResponse.fromJson(response);
  }

  Future<BookListResponse> fetchBooksData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/books",body,token);
    return BookListResponse.fromJson(response);
  }

  Future<BookDetailResponse> fetchBooksDetailData(String id,var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/books/"+id,body,token);
    return BookDetailResponse.fromJson(response);
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

  Future<AddToCartResponse> fetchDeleteMyBooksData(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/delete/mybooks",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchAddMyBooksData(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/mybooks",body,token);
    return AddToCartResponse.fromJson(response);
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

  Future<NewsResponse> fetchNewsData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/news",body,token);
    return NewsResponse.fromJson(response);
  }
  Future<NewsDetailResponse> fetchNewsDetailData(String id,var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/news/"+id,body,token);
    return NewsDetailResponse.fromJson(response);
  }
  Future<BookMarkSaveResponse> fetchAddBookMark(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/bookmarks",body,token);
    return BookMarkSaveResponse.fromJson(response);
  }

  Future<BookmarkListResponse> fetchBookmarkData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/bookmarks",body,token);
    return BookmarkListResponse.fromJson(response);
  }
  Future<SearchResponse> fetchSearchData(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/search",body,token);
    return SearchResponse.fromJson(response);
  }

  Future<BookmarkListResponse> fetchNotificationData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/notification-list",body,token);
    return BookmarkListResponse.fromJson(response);
  }
  Future<AddToCartResponse> savePollAnswers(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/save-answer",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchReadBook(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/read-book",body,token);
    return AddToCartResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchReadNotification(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/read-notification",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchSubscribeChannel(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/subscriptions",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchSaveLikeStatus(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/like-dislike",body,token);
    return AddToCartResponse.fromJson(response);
  }
}