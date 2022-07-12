import 'package:intl/intl.dart';

class ThreeMatchHelper {
  static String dateFormat(
      {required DateTime dateTime, String format = "yyyy-MM-dd"}) {
    return DateFormat(format).format(dateTime);
  }

  static String textCut({String text = "", int from = 0, int to = 400, String append = "", bool appending = true}){
    if(text.length <= to){
      return text;
    }
    return text.substring(from,to) + ( appending ? " ..." + append : "");
  }

  static DateTime convertDate(dynamic date){
    try {
      return DateTime.parse(date);
    }catch(e){
      return DateTime.now();
    }
  }

  static DateTime? convertDate2(dynamic date){
    try {
      return DateTime.parse(date);
    }catch(e){
      return null;
    }
  }
}