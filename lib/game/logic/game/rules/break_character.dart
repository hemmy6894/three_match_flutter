part of '../game_bloc.dart';

class BreakCharacter {
  static breakMatch(Emitter<GameState> emit, GameState state) {
    Map<int, Map<int, CharacterType>> boards = state.gameBoards;
    Map<int, Map<int, bool>> carpets = state.carpets;
    boards = replaceCharacterWith(boards, state.planes, CharacterType.plane);
    boards = replaceCharacterWith(
        boards, state.bullets, SpecialCharacter.getBullet());
    boards = replaceCharacterWith(boards, state.bombs, CharacterType.bomb);
    boards =
        replaceCharacterWith(boards, state.superBombs, CharacterType.superBomb);

    List<Map<int, int>> remains = [];
    remains = removeIfMatchForBomb(state.planes, state.toBreak);
    remains = removeIfMatchForBomb(state.bombs, remains);
    remains = removeIfMatchForBomb(state.bullets, remains);
    remains = removeIfMatchForBomb(state.superBombs, remains);

    boards = replaceCharacterWith(boards, remains, CharacterType.hole);

    bool hasCarpet = false;
    for (Map<int, int> replace in remains) {
      int rowCount = replace.entries.first.key;
      int colCount = replace.entries.first.value;
      if (state.hasCarpet(row: rowCount, col: colCount)) {
        hasCarpet = true;
      }
    }
    if (hasCarpet) {
      carpets = addCarpetAtCharacter(carpets, remains, true);
    }

    emit(state.copyWith(
        gameBoards: boards,
        carpets: carpets,
        dropDown: true,
        toBreak: [],
        planes: [],
        bullets: [],
        bombs: [],
        superBombs: []));
  }

  static Map<int, Map<int, CharacterType>> replaceCharacterWith(
      Map<int, Map<int, CharacterType>> boards,
      List<Map<int, int>> replaces,
      CharacterType character) {
    Map<int, Map<int, CharacterType>> bds = boards;
    for (Map<int, int> replace in replaces) {
      int rowCount = replace.entries.first.key;
      int colCount = replace.entries.first.value;
      Map<int, CharacterType> row = bds[rowCount] ?? {};
      CharacterType spacial =
          getBoardCharacter(boards, row: rowCount, col: colCount);
      bool isNone = noneBreakableCharacter(spacial);
      if (isNone && (CharacterType.hole == character)) {
        if (spacial == CharacterType.boxThree) {
          row[colCount] = CharacterType.boxTwo;
        } else if (spacial == CharacterType.boxTwo) {
          row[colCount] = CharacterType.boxOne;
        } else if (spacial == CharacterType.diamondThree) {
          row[colCount] = CharacterType.diamondTwo;
        } else if (spacial == CharacterType.diamondTwo) {
          row[colCount] = CharacterType.diamondOne;
        } else {
          row[colCount] = character;
        }
      } else {
        row[colCount] = character;
      }
      bds[rowCount] = row;
    }
    return bds;
  }

  static Map<int, Map<int, bool>> addCarpetAtCharacter(
      Map<int, Map<int, bool>> boards,
      List<Map<int, int>> replaces,
      bool status) {
    Map<int, Map<int, bool>> bds = boards;
    for (Map<int, int> replace in replaces) {
      int rowCount = replace.entries.first.key;
      int colCount = replace.entries.first.value;
      Map<int, bool> row = bds[rowCount] ?? {};
      row[colCount] = status;
      bds[rowCount] = row;
    }
    return bds;
  }

  static List<Map<int, int>> removeIfMatchForBomb(
      List<Map<int, int>> bombs, List<Map<int, int>> breaks) {
    List<Map<int, int>> remains = [];
    if (bombs.isNotEmpty) {
      bool exist = false;
      for (Map<int, int> brk in breaks) {
        exist = false;
        for (Map<int, int> bom in bombs) {
          if (mapEquals(brk, bom)) {
            exist = true;
          }
        }
        if (!exist) {
          remains.add(brk);
        }
      }
    } else {
      remains = breaks;
    }
    return remains;
  }

  static bool noneBreakableCharacter(CharacterType characterType) {
    List<CharacterType> chars = [
      CharacterType.boxOne,
      CharacterType.boxTwo,
      CharacterType.boxThree,
      CharacterType.diamondOne,
      CharacterType.diamondTwo,
      CharacterType.diamondThree,
    ];
    bool isChar = false;
    for (CharacterType char in chars) {
      if (char == characterType) {
        isChar = true;
      }
    }
    return isChar;
  }
}
