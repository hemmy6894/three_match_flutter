import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:test_game/game/ui/game/character.dart';

class RewardModel extends Equatable {
  final CharacterType character;
  final int amount;

  const RewardModel({required this.character, required this.amount});

  factory RewardModel.fromJson(Map<String, dynamic> json){
    return RewardModel(character: getCharacter(json["character"]), amount: json["amount"]);
  }

  static CharacterType getCharacter(String name){
    for(CharacterType character in CharacterType.values){
      if(character.name == name){
        return character;
      }
    }
    return CharacterType.hole;
  }

  static List<RewardModel> getList(json) {
    List<RewardModel> lists = [];
    try {
      if(json.runtimeType.toString() == "String"){
        print(json);
        json = jsonDecode(json.toString()) as List;
      }
      for (dynamic js in json) {
        lists.add(RewardModel.fromJson(js));
      }
    } catch (e) {
      print("HEMEDI CHECK $e");
      lists = [];
    }
    return lists;
  }

  static dynamic getMap(List<RewardModel> rewards){
    List<dynamic> json = [];
    for(RewardModel rewardModel in rewards){
      json.add(rewardModel.toMap());
    }
    return jsonEncode(json);
  }

  Map<String, dynamic> toMap() {
    return {
      "character": character.name,
      "amount": amount,
    };
  }

@override
List<Object?> get props => [character, amount];}