import 'package:test_game/game/data/models/country_list.dart';

class CountryListResponse {
  final bool success;
  final CountryList data;
  final String message;

  CountryListResponse(
      {required this.message, required this.success, required this.data});

  factory CountryListResponse.fromMap(
    Map<String, dynamic> json, {
    String response = "data",
  }) =>
      CountryListResponse(
        success: json["status"] ?? false,
        message: json["sms"] ?? "",
        data: CountryList.toJson(json[response]),
      );
}
