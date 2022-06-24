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

class GameClickBoosterEvent extends GameEvent{
  final CharacterType booster;
  final int amount;
  GameClickBoosterEvent({required this.booster,required this.amount});

  boosterClicked(Emitter<GameState> emit, GameState state, GameClickBoosterEvent event){
    List<Map<CharacterType,int>> boosters = [];
    for(Map<CharacterType,int> start in state.startWith){
      if(start.entries.first.key != event.booster) {
        boosters.add(start);
      }else{
        boosters.add({event.booster : (start.entries.first.value+event.amount)});
      }
    }
    List<CharacterType> all = [];
    for(Map<CharacterType,int> start in state.startWith){
      all.add(start.entries.first.key);
    }
    if(!all.contains(event.booster)){
      boosters.add({event.booster : event.amount});
    }
    emit(state.copyWith(startWith: boosters));
  }
}
class GameClearBoosterClickedEvent extends GameEvent {
  GameClearBoosterClickedEvent();
  boosterClear(Emitter<GameState> emit, GameState state){
    emit(state.copyWith(startWith: []));
  }
}

class GameIsCapturedEvent extends GameEvent{ GameIsCapturedEvent(); }
class GameClearHelperEvent extends GameEvent{}
class GameCheckIfHasNextMoveEvent extends GameEvent{
  checkHasNextMove(Emitter<GameState> emit, GameState state){
    emit(state.copyWith(gameBoards: shuffle(state)));
  }

  shuffle(GameState state){
    Map<int,Map<int,CharacterType>> boards = {};
    List<CharacterType> characters = [];
    bool refresh = false;
    for(int i = state.row; i > 0 ; i--){
      Map<int,CharacterType> row = state.gameBoards[i] ?? {};
      for(int j = state.col; j > 0 ; j--){
        characters.add(row[j]??CharacterType.hole);
      }
    }

    bool checkIfHasNextMatchCharacter = false;
    for(int i = state.row; i > 0 ; i--){
      for(int j = state.col; j > 0 ; j--){
        checkIfHasNextMatchCharacter = hasNextMatchCharacter(state.gameBoards,i,j);
        print("$i $j $checkIfHasNextMatchCharacter");
      }
    }

    if(!checkIfHasNextMatchCharacter){
      // refresh = true;
    }

    for(CharacterType character in characters){
      if(BreakCharacter.isBombCharacter(character)){
        refresh = false;
      }
    }
    if(refresh) {
      var rng = Random();
      for (int i = state.row; i > 0; i--) {
        Map<int, CharacterType> row = {};
        for (int j = state.col; j > 0; j--) {
          Map<CharacterType,int> character = getUniqueRandomCharacterIndex(boards, i, j, characters);
          row = {...row, j: character.entries.first.key};
          characters.removeAt(character.entries.first.value);
        }
        boards = {...boards, i: row};
      }
      return boards;
    }else{
      return state.gameBoards;
    }
  }

  hasNextMatchCharacter(gameBoards,int row, int col){
    bool match = checkRowAndCol(gameBoards, row+1, col) || checkRowAndCol(gameBoards, row-1, col) || checkRowAndCol(gameBoards, row, col+1) || checkRowAndCol(gameBoards, row, col-1);
    return match;
  }

  checkRowAndCol(gameBoards,row,col){
    bool match = true;
    CharacterType thisCharacter = getBoardCharacter(gameBoards, row: row, col: col);
    for(int i = row; i >= row-2; i--){
      match = match && thisCharacter == getBoardCharacter(gameBoards, row: i, col: col);
    }
    bool match2 = true;
    for(int i = row; i <= row+2; i++){
      match2 = match2 && thisCharacter == getBoardCharacter(gameBoards, row: i, col: col);
    }
    bool match3 = true;
    for(int i = col; i >= col-2; i--){
      match3 = match3 && thisCharacter == getBoardCharacter(gameBoards, row: row, col: i);
    }
    bool match4 = true;
    for(int i = col; i <= col+2; i++){
      match4 = match4 && thisCharacter == getBoardCharacter(gameBoards, row: row, col: i);
    }
    return match || match2 || match3 || match4;
  }

  getUniqueRandomCharacterIndex(gameBoards, row, col, List<CharacterType> characters) {
    CharacterType twoRowBeforeCharacter = getBoardCharacter(gameBoards, row: (row - 2), col: col);
    CharacterType twoColBeforeCharacter = getBoardCharacter(gameBoards, row: row, col: (col - 2));
    return randomCharacterChecker(gameBoards,row,col,characters,twoColBeforeCharacter: twoColBeforeCharacter,twoRowBeforeCharacter: twoRowBeforeCharacter);
  }

  randomCharacterChecker(gameBoards,row,col,characters,{CharacterType? twoRowBeforeCharacter,CharacterType? twoColBeforeCharacter}){
    Map<CharacterType,int> characterChecker = {};
    var rng = Random();
    int position = rng.nextInt(characters.length);
    CharacterType randCharacter = characters[position];
    if (randCharacter == twoColBeforeCharacter || randCharacter == twoRowBeforeCharacter) {
      characterChecker = randomCharacterChecker(gameBoards,row,col,characters,twoColBeforeCharacter: twoColBeforeCharacter,twoRowBeforeCharacter: twoRowBeforeCharacter);
      randCharacter = characterChecker.entries.first.key;
      position = characterChecker.entries.first.value;
    }
    return {randCharacter : position};
  }
}