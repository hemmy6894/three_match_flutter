part of 'game_bloc.dart';
abstract class GameEvent {}

class GameStartEvent extends GameEvent{
  final int levelName;
  final String? assignId;
  GameStartEvent({required this.levelName, this.assignId});
}

class GameClickCharacterEvent extends GameEvent{
  final int row;
  final int col;
  GameClickCharacterEvent({required this.row, required this.col});
}

class GameMoveCharacterEvent extends GameEvent{}
class GameClearCharacterEvent extends GameEvent{}

class GameMatchCharacterEvent extends GameEvent{}
class GameBreakMatchEvent extends GameEvent{}
class GameDropCharacterEvent extends GameEvent{}
class GameMatchCharacterStateEvent extends GameEvent{
  final bool match;
  GameMatchCharacterStateEvent({required this.match});
}

class GameCatchHelperEvent extends GameEvent{
  final CharacterType helper;
  final int amount;
  GameCatchHelperEvent({required this.helper,required this.amount});
}

class GameIsCapturedEvent extends GameEvent{
  GameIsCapturedEvent();
}

class GameClearHelperEvent extends GameEvent{}