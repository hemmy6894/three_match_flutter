import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:test_game/common/requests/response.dart';

class ApplicationBaseRequest {
  String baseUrl;
  String endpoint;
  String method;
  Map<String, dynamic>? data;
  String? token;
  Uri Function(String, String, [Map<String, dynamic>]) getUri;

  ApplicationBaseRequest._({
    required this.baseUrl,
    required this.endpoint,
    required this.method,
    this.data,
    this.token,
    required this.getUri,
  });

  factory ApplicationBaseRequest.bootstrap({
    required String baseUrl,
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    String? token,
  }) {
    _getUri(String baseUrl, String endpoint, [Map<String, dynamic>? params]) {
      if (!kReleaseMode) {
        // return Uri.https(baseUrl, endpoint, params);
      }
      return Uri.http(baseUrl, endpoint, params);
    }

    return ApplicationBaseRequest._(
      baseUrl: baseUrl,
      endpoint: endpoint,
      method: method,
      data: data,
      token: token,
      getUri: _getUri,
    );
  }

  factory ApplicationBaseRequest.get(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'get',
        data: params,
        token: token,
      );

  factory ApplicationBaseRequest.delete(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'delete',
        data: params,
        token: token,
      );

  factory ApplicationBaseRequest.post(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> payload, {
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'post',
        data: payload,
        token: token,
      );

  factory ApplicationBaseRequest.patch(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> payload, {
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: "put",
        data: payload,
        token: token,
      );

  Future<Response> request() async {
    late http.Response response;
    try {
      if (method.toLowerCase() == "get") {
        final Map<String, String?> params = data != null
            ? data!.map(
                (key, value) => MapEntry(
                  key,
                  value?.toString(),
                ),
              )
            : {};
        final Uri _requestUrl = getUri(baseUrl, endpoint, params);
        response = await http.get(
          _requestUrl,
          headers: _getHeaders(),
        );
      }

      // if (method.toLowerCase() == "delete") {
      //   final Map<String, String?> params = data != null
      //       ? data!.map(
      //           (key, value) => MapEntry(
      //             key,
      //             value?.toString(),
      //           ),
      //         )
      //       : {};
      //   final Uri _requestUrl = getUri(baseUrl, endpoint, params);
      //   response = await http.delete(
      //     _requestUrl,
      //     headers: _getHeaders(),
      //   );
      // }

      if (method.toLowerCase() == "delete") {
        final Uri _requestUrl = getUri(baseUrl, endpoint);
        var req = http.MultipartRequest(
          method.toUpperCase(),
          _requestUrl,
        );
        data!.forEach((key, value) async {
          if (value is String) {
            req.fields[key] = value;
          }
          if (value is double || value is int) {
            req.fields[key] = value.toString();
          }
          // if (value is CustomFile) {
          //   req.files.add(await http.MultipartFile.fromPath(
          //     key,
          //     value.path,
          //   ));
          // }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send());
      }
      if (method.toLowerCase() == "post") {
        final Uri _requestUrl = getUri(baseUrl, endpoint);
        // response =  await http.post(_requestUrl, headers: _getHeaders(), body: data);
        var req = http.MultipartRequest(
          method.toUpperCase(),
          _requestUrl,
        );
        data!.forEach((key, value) async {
          if (value is String) {
            req.fields[key] = value;
          }
          if (value is double || value is int) {
            req.fields[key] = value.toString();
          }
          if (value is List) {
            int i = 0;
            // for (var ele in value) {
            //    = jsonEncode(ele);
            //   // i++;
            // }
            // req.fields["$key"]
            req.fields[key] = jsonEncode(value);
          }

          // if (value is CustomFile) {
          //   req.files.add(await http.MultipartFile.fromPath(
          //     key,
          //     value.path,
          //   ));
          // }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send());
      }

      if (method.toLowerCase() == "put") {
        final Uri _requestUrl = getUri(baseUrl, endpoint);
        var req = http.MultipartRequest(
          method.toUpperCase(),
          _requestUrl,
        );
        data!.forEach((key, value) async {
          if (value is String) {
            req.fields[key] = value;
          }
          if (value is double || value is int) {
            req.fields[key] = value.toString();
          }
          // if (value is CustomFile) {
          //   req.files.add(await http.MultipartFile.fromPath(
          //     key,
          //     value.path,
          //   ));
          // }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send());
      }
    } catch (e) {
      print(e);
      response = http.Response("{message:'Unknown Error'}", 404);
    }
    var _response;
    try {
      if (response.statusCode ~/ 100 == 2) {
        _response = jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        _response = jsonDecode(response.body);
      } else if (response.statusCode == 502) {
        _response = jsonDecode("{message:'Proccess Failed'}");
      } else {
        return Response(
            status: response.statusCode,
            data: jsonDecode(response.body) as Map<String, dynamic>,
            message: response.reasonPhrase,
            body: response.body);
      }
    } catch (e) {
      _response = {
        "error": "Decoding Error",
        "response": response,
      };
      return Response(
          status: response.statusCode,
          data: _response,
          message: response.reasonPhrase,
          body: response.body);
    }
    return Response(
        status: response.statusCode,
        data: _response,
        message: response.reasonPhrase,
        body: response.body);
  }

  Map<String, String> _getHeaders() {
    return <String, String>{
      'access-control-allow-origin': '*',
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
  }
}
