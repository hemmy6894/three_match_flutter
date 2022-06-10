part of '../game_bloc.dart';

class BreakCharacter {
  static breakMatch(Emitter<GameState> emit, GameState state) {
    Map<int, Map<int, CharacterType>> boards = state.gameBoards;

    List<Map<CharacterType, int>> targets = state.targets;

    List<Map<int, int>> targetBreaking = [];
    for (Map<int, int> replace in state.toBreak) {
      int rowCount = replace.entries.first.key;
      int colCount = replace.entries.first.value;

      bool breaking = true;
      bool first = false;
      if (targetBreaking.isEmpty) {
        first = true;
        targetBreaking.add(replace);
      }
      for (Map<int, int> rep in targetBreaking) {
        if (mapEquals(rep, replace) && !first) {
          breaking = false;
        }
      }
      if (breaking) {
        targetBreaking.add(replace);
        targets = reduceTarget(
            getBoardCharacter(boards, row: rowCount, col: colCount), targets);
      }
    }

    Map<int, Map<int, bool>> carpets = state.carpets;
    boards = replaceCharacterWith(emit, state, boards, state.planes, CharacterType.plane);
    boards = replaceCharacterWith(emit, state, boards, state.bulletVerticals, CharacterType.verticalBullet);
    boards = replaceCharacterWith(emit, state, boards, state.bulletHorizontals, CharacterType.horizontalBullet);
    boards = replaceCharacterWith(emit, state, boards, state.bombs, CharacterType.bomb);
    boards = replaceCharacterWith(emit, state, boards, state.superBombs, CharacterType.superBomb);
    List<Map<int, int>> remains = [];
    remains = removeIfMatchForBomb(state.planes, state.toBreak);
    remains = removeIfMatchForBomb(state.bombs, remains);
    remains = removeIfMatchForBomb(state.bulletVerticals, remains);
    remains = removeIfMatchForBomb(state.bulletHorizontals, remains);
    remains = removeIfMatchForBomb(state.superBombs, remains);
    boards = replaceCharacterWith(emit, state, boards, remains, CharacterType.hole);

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
        bulletVerticals: [],
        bulletHorizontals: [],
        targets: targets,
        bombs: [],
        superBombs: []));
  }

  static reduceTarget(
      CharacterType characterType, List<Map<CharacterType, int>> targets) {
    List<Map<CharacterType, int>> trgs = [];
    for (Map<CharacterType, int> target in targets) {
      if (target.entries.first.key == characterType) {
        int newTargetNum = (target.entries.first.value - 1);
        trgs.add({characterType: newTargetNum > 0 ? newTargetNum : 0});
      } else {
        trgs.add(target);
      }
    }
    return trgs;
  }

  static Map<int, Map<int, CharacterType>> replaceCharacterWith(
      Emitter<GameState> emit,
      GameState state,
      Map<int, Map<int, CharacterType>> boards,
      List<Map<int, int>> replaces,
      CharacterType character) {
    replaces = removeDublicate(replaces);
    Map<int, Map<int, CharacterType>> bds = boards;
    for (Map<int, int> replace in replaces) {
      int rowCount = replace.entries.first.key;
      int colCount = replace.entries.first.value;
      Map<int, CharacterType> row = bds[rowCount] ?? {};
      CharacterType spacial =
          getBoardCharacter(boards, row: rowCount, col: colCount);
      bool isNone = noneBreakableCharacter(spacial);
      if (isNone && (CharacterType.hole == character)) {
        if (staticCharacterNeverChange(spacial)) {
          row[colCount] = spacial;
        } else if (spacial == CharacterType.boxThree) {
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
      row = {...row, colCount: status};
      bds = {...bds, rowCount: row};
    }
    return bds;
  }

  static removeDublicate(List<Map<int, int>> dublicates){
    //REMOVE DUPLICATE
    List<Map<int, int>> freshRemains = [];
    bool match = true;
    for (Map<int, int> map in dublicates) {
      match = false;
      for (Map<int, int> fresh in freshRemains) {
        if (mapEquals(map, fresh)) {
          match = true;
        }
      }
      if (!match) {
        freshRemains.add(map);
      }
    }
    return freshRemains;
    //END REMOVE
  }
  static List<Map<int, int>> removeIfMatchForBomb(
      List<Map<int, int>> bombs, List<Map<int, int>> breaks) {
  breaks = removeDublicate(breaks);
  bombs = removeDublicate(bombs);
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
      CharacterType.space,
    ];
    bool isChar = false;
    for (CharacterType char in chars) {
      if (char == characterType) {
        isChar = true;
      }
    }
    return isChar;
  }

  static bool spaceCharacter(CharacterType characterType) {
    List<CharacterType> chars = [
      CharacterType.space,
    ];
    bool isChar = false;
    for (CharacterType char in chars) {
      if (char == characterType) {
        isChar = true;
      }
    }
    return isChar;
  }

  static bool notMovingCharacter(CharacterType characterType) {
    List<CharacterType> chars = [
      CharacterType.space,
      CharacterType.boxThree,
    ];
    bool isChar = false;
    for (CharacterType char in chars) {
      if (char == characterType) {
        isChar = true;
      }
    }
    return isChar;
  }

  static bool staticCharacterNeverChange(CharacterType characterType) {
    List<CharacterType> chars = [
      CharacterType.space,
    ];
    bool isChar = false;
    for (CharacterType char in chars) {
      if (char == characterType) {
        isChar = true;
      }
    }
    return isChar;
  }

  static bool isBombCharacter(CharacterType characterType) {
    List<CharacterType> chars = [
      CharacterType.bomb,
      CharacterType.superBomb,
      CharacterType.verticalBullet,
      CharacterType.horizontalBullet,
      CharacterType.plane,
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
