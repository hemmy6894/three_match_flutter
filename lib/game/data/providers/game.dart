import 'package:test_game/common/base_url.dart';
import 'package:test_game/common/end_points/endpoints.dart';
import 'package:test_game/common/requests/request.dart';
import 'package:test_game/common/requests/response.dart';

class GameProvider
{
  static final baseUrl = BaseUrl.baseUrl;
  static Future<Response> getUserToken({payload, token}) async {
    return await ApplicationBaseRequest.get(
        baseUrl, ThreeMatchEndPoint.login,params: payload,
        token: token)
        .request();
  }

  static Future<Response> registerUser({payload, token}) async {
    return await ApplicationBaseRequest.post(
        baseUrl, ThreeMatchEndPoint.register,payload,
        token: token)
        .request();
  }

  static Future<Response> updateUser({payload, token}) async {
    return await ApplicationBaseRequest.post(
        baseUrl, ThreeMatchEndPoint.update,payload,
        token: token)
        .request();
  }

  static Future<Response> friendRequest({payload, token}) async {
    return await ApplicationBaseRequest.post(
        baseUrl, ThreeMatchEndPoint.friendRequest,payload,
        token: token)
        .request();
  }

  static Future<Response> friends({payload, token}) async {
    return await ApplicationBaseRequest.get(
        baseUrl, ThreeMatchEndPoint.friends,params: payload,
        token: token)
        .request();
  }
}