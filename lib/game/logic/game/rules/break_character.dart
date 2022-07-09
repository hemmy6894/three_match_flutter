part of '../game_bloc.dart';

class BreakCharacter {
  static breakMatch(Emitter<GameState> emit, GameState state) {
    Map<int, Map<int, CharacterType>> boards = state.gameBoards;

    List<Map<CharacterType, int>> targets = state.targets;

    List<PositionModel> targetBreaking = [];
    for (PositionModel replace in state.toBreak) {
      int rowCount = replace.row;
      int colCount = replace.col;

      bool breaking = true;
      bool first = false;
      if (targetBreaking.isEmpty) {
        first = true;
        targetBreaking.add(replace);
      }
      for (PositionModel rep in targetBreaking) {
        if ((rep == replace) && !first) {
          breaking = false;
        }
      }
      if (breaking) {
        targetBreaking.add(replace);
        targets = reduceTarget(getBoardCharacter(boards, row: rowCount, col: colCount), targets);
      }
    }

    Map<int, Map<int, bool>> carpets = state.carpets;
    boards = replaceCharacterWith(emit, state, boards, state.planes, CharacterType.plane);
    boards = replaceCharacterWith(emit, state, boards, state.bulletVerticals, CharacterType.verticalBullet);
    boards = replaceCharacterWith(emit, state, boards, state.bulletHorizontals, CharacterType.horizontalBullet);
    boards = replaceCharacterWith(emit, state, boards, state.bombs, CharacterType.bomb);
    boards = replaceCharacterWith(emit, state, boards, state.superBombs, CharacterType.superBomb);
    List<PositionModel> remains = [];
    remains = removeIfMatchForBomb(state.planes, state.toBreak);
    remains = removeIfMatchForBomb(state.bombs, remains);
    remains = removeIfMatchForBomb(state.bulletVerticals, remains);
    remains = removeIfMatchForBomb(state.bulletHorizontals, remains);
    remains = removeIfMatchForBomb(state.superBombs, remains);
    boards = replaceCharacterWith(emit, state, boards, remains, CharacterType.hole);

    bool hasCarpet = false;
    for (PositionModel replace in remains) {
      int rowCount = replace.row;
      int colCount = replace.col;
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
      List<PositionModel> replaces,
      CharacterType character) {
    replaces = removeDublicate(replaces);
    Map<int, Map<int, CharacterType>> bds = boards;
    for (PositionModel replace in replaces) {
      int rowCount = replace.row;
      int colCount = replace.col;
      Map<int, CharacterType> row = bds[rowCount] ?? {};
      CharacterType spacial = getBoardCharacter(boards, row: rowCount, col: colCount);
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
      List<PositionModel> replaces,
      bool status) {
    Map<int, Map<int, bool>> bds = boards;
    for (PositionModel replace in replaces) {
      int rowCount = replace.row;
      int colCount = replace.col;
      Map<int, bool> row = bds[rowCount] ?? {};
      row = {...row, colCount: status};
      bds = {...bds, rowCount: row};
    }
    return bds;
  }

  static removeDublicate(List<PositionModel> dublicates){
    //REMOVE DUPLICATE
    List<PositionModel> freshRemains = [];
    bool match = true;
    for (PositionModel map in dublicates) {
      match = false;
      for (PositionModel fresh in freshRemains) {
        if (map == fresh) {
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
  static List<PositionModel> removeIfMatchForBomb(
      List<PositionModel> bombs, List<PositionModel> breaks) {
  breaks = removeDublicate(breaks);
  bombs = removeDublicate(bombs);
    List<PositionModel> remains = [];
    if (bombs.isNotEmpty) {
      bool exist = false;
      for (PositionModel brk in breaks) {
        exist = false;
        for (PositionModel bom in bombs) {
          if ((brk == bom)) {
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

  static List<CharacterType> characterInRewards() {
    List<CharacterType> chars = [
      CharacterType.bomb,
      CharacterType.superBomb,
      CharacterType.verticalBullet,
      CharacterType.horizontalBullet,
      CharacterType.plane,
      CharacterType.coin,
      CharacterType.hand,
      CharacterType.hummer,
    ];
    return chars;
  }
}
