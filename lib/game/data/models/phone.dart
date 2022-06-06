import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';

class PhoneModel extends Equatable{
  final String id;
  final String phone;
  final String displayName;

  const PhoneModel({ required this.id, required this.phone, required this.displayName});

  PhoneModel copyWith({ String? id,String? phone, String? displayName}){
    return PhoneModel(id: id ?? this.id,phone: phone ?? this.phone, displayName: displayName ?? this.displayName);
  }

  factory PhoneModel.fromJson(Map<String,dynamic> json){
    return PhoneModel(id: json["id"]??"",phone: json["phone"]??"", displayName: (json["displayName"]??""));
  }

  factory PhoneModel.empty(){
    return const PhoneModel(id: "",phone: "", displayName: "");
  }

  static List<PhoneModel>  getList(json)  {
    List<PhoneModel> phones = [];
    try{
      for(var js in json){
        ContactsService.getContactsForPhone(js["phone"],withThumbnails: false,photoHighResolution: false).then((contacts) {
          for(Contact contact in contacts){
            js["displayName"] = contact.displayName ?? js["displayName"];
          }
          phones.add(PhoneModel.fromJson(js));
        });
      }
    }catch(e){
      phones = [];
    }
    return phones;
  }
  @override
  List<Object?> get props => [id,phone,displayName];
}