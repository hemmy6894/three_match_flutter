part of 'game_bloc.dart';

abstract class GameEvent {}

class GameStartEvent extends GameEvent {
  final int levelName;
  final String? assignId;

  GameStartEvent({required this.levelName, this.assignId});
}

class GameClickCharacterEvent extends GameEvent {
  final int row;
  final int col;

  GameClickCharacterEvent({required this.row, required this.col});
}

class GameMoveCharacterEvent extends GameEvent {}

class GameClearCharacterEvent extends GameEvent {}

class GameMatchCharacterEvent extends GameEvent {}

class GameBreakMatchEvent extends GameEvent {}

class GameDropCharacterEvent extends GameEvent {}

class GameMatchCharacterStateEvent extends GameEvent {
  final bool match;

  GameMatchCharacterStateEvent({required this.match});
}

class GameCatchHelperEvent extends GameEvent {
  final CharacterType helper;
  final int amount;

  GameCatchHelperEvent({required this.helper, required this.amount});
}

class GameClickBoosterEvent extends GameEvent {
  final CharacterType booster;
  final int amount;

  GameClickBoosterEvent({required this.booster, required this.amount});

  boosterClicked(Emitter<GameState> emit, GameState state, GameClickBoosterEvent event) {
    List<Map<CharacterType, int>> boosters = [];
    for (Map<CharacterType, int> start in state.startWith) {
      if (start.entries.first.key != event.booster) {
        boosters.add(start);
      } else {
        if(start.entries.first.value < 1) {
          boosters.add({event.booster: (start.entries.first.value + event.amount)});
        }else{
          boosters.add({event.booster: 0});
        }
      }
    }
    List<CharacterType> all = [];
    for (Map<CharacterType, int> start in state.startWith) {
      all.add(start.entries.first.key);
    }
    if (!all.contains(event.booster)) {
      boosters.add({event.booster: event.amount});
    }
    emit(state.copyWith(startWith: boosters));
  }
}

class GameClearBoosterClickedEvent extends GameEvent {
  GameClearBoosterClickedEvent();

  boosterClear(Emitter<GameState> emit, GameState state) {
    emit(state.copyWith(startWith: []));
  }
}

class GameIsCapturedEvent extends GameEvent {
  GameIsCapturedEvent();
}

class GameClearHelperEvent extends GameEvent {}

class GameCheckIfHasNextMoveEvent extends GameEvent {
  checkHasNextMove(Emitter<GameState> emit, GameState state) async{
     await Future.delayed(const Duration(seconds: 6));
     Map<int, Map<int, CharacterType>>? boards = await shuffle(emit, state);
     if(boards != null) {
       emit(state.copyWith(gameBoards: boards));
     }
  }

  shuffle(Emitter<GameState> emit,GameState state) async{
    Map<int, Map<int, CharacterType>> boards = {};
    List<CharacterType> characters = [];
    bool refresh = false;
    for (int i = state.row; i > 0; i--) {
      Map<int, CharacterType> row = state.gameBoards[i] ?? {};
      for (int j = state.col; j > 0; j--) {
        characters.add(row[j] ?? CharacterType.hole);
      }
    }

    bool checkIfHasNextMatchCharacter = false;
    for (int i = state.row; i > 0; i--) {
      for (int j = state.col; j > 0; j--) {
        checkIfHasNextMatchCharacter = checkIfHasNextMatchCharacter || await getConnectedCharacterNotMoving(emit, state, row: i, col: j+1, rRow: i,rCol: j);
        checkIfHasNextMatchCharacter = checkIfHasNextMatchCharacter || await getConnectedCharacterNotMoving(emit, state, row: i, col: j-1, rRow: i,rCol: j);
        checkIfHasNextMatchCharacter = checkIfHasNextMatchCharacter || await getConnectedCharacterNotMoving(emit, state, row: i + 1, col: j, rRow: i,rCol: j);
        checkIfHasNextMatchCharacter = checkIfHasNextMatchCharacter || await getConnectedCharacterNotMoving(emit, state, row: i - 1, col: j, rRow: i,rCol: j);
      }
    }

    if (!checkIfHasNextMatchCharacter) {
      refresh = true;
    }

    for (CharacterType character in characters) {
      if (BreakCharacter.isBombCharacter(character)) {
        refresh = false;
      }
    }

    if (refresh) {
      for (int i = state.row; i > 0; i--) {
        Map<int, CharacterType> row = {};
        for (int j = state.col; j > 0; j--) {
          var rng = Random();
          int position = rng.nextInt(characters.length);
          CharacterType randCharacter = characters[position];
          row = {...row, j: randCharacter};
          characters.removeAt(position);
        }
        boards = {...boards, i: row};
      }
      return boards;
    } else {
      return null;
    }
  }

  getConnectedCharacterNotMoving(Emitter<GameState> emit, GameState state,{int row = 0, int col = 0,int rRow = 0, int rCol = 0}) async {
    List<PositionModel> game = [];
    Map<int, List<PositionModel>> result = {};
    Map<int, List<PositionModel>> bombing = {};
    int matchCount = 0;
    int total = 0;
    CharacterType type = getCharacter(state, row: rRow, col: rCol); // The real row character
    result = getConnectedCharacter(state, row, col, type, minus: 1);
    bombing = await BombMove.bombMoves(emit, state, row, col);
    if (result.isNotEmpty) {
      matchCount = result.entries.first.key;
      game = result.entries.first.value;
    }
    if (bombing.isNotEmpty) {
      matchCount += bombing.entries.first.key;
      if (bombing.entries.first.key > 1) {
        game = [...game, ...bombing.entries.first.value];
      }
    }
    total = matchCount;
    if(total < 1){
      return false;
    }else{
      return true;
    }
  }
}


class ClearBlastEvent  extends GameEvent{
  final PositionModel? superBombBlast;
  ClearBlastEvent({this.superBombBlast});
}
