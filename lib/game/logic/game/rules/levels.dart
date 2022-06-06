part of '../game_bloc.dart';

class GameLevels {
  static startGame(Emitter<GameState> emit, GameState state, GameStartEvent event) {
    Map<String, dynamic> level1 = Assets.levels[event.levelName];
    int col = level1["col"];
    int row = level1["row"];

    Map<int, Map<int, CharacterType>> gameBoards = {};
    final Map<int, Map<int, bool>> carpets = level1["carpet"] ?? {};
    var target = level1["targets"];
    List<Map<CharacterType, int>> targets = [];
    if (target.isNotEmpty) {
      targets = target;
    }

    var reward = level1["rewards"];
    List<Map<CharacterType, int>> rewards = [];
    if (reward.isNotEmpty) {
      rewards = reward;
    }

    final int moves = level1["moves"];
    gameBoards = drawBoard(level: event.levelName);
    emit(
      state.copyWith(
        gameBoards: gameBoards,
        col: col,
        row: row,
        carpets: carpets,
        targets: targets,
        moves: moves,
        rewards: rewards,
        level: event.levelName,
        assignedId: event.assignId
      ),
    );
  }

  static Map<int, Map<int, CharacterType>> drawBoard(
      {required int level, bool restart = false}) {
    Map<String, dynamic> level1 = Assets.levels[level];
    List<dynamic> boards = level1["board"];
    int col = level1["col"];
    int row = level1["row"];
    final Map<int, Map<int, CharacterType>> gameBoards = {};
    if (restart) {
      for (int i = 1; i <= row; i++) {
        Map<int, CharacterType> gameBoard = {};
        for (int j = 1; j <= col; j++) {
          CharacterType characterType = CharacterType.hole;
          gameBoard.addAll({j: characterType});
          gameBoards.addAll({i: gameBoard});
        }
      }
      return gameBoards;
    }
    for (int i = 1; i <= row; i++) {
      Map<int, CharacterType> gameBoard = {};
      for (int j = 1; j <= col; j++) {
        CharacterType characterType =
            boards[i - 1][j - 1] ?? CharacterType.hole;
        CharacterType randCharacter =
            CharacterGenerator.getUniqueRandomCharacter(gameBoards, i, j);
        if (BreakCharacter.noneBreakableCharacter(characterType)) {
          gameBoard.addAll({j: characterType});
          gameBoards.addAll({i: gameBoard});
        } else {
          gameBoard.addAll({j: randCharacter});
          gameBoards.addAll({i: gameBoard});
        }
      }
    }
    return gameBoards;
  }
}
