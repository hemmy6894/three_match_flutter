import 'package:test_game/common/helpers/email_validation.dart';
import 'package:test_game/common/helpers/password_validation.dart';

class Validation {
  static String? validate(String type, value) {
    if (type == "email") {
      return EmailValidation.validate(value) ? EmailValidation.message() : null;
    }
    if (type == "password") {
      return PasswordValidation.validate(value)
          ? PasswordValidation.message()
          : null;
    }
    return null;
  }

  static String? getErrorTextFromMapError(map, key) {
    try {
      Map<String, dynamic> maping = map as Map<String, dynamic>;
      if (maping.containsKey(key)) {
        var res = maping[key];
        if(res.runtimeType.toString() == "List<dynamic>"){
          return res[0];
        }
        return res;
      }
      if (maping.containsKey("message")) {
        Map<String, dynamic> messageMap =
        maping["message"] as Map<String, dynamic>;
        if (messageMap.containsKey(key)) {
          return messageMap[key];
        }
      }
    } catch (e) {
      print(key);
      print(e);
      return null;
    }
    return null;
  }

  static String getUrlFromUrls(map, key) {
    String v = "";
    // "https://media.oscarmini.com/wp-content/uploads/2014/08/05044727/michaeljackson_coverart.jpg";
    String defaultUrl = v;
    try {
      Map<String, dynamic> maping = map as Map<String, dynamic>;
      if (maping.containsKey(key)) {
        v = maping[key];
      }
      if (maping.containsKey("message")) {
        Map<String, dynamic> messageMap =
        maping["message"] as Map<String, dynamic>;
        if (messageMap.containsKey(key)) {
          v = messageMap[key];
        }
      }
    } catch (e) {
      v = v;
    }
    if (v == null && v == "") {
      v = defaultUrl;
    }
    return v;
  }
}
