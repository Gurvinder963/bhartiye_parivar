import 'package:bhartiye_parivar/ApiResponses/AboutUsResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/CheckDonateResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/DonateHomePageResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/InformationAPIResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/LiveDataResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/SeriesHomeListResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/SeriesListResponse.dart';
import 'package:bhartiye_parivar/ApiResponses/SocialMediaResponse.dart';

import '../Networking/ApiProvider.dart';
import 'dart:async';
import '../ApiResponses/LoginResponse.dart';
import '../ApiResponses/VideoListResponse.dart';
import '../ApiResponses/BookListResponse.dart';
import '../ApiResponses/OTPResponse.dart';
import '../ApiResponses/BookGroupListResponse.dart';
import '../ApiResponses/AddToCartResponse.dart';
import '../ApiResponses/ContactUsResponse.dart';

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
import '../ApiResponses/DonateOrderSaveResponse.dart';
import '../ApiResponses/NotificationListResponse.dart';
import '../ApiResponses/DonateHistoryResponse.dart';
import '../ApiResponses/JoinUsResponse.dart';
import '../ApiResponses/ReferHistoryResponse.dart';
import '../ApiResponses/ReferDetailResponse.dart';
import '../ApiResponses/OTPCountResponse.dart';
import '../ApiResponses/LangResponse.dart';
import '../ApiResponses/AppChannelResponse.dart';
import '../ApiResponses/VerifyMissCallResponse.dart';
import '../ApiResponses/GetProfileResponse.dart';
import '../ApiResponses/SideBarApiResponse.dart';
import '../ApiResponses/LogoutResponse.dart';
import '../ApiResponses/VideoTrendingListResponse.dart';
import '../ApiResponses/VideoDetailJAVAResponse.dart';
import '../ApiResponses/FaqDataResponse.dart';
import '../ApiResponses/ChatGroupResponse.dart';
import '../ApiResponses/JoinUsNewResponse.dart';
import '../ApiResponses/DonateHomePageResponse.dart';

class MainRepository {
  ApiProvider _provider = ApiProvider();

  Future<OTPResponse> fetchOTPData(var body) async {
    final response = await _provider.getSMS("api/mt/SendSMS",body);
    return OTPResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchOTPDataJAVA(var body) async {
    final response = await _provider.postJAVA("api/loginotp",body);
    return AddToCartResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchCreateProfileNational(var body) async {
    final response = await _provider.postJAVA("api/createprofile",body);
    return AddToCartResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchUpdateProfileJava(var body) async {
    final response = await _provider.postJAVA("api/changenumber",body);
    return AddToCartResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchReferSaveJava(var body) async {
    final response = await _provider.postJAVA("api/referapp",body);
    return AddToCartResponse.fromJson(response);
  }

  Future<LogoutResponse> fetchLogoutJava(var body) async {
    final response = await _provider.postJAVA("api/logout",body);
    return LogoutResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchActiveUsers(var body) async {
    final response = await _provider.postJAVA("api/activeuser",body);
    return AddToCartResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchNotificationSettingButton(var body) async {
    final response = await _provider.postJAVA("api/notificationbutton",body);
    return AddToCartResponse.fromJson(response);
  }

  Future<SideBarApiResponse> fetchSidebarApI(var body) async {
    final response = await _provider.postJAVA("api/sidebar",body);
    return SideBarApiResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchChangeNumberJAVA(var body) async {
    final response = await _provider.postJAVA("api/changenumber",body);
    return AddToCartResponse.fromJson(response);
  }


  Future<VideoListResponse> fetchVideoListJAVA(var body) async {
    final response = await _provider.postJAVA("api/homeVideoMain",body);
    return VideoListResponse.fromJson(response);
  }

  Future<VideoTrendingListResponse> fetchVideoListTrendingJAVA(var body) async {
    final response = await _provider.postJAVA("api/homeVideoTrending",body);
    return VideoTrendingListResponse.fromJson(response);
  }

  Future<LiveDataResponse> fetchVideoListLiveJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeLiveNow",body);
    return LiveDataResponse.fromJson(response);
  }


  Future<VideoTrendingListResponse> fetchVideoListOthersJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeVideoCategory",body);
    return VideoTrendingListResponse.fromJson(response);
  }
  Future<VideoTrendingListResponse> fetchVideoListHomeSuggestJAVA(var body) async {
    final response = await _provider.postJAVA("api/homeVideoMainSuggestion",body);
    return VideoTrendingListResponse.fromJson(response);
  }

  Future<VideoTrendingListResponse> fetchVideoListTrendingSuggestJAVA(var body) async {
    final response = await _provider.postJAVA("api/homeVideoTrendingSuggestion",body);
    return VideoTrendingListResponse.fromJson(response);
  }

  Future<VideoTrendingListResponse> fetchVideoListCategorySuggestJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeVideoCategorySuggestion",body);
    return VideoTrendingListResponse.fromJson(response);
  }

  Future<VideoDetailJAVAResponse> fetchVideoDetailDataJAVA(var body) async {
    final response = await _provider.postJAVA("api/VideoDetails",body);
    return VideoDetailJAVAResponse.fromJson(response);
  }

  Future<LiveDataResponse> fetchLiveVideoListJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeLiveNow",body);
    return LiveDataResponse.fromJson(response);
  }

  Future<LiveDataResponse> fetchLiveVideoSuggestListJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeLiveNowSuggestion",body);
    return LiveDataResponse.fromJson(response);
  }

  Future<FaqDataResponse> fetchFaqsListJAVA(var body) async {
    final response = await _provider.postJAVA("api/faqs",body);
    return FaqDataResponse.fromJson(response);
  }

Future<ContactUsResponse> fetchContactListJAVA(var body) async {
    final response = await _provider.postJAVA("api/contactus",body);
    return ContactUsResponse.fromJson(response);
  }

Future<AboutUsResponse> fetchAboutUsJAVA(var body) async {
    final response = await _provider.postJAVA("api/aboutus",body);
    return AboutUsResponse.fromJson(response);
  }
  

  Future<SeriesHomeListResponse> fetchSeriesHomeJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeSeries",body);
    return SeriesHomeListResponse.fromJson(response);
  }

  Future<SeriesListResponse> fetchSeriesListJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeSeriesVideo",body);
    return SeriesListResponse.fromJson(response);
  }

