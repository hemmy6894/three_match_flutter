import 'package:equatable/equatable.dart';
import 'country.dart';

class CountryList extends Equatable {
  final List<CountryModel> countries;

  const CountryList({required this.countries,});

  factory CountryList.empty() {
    return  const CountryList(countries: []);
  }

  CountryList copyWith({ List<CountryModel>? countries,}){
    return CountryList(countries: countries ?? this.countries,);
  }

  factory CountryList.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return CountryList.empty();
    }
    return CountryList(countries: CountryModel.getList(json["countries"]), );
  }

  Map<String,dynamic> toMap(){
    return {
      "countries" : countries,
    };
  }

  @override
  List<Object?> get props => [countries];
}