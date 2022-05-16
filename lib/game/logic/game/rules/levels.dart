part of '../game_bloc.dart';

class GameLevels{
  static startGame(Emitter<GameState> emit, GameState state, int levelName) {
    Map<String,dynamic> level1 = Assets.levels[levelName];
    int col = level1["col"];
    int row = level1["row"];
    List<dynamic> boards = level1["board"];

    final Map<int, Map<int, CharacterType>> gameBoards = {};
    final Map<int, Map<int, bool>> carpets = level1["carpet"] ?? {};
    var target = level1["targets"];
    List<Map<CharacterType, int>> targets = [];
    if(target.isNotEmpty){
      targets = target;
    }
    final int moves = level1["moves"];
    for (int i = 1; i <= row; i++) {
      Map<int, CharacterType> gameBoard = {};
      for (int j = 1; j <= col; j++) {
        CharacterType characterType = boards[i-1][j-1]??CharacterType.hole;
        CharacterType randCharacter = CharacterGenerator.getUniqueRandomCharacter(gameBoards, i, j);
        if(BreakCharacter.noneBreakableCharacter(characterType)){
          gameBoard.addAll({j: characterType});
          gameBoards.addAll({i: gameBoard});
        }else{
          gameBoard.addAll({j: randCharacter});
          gameBoards.addAll({i: gameBoard});
        }
      }
    }
    emit(state.copyWith(gameBoards: gameBoards, col: col, row: row, carpets: carpets, targets: targets, moves: moves ));
  }
}