  Future<SeriesListResponse> fetchSeriesSuggestListJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeSeriesVideoSuggestion",body);
    return SeriesListResponse.fromJson(response);
  }


  Future<ChatGroupResponse> fetchChatListJAVA(var body) async {
    final response = await _provider.postJAVA("api/HomeChatGroup",body);
    return ChatGroupResponse.fromJson(response);
  }

  Future<SocialMediaResponse> fetchSocialMediaJAVA(var body) async {
    final response = await _provider.postJAVA("api/SocialMedia",body);
    return SocialMediaResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchSaveJoinUsJAVA(var body) async {
    final response = await _provider.postJAVA("api/savejoinus",body);
    return AddToCartResponse.fromJson(response);
  }
  Future<JoinUsNewResponse> fetchGetJoinUsJAVA(var body) async {
    final response = await _provider.postJAVA("api/getjoinus",body);
    return JoinUsNewResponse.fromJson(response);
  }

  Future<CheckDonateResponse> fetchCheckJoinDonateJAVA(var body) async {
    final response = await _provider.postJAVA("api/checkjoindonate",body);
    return CheckDonateResponse.fromJson(response);
  }

Future<InformationAPIResponse> fetchInformationAPIJAVA(var body) async {
    final response = await _provider.postJAVA("api/information",body);
    return InformationAPIResponse.fromJson(response);
  }


  Future<VideoTrendingListResponse> fetchVideoBookmarkListJAVA(var body) async {
    final response = await _provider.postJAVA("api/videobookmarks",body);
    return VideoTrendingListResponse.fromJson(response);
  }

  Future<VideoTrendingListResponse> fetchVideoSearchQueryListJAVA(var body) async {
    final response = await _provider.postJAVA("api/videosearchquery",body);
    return VideoTrendingListResponse.fromJson(response);
  }

  Future<SeriesHomeListResponse> fetchVideoSeriesSearchQueryListJAVA(var body) async {
    final response = await _provider.postJAVA("api/SeriesSearchQuery",body);
    return SeriesHomeListResponse.fromJson(response);
  }

  Future<LiveDataResponse> fetchVideoLiveSearchQueryListJAVA(var body) async {
    final response = await _provider.postJAVA("api/LiveSearchQuery",body);
    return LiveDataResponse.fromJson(response);
  }

Future<ChatGroupResponse> fetchChatSearchQueryListJAVA(var body) async {
    final response = await _provider.postJAVA("api/ChatGroupSearchQuery",body);
    return ChatGroupResponse.fromJson(response);
  }


  Future<VideoTrendingListResponse> fetchVideoSearchResultListJAVA(var body) async {
    final response = await _provider.postJAVA("api/videosearchResult",body);
    return VideoTrendingListResponse.fromJson(response);
  }

  Future<SeriesHomeListResponse> fetchVideoSeriesSearchResultListJAVA(var body) async {
    final response = await _provider.postJAVA("api/SeriesSearchResult",body);
    return SeriesHomeListResponse.fromJson(response);
  }
  Future<LiveDataResponse> fetchVideoLiveSearchResultListJAVA(var body) async {
    final response = await _provider.postJAVA("api/LiveSearchResult",body);
    return LiveDataResponse.fromJson(response);
  }

  Future<ChatGroupResponse> fetchChatSearchResultListJAVA(var body) async {
    final response = await _provider.postJAVA("api/ChatGroupSearchResult",body);
    return ChatGroupResponse.fromJson(response);
  }

 Future<AddToCartResponse> fetchReportSaveJAVA(var body) async {
    final response = await _provider.postJAVA("api/reportcontent",body);
    return AddToCartResponse.fromJson(response);
  }

 Future<DonateHomePageResponse> fetchDonateHomeJAVA(var body) async {
    final response = await _provider.postJAVA("api/donateus",body);
    return DonateHomePageResponse.fromJson(response);
  }

   Future<DonateOrderSaveResponse> fetchDonateOrderSaveJAVA(var body) async {
    final response = await _provider.postJAVA("api/paytm",body);
    return DonateOrderSaveResponse.fromJson(response);
  }

  Future<AddToCartResponse> fetchDonateOrderUpdateJAVA(var body) async {
    final response = await _provider.postJAVA("api/updatedonatestatus",body);
    return AddToCartResponse.fromJson(response);
  }

 Future<DonateHistoryResponse> fetchDonateHistoryJAVA(var body) async {
    final response = await _provider.postJAVA("api/donationhistory",body);
    return DonateHistoryResponse.fromJson(response);
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

  Future<DonateOrderSaveResponse> fetchDonateOrderSave(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/user-donations",body,token);
    return DonateOrderSaveResponse.fromJson(response);
  }

  Future<DonateHistoryResponse> fetchDonationHistoryData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/user-donations",body,token);
    return DonateHistoryResponse.fromJson(response);
  }

  Future<DonateOrderSaveResponse> fetchUpdateDonateOrder(String id,var body,String token) async {
    final response = await _provider.putWithToken("public/api/v1/user-donations/"+id,body,token);
    return DonateOrderSaveResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchReportSave(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/abusing-reports",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchJoinUsSave(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/save-join-us",body,token);
    return AddToCartResponse.fromJson(response);
  }

  Future<JoinUsResponse> fetchJoinUsData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/get-join-us",body,token);
    return JoinUsResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchReferSave(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/user-refers",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<ReferHistoryResponse> fetchReferData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/user-refers",body,token);
    return ReferHistoryResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchDeleteReferData(String id,String token) async {
    final response = await _provider.deleteWithToken("public/api/v1/user-refers/"+id,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<ReferDetailResponse> fetchReferDetailData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/user-refer-details",body,token);
    return ReferDetailResponse.fromJson(response);
  }
  Future<OTPCountResponse> fetchOTPCountData(var body) async {
    final response = await _provider.post("public/api/v1/auth/opt-count",body);
    return OTPCountResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchAppLauchCount(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/auth/app-launch-count",body,token);
    return AddToCartResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchSaveUserLang(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/auth/save-user-lang",body,token);
    return AddToCartResponse.fromJson(response);
  }

  Future<LangResponse> fetchLangData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/auth/get-user-lang",body,token);
    return LangResponse.fromJson(response);
  }
  Future<AddToCartResponse> fetchSaveVideoInput(var body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/video-record",body,token);
    return AddToCartResponse.fromJson(response);
  }

  Future<AppChannelResponse> fetchAppChannel(var body) async {
    final response = await _provider.get("public/api/v1/channels",body);
    return AppChannelResponse.fromJson(response);
  }
  Future<LoginResponse> fetchUpdateProfileData(String body,String token) async {
    final response = await _provider.postWithToken("public/api/v1/auth/update",body,token);
    return LoginResponse.fromJson(response);
  }

  Future<VerifyMissCallResponse> fetchLoginVerifyMissCall(var body) async {
    final response = await _provider.post("public/api/v1/auth/login-verify-misscall",body);
    return VerifyMissCallResponse.fromJson(response);
  }

  Future<GetProfileResponse> fetchUserProfileData(var body,String token) async {
    final response = await _provider.getWithToken("public/api/v1/auth/me",body,token);
    return GetProfileResponse.fromJson(response);
  }
}