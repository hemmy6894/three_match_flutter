import 'dart:convert';

import 'package:equatable/equatable.dart';

class PositionModel extends Equatable {
  final int row;
  final int col;

  const PositionModel({required this.row, required this.col});

  factory PositionModel.fromJson(Map<String, dynamic> json){
    return PositionModel(row: json["row"], col: json["col"]);
  }

  factory PositionModel.empty(){
    return const PositionModel(row: 0,col: 0);
  }

  bool get isEmpty => this == PositionModel.empty();
  PositionModel get clear => PositionModel.empty();
  bool get isNotEmpty => this != PositionModel.empty();

  static List<PositionModel> getList(json) {
    List<PositionModel> lists = [];
    try {
      for (dynamic js in json) {
        lists.add(PositionModel.fromJson(js));
      }
    } catch (e) {
      print("POSITION CHECK $e");
      lists = [];
    }
    return lists;
  }

  static dynamic getMap(List<PositionModel> rewards){
    List<dynamic> json = [];
    for(PositionModel positionModel in rewards){
      json.add(positionModel.toMap());
    }
    return jsonEncode(json);
  }

  Map<String, dynamic> toMap() {
    return {
      "row": row,
      "col": col,
    };
  }

  @override
  List<Object?> get props => [row, col];}