import 'package:equatable/equatable.dart';
import 'gender.dart';

class GenderList extends Equatable {
  final List<GenderModel> genders;

  const GenderList({required this.genders,});

  factory GenderList.empty() {
    return  const GenderList(genders: []);
  }

  GenderList copyWith({ List<GenderModel>? genders,}){
    return GenderList(genders: genders ?? this.genders,);
  }

  factory GenderList.toJson(Map<String,dynamic>? json) {
    if(json == null){
      return GenderList.empty();
    }
    return GenderList(genders: GenderModel.getList(json["genders"]), );
  }

  Map<String,dynamic> toMap(){
    return {
      "genders" : genders,
    };
  }

  @override
  List<Object?> get props => [genders];
}