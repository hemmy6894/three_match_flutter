import 'package:contacts_service/contacts_service.dart';
import 'package:equatable/equatable.dart';

class PhoneModel extends Equatable{
  final String phone;
  final String displayName;

  const PhoneModel({ required this.phone, required this.displayName});

  PhoneModel copyWith({ String? phone, String? displayName}){
    return PhoneModel(phone: phone ?? this.phone, displayName: displayName ?? this.displayName);
  }

  factory PhoneModel.fromJson(Map<String,dynamic> json){
    return PhoneModel(phone: json["phone"], displayName: (json["displayName"]??""));
  }

  static List<PhoneModel>  getList(json)  {
    List<PhoneModel> phones = [];
    try{
      for(var js in json){
        ContactsService.getContactsForPhone(js["phone"],withThumbnails: false,photoHighResolution: false).then((contacts) {
          for(Contact contact in contacts){
            print(contact.displayName);
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
  List<Object?> get props => [phone,displayName];
}