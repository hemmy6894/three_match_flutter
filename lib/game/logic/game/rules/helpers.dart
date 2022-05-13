part of '../game_bloc.dart';
class Helpers {
  static catchHelper(Emitter<GameState> emit, GameState state, CharacterType helper){
    emit(state.copyWith(selectedHelper: helper));
  }

  static isCaptured(Emitter<GameState> emit, GameState state){
    if(state.selectedHelper == null){
      return null;
    }
    if(state.selectedHelper == CharacterType.hummer){
      Helpers.isHummerCaptured(emit, state);
    }
    if(state.selectedHelper == CharacterType.hand){
    }
  }

  static isHandCaptured(GameState state){
    return state.selectedHelper == CharacterType.hand;
  }

  static isHummerCaptured(Emitter<GameState> emit, GameState state){
    Map<int, Map<int, CharacterType>> boards = state.gameBoards;
    if(state.firstClicked.isNotEmpty && state.secondClicked.isEmpty && state.selectedHelper == CharacterType.hummer){
      int row = state.firstClicked.entries.first.key;
      int col = state.firstClicked.entries.first.value;
      Map<int, CharacterType> myRow = boards[row] ?? {};
      myRow = {...myRow, col : CharacterType.hole};
      boards = { ...boards, row: myRow};

      emit(state.copyWith(
        gameBoards: boards,
        dropDown: true,
        selectedHelper: CharacterType.hole,
        firstClicked: {},
      ));
    }
  }
}