import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:test_game/game/data/models/game/position.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/ui/game/character.dart';

class GameCharacterModel extends Equatable {
  final CharacterType character;
  final PositionModel currentPosition;
  final PositionModel oldPosition;

  const GameCharacterModel({required this.character, required this.currentPosition, required this.oldPosition});

  factory GameCharacterModel.fromJson(Map<String, dynamic> json){
    return GameCharacterModel(character: getCharacter(json["character"]), currentPosition: PositionModel.fromJson(json["current_position"]), oldPosition: PositionModel.fromJson(json["new_position"]));
  }

  bool get isEmpty => this == GameCharacterModel.empty();
  bool get isNotEmpty => this != GameCharacterModel.empty();

  factory GameCharacterModel.empty(){
    return GameCharacterModel(character: CharacterType.hole, currentPosition: PositionModel.empty(), oldPosition: PositionModel.empty());
  }

  static CharacterType getCharacter(String name){
    for(CharacterType character in CharacterType.values){
      if(character.name == name){
        return character;
      }
    }
    return CharacterType.hole;
  }

  static CharacterType searchCharacter(List<GameCharacterModel> gameBoards,{int row = 0, int col = 0, CharacterType defaultCharacter = CharacterType.space}){
    for(GameCharacterModel gameCharacterModel in gameBoards) {
      if (isMatch(gameCharacterModel,PositionModel(row: row, col: col))) {
        return gameCharacterModel.character;
      }
    }
    return defaultCharacter;
  }

  static GameCharacterModel getBoardCharacter(List<GameCharacterModel> gameBoards,{int row = 0, int col = 0}){
    for(GameCharacterModel gameCharacterModel in gameBoards) {
      if (isMatch(gameCharacterModel,PositionModel(row: row, col: col))) {
        return gameCharacterModel;
      }
    }
    return GameCharacterModel.empty();
  }

  static bool isMatch(GameCharacterModel character, PositionModel position){
    return character.currentPosition.col == position.col && character.currentPosition.row == position.row;
  }

  GameCharacterModel copyWith({ CharacterType? character,PositionModel? currentPosition, PositionModel? oldPosition}){
    return GameCharacterModel(character: character ?? this.character,currentPosition: currentPosition ?? this.currentPosition, oldPosition: oldPosition ?? this.oldPosition);
  }

  static List<GameCharacterModel> switchCharacterPosition(List<GameCharacterModel> boards, {required PositionModel first, required PositionModel second}){
    List<GameCharacterModel> newGames = [];
    for(GameCharacterModel board in boards){
      if (isMatch(board,first)) {
        newGames.add(board.copyWith(character: GameCharacterModel.searchCharacter(boards,row: second.row, col: second.col)));
      }else if(isMatch(board,second)){
        newGames.add(board.copyWith(character: GameCharacterModel.searchCharacter(boards,row: first.row, col: first.col)));
      }else{
        newGames.add(board);
      }
    }
    return newGames;
  }

  static List<GameCharacterModel> changeCharacterType(List<GameCharacterModel> boards, {required PositionModel first, required CharacterType character}){
    List<GameCharacterModel> newGames = [];
    for(GameCharacterModel board in boards){
      if (isMatch(board,first)) {
        newGames.add(board.copyWith(character: character));
      }else{
        newGames.add(board);
      }
    }
    return newGames;
  }

  static List<GameCharacterModel> getList(json) {
    List<GameCharacterModel> lists = [];
    try {
      if(json.runtimeType.toString() == "String"){
        json = jsonDecode(json.toString()) as List;
      }
      for (dynamic js in json) {
        lists.add(GameCharacterModel.fromJson(js));
      }
    } catch (e) {
      print("HEMEDI CHECK $e");
      lists = [];
    }
    return lists;
  }

  static dynamic getMap(List<GameCharacterModel> rewards){
    List<dynamic> json = [];
    for(GameCharacterModel gameCharacterModel in rewards){
      json.add(gameCharacterModel.toMap());
    }
    return jsonEncode(json);
  }

  Map<String, dynamic> toMap() {
    return {
      "character": character.name,
      "current_position": currentPosition.toMap(),
      "new_position": oldPosition.toMap(),
    };
  }

  @override
  List<Object?> get props => [character, currentPosition.toMap(), oldPosition.toMap()];}