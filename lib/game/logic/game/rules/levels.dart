part of '../game_bloc.dart';

class GameLevels{
  static startGameLevel1(Emitter<GameState> emit, GameState state) {
    Map<String,dynamic> level1 = Assets.level1;
    int col = level1["col"];
    int row = level1["row"];
    List<dynamic> boards = level1["board"];

    final Map<int, Map<int, CharacterType>> gameBoards = {};
    final Map<int, Map<int, bool>> carpets = {};
    for (int i = 1; i <= row; i++) {
      Map<int, CharacterType> gameBoard = {};
      Map<int, bool> carpet = {};
      for (int j = 1; j <= col; j++) {
        CharacterType characterType = boards[i-1][j-1]??CharacterType.hole;
        CharacterType randCharacter = CharacterGenerator.getUniqueRandomCharacter(gameBoards, i, j);
        if(characterType == CharacterType.carpet){
          carpet.addAll({j : true});
          carpets.addAll({i: carpet});
        }
        if(BreakCharacter.noneBreakableCharacter(characterType)){
          gameBoard.addAll({j: characterType});
          gameBoards.addAll({i: gameBoard});
        }else{
          gameBoard.addAll({j: randCharacter});
          gameBoards.addAll({i: gameBoard});
        }
      }
    }
    emit(state.copyWith(gameBoards: gameBoards, col: col, row: row, carpets: carpets));
  }
}