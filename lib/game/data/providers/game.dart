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

  static Future<Response> tasks({payload, token}) async {
    return await ApplicationBaseRequest.post(
        baseUrl, ThreeMatchEndPoint.tasks,payload,
        token: token)
        .request();
  }

  static Future<Response> assignTasks({payload, token}) async {
    return await ApplicationBaseRequest.post(
        baseUrl, ThreeMatchEndPoint.assign,payload,
        token: token)
        .request();
  }

  static Future<Response> pullAssigns({payload, token}) async {
    return await ApplicationBaseRequest.get(
        baseUrl, ThreeMatchEndPoint.assignLists, params: payload,
        token: token)
        .request();
  }

  static Future<Response> getGenders({payload, token}) async {
    return await ApplicationBaseRequest.get(
        baseUrl, ThreeMatchEndPoint.gender, params: payload,
        token: token)
        .request();
  }

  static Future<Response> getCountries({payload, token}) async {
    return await ApplicationBaseRequest.get(
        baseUrl, ThreeMatchEndPoint.country, params: payload,
        token: token)
        .request();
  }
}