part of '../game_bloc.dart';

class BombMove {
  static Future<Map<int, List<Map<int, int>>>> bombMoves(
      Emitter<GameState> emit, GameState state, int row, int col,
      {bool recheck = false}) async {
    List<Map<int, int>> firstMoves = [];
    int matchCount = 0;
    CharacterType block = getCharacter(state, row: row, col: col);
    if (BreakCharacter.staticCharacterNeverChange(block)) {
      return {0: []};
    }
    if (block == CharacterType.plane) {
      List<dynamic> planeMove = planeMoves(row, col, state);
      if (planeMove.isNotEmpty) {
        firstMoves = [...firstMoves, ...planeMove];
        matchCount = 3;
      }
    }
    if (block == CharacterType.verticalBullet) {
      List<dynamic> verticals = verticalMoves(state.row, col, state);
      if (verticals.isNotEmpty) {
        firstMoves = [...firstMoves, ...verticals];
        matchCount = 3;
      }
    }
    if (block == CharacterType.horizontalBullet) {
      List<dynamic> horizontals = horizontalMoves(row, state.col, state);
      if (horizontals.isNotEmpty) {
        firstMoves = [...firstMoves, ...horizontals];
        matchCount = 3;
      }
    }

    if (block == CharacterType.bomb) {
      List<dynamic> bombs = bombMove(row, col, state);
      if (bombs.isNotEmpty) {
        firstMoves = [...firstMoves, ...bombs];
        matchCount = 3;
      }
    }

    if (block == CharacterType.superBomb) {
      List<dynamic> superBombs = await superBombMove(row, col, emit, state, recheck: recheck);
      if (superBombs.isNotEmpty) {
        firstMoves = [...firstMoves, ...superBombs];
        matchCount = 3;
      }
    }
    if (!recheck) {
      firstMoves = await recheckMoves(emit, state, firstMoves);
    }
    return {matchCount: firstMoves};
  }

  static recheckMoves(Emitter<GameState> emit, GameState state,
      List<Map<int, int>> firstMoves) async {
    for (Map<int, int> fm in firstMoves) {
      if (BreakCharacter.isBombCharacter(getCharacter(state,
          row: fm.entries.first.key, col: fm.entries.first.value))) {
        Map<int, List<Map<int, int>>> bo = await bombMoves(
            emit, state, fm.entries.first.key, fm.entries.first.value,
            recheck: true);
        if (bo.isNotEmpty) {
          if (bo.entries.first.key > 1) {
            firstMoves = [...firstMoves, ...bo.entries.first.value];
          }
        }
      }
    }
    return firstMoves;
  }

  static superBombMove(
      int row, int col, Emitter<GameState> emit, GameState state,
      {bool recheck = false}) async {
    bool move = true;
    List<Map<int, int>> mvs = [];
    CharacterType firstCharacter = CharacterType.hole;
    CharacterType secCharacter = CharacterType.hole;
    CharacterType thirdCharacter = getCharacter(state, row: row, col: col);

    int rowFirst = 0, rowSec = 0, colFirst = 0, colSec = 0;
    if (state.tempClicked.isNotEmpty) {
      rowFirst = state.tempClicked.entries.first.key;
      colFirst = state.tempClicked.entries.first.value;
      firstCharacter = getCharacter(state, row: rowFirst, col: colFirst);
    }
    if (state.tempSecClicked.isNotEmpty) {
      rowSec = state.tempSecClicked.entries.first.key;
      colSec = state.tempSecClicked.entries.first.value;
      secCharacter = getCharacter(state, row: rowSec, col: colSec);
    }
    if (mapEquals(state.tempSecClicked, state.tempClicked)) {
      // Does not allow double click
      move = false;
    } else if (firstCharacter == CharacterType.superBomb &&
        !BreakCharacter.isBombCharacter(secCharacter)) {
      mvs.add({row: col});
      for (Map<int, int> bm in findMatchedCharacter(state, secCharacter)) {
        mvs.add(bm);
      }
    } else if (secCharacter == CharacterType.superBomb &&
        !BreakCharacter.isBombCharacter(firstCharacter)) {
      mvs.add({row: col});
      for (Map<int, int> bm in findMatchedCharacter(state, firstCharacter)) {
        mvs.add(bm);
      }
    } else if (secCharacter == CharacterType.superBomb &&
        firstCharacter == CharacterType.superBomb) {
      for (int row = state.row; row >= 1; row--) {
        for (int col = state.col; col >= 1; col--) {
          mvs.add({row: col});
        }
      }
    } else if (thirdCharacter == CharacterType.superBomb &&
        BreakCharacter.isBombCharacter(secCharacter)) {
      mvs = await breakSuperBombIfConnectedWithBombOrFoundOnBomb(
          emit,
          state,
          secCharacter == CharacterType.superBomb
              ? firstCharacter
              : secCharacter,
          mvs);
    } else if (thirdCharacter == CharacterType.superBomb &&
        BreakCharacter.isBombCharacter(firstCharacter)) {
      mvs = await breakSuperBombIfConnectedWithBombOrFoundOnBomb(
          emit,
          state,
          secCharacter == CharacterType.superBomb
              ? firstCharacter
              : secCharacter,
          mvs);
    } else {
      move = false;
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static breakSuperBombIfConnectedWithBombOrFoundOnBomb(Emitter<GameState> emit,
      GameState state, CharacterType replace, List<Map<int, int>> mvs,
      {bool recheck = false}) async {
    Map<int, int> randomCharacterToPutBomb =
        findRandomCharacterOnBoards(state, []);
    List<Map<int, int>> matches = findMatchedCharacter(
        state,
        getCharacter(state,
            row: randomCharacterToPutBomb.entries.first.key,
            col: randomCharacterToPutBomb.entries.first.value));
    if (recheck) {
      for (Map<int, int> match in matches) {
        mvs.add(match);
      }
    } else {
      Map<int, Map<int, CharacterType>> boards =
          BreakCharacter.replaceCharacterWith(
              emit, state, state.gameBoards, matches, replace);
      emit(state.copyWith(gameBoards: boards));
      await Future.delayed(const Duration(milliseconds: 500));
      for (Map<int, int> match in await recheckMoves(emit, state, matches)) {
        mvs.add(match);
      }
    }
    return mvs;
  }

  static bombMove(int row, int col, GameState state, {bool manual = false}) {
    Map<int, int> reserve = {};
    if (mapEquals({row: col}, state.tempClicked)) {
      reserve = state.tempSecClicked;
    } else if (mapEquals({row: col}, state.tempSecClicked)) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.entries.first.key, col: state.tempClicked.entries.first.value) == CharacterType.bomb){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    CharacterType bomb = CharacterType.hole;
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.entries.first.key, col: reserve.entries.first.value);
    }
    if(bomb == CharacterType.plane && !manual){
      return [];
    }
    if(bomb == CharacterType.bomb && !manual && (getCharacter(state, row: state.tempClicked.entries.first.key, col: state.tempClicked.entries.first.value) != getCharacter(state, row: state.tempSecClicked.entries.first.key, col: state.tempSecClicked.entries.first.value))){
      return [];
    }
    bool move = false;
    List<Map<int, int>> mvs = [];

    if (bomb == CharacterType.verticalBullet || bomb == CharacterType.horizontalBullet) {
      for (int v = state.col; v >= 1; v--) {
        mvs.add({row-1: v});
        mvs.add({row: v});
        mvs.add({row+1: v});
      }
      for (int h = state.row; h >= 1; h--) {
        mvs.add({h: col+1});
        mvs.add({h: col});
        mvs.add({h: col-1});
      }
    }else if (bomb == CharacterType.bomb) {
      for (int h = (row + 2); h >= (row - 2); h--) {
        for (int v = (col + 2); v >= (col - 2); v--) {
          mvs.add({h: v});
          move = true;
        }
      }
    }else{
      for (int h = (row + 1); h >= (row - 1); h--) {
        for (int v = (col + 1); v >= (col - 1); v--) {
          mvs.add({h: v});
          move = true;
        }
      }
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static verticalMoves(int row, int col, GameState state,
      {bool manual = false}) {
    Map<int, int> reserve = {};
    if (mapEquals({row: col}, state.tempClicked)) {
      reserve = state.tempSecClicked;
    } else if (mapEquals({row: col}, state.tempSecClicked)) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.entries.first.key, col: state.tempClicked.entries.first.value) == CharacterType.verticalBullet){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    CharacterType bomb = CharacterType.hole;
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.entries.first.key, col: reserve.entries.first.value);
    }
    if(bomb == CharacterType.plane && !manual){
      return [];
    }
    if(bomb == CharacterType.bomb && !manual){
      return [];
    }
    bool move = false;
    List<Map<int, int>> mvs = [];
    for (int h = state.row; h >= 1; h--) {
      mvs.add({h: col});
      move = true;
    }
    //Same bomb
    if(bomb == CharacterType.verticalBullet && !manual){
      for (int h = state.col; h >= 1; h--) {
        mvs.add({reserve.entries.first.key: h});
        move = true;
      }
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static horizontalMoves(int row, int col, GameState state,
      {bool manual = false}) {
    Map<int, int> reserve = {};
    CharacterType bomb = CharacterType.hole;
    if (mapEquals({row: col}, state.tempClicked)) {
      reserve = state.tempSecClicked;
    } else if (mapEquals({row: col}, state.tempSecClicked)) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.entries.first.key, col: state.tempClicked.entries.first.value) == CharacterType.horizontalBullet){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.entries.first.key, col: reserve.entries.first.value);
    }
    if(bomb == CharacterType.plane && !manual){
      return [];
    }
    if(bomb == CharacterType.bomb && !manual){
      return [];
    }
    bool move = false;
    List<Map<int, int>> mvs = [];
    for (int v = state.col; v >= 1; v--) {
      mvs.add({row: v});
      move = true;
    }
    //Same bomb
    if(bomb == CharacterType.horizontalBullet && !manual){
      for (int h = state.row; h >= 1; h--) {
        mvs.add({h: reserve.entries.first.value});
        move = true;
      }
    }
    if (move) {
      return mvs;
    }
    return mvs;
  }

  static planeMoves(int row, int col, GameState state, {bool manual = false}) {
    List<Map<int, int>> mvs = [];
    CharacterType firstCharacter = CharacterType.hole;
    firstCharacter = getCharacter(state, row: row, col: col);
    Map<int, int> reserve = {};
    CharacterType bomb = CharacterType.hole;
    if (mapEquals({row: col}, state.tempClicked)) {
      reserve = state.tempSecClicked;
    } else if (mapEquals({row: col}, state.tempSecClicked)) {
      reserve = state.tempClicked;
    }else{
      if(getCharacter(state, row: state.tempClicked.entries.first.key, col: state.tempClicked.entries.first.value) == CharacterType.plane){
        reserve = state.tempSecClicked;
      }else{
        reserve = state.tempClicked;
      }
    }
    if (reserve.isNotEmpty) {
      bomb = getCharacter(state, row: reserve.entries.first.key, col: reserve.entries.first.value);
    }
    if(bomb == CharacterType.plane && !manual && (getCharacter(state, row: state.tempClicked.entries.first.key, col: state.tempClicked.entries.first.value) != getCharacter(state, row: state.tempSecClicked.entries.first.key, col: state.tempSecClicked.entries.first.value))){
      return [];
    }
    // TODO: This called twice due to bomb moves called twice so you must check if is already called before recall
    if (firstCharacter == CharacterType.plane) {
      mvs.add({row: col});
      mvs.add({row: col + 1});
      mvs.add({row: col - 1});
      mvs.add({row + 1: col});
      mvs.add({row - 1: col});
      if (BreakCharacter.isBombCharacter(bomb)) {
        Map<int, int> bombTargets = findTargetOnBoards(state, mvs);
        if (bombTargets.isNotEmpty) {
          List<dynamic> bombMoves = [];
          if (bomb == CharacterType.bomb) {
            bombMoves = bombMove(bombTargets.entries.first.key, bombTargets.entries.first.value, state, manual: true);
          }
          if (bomb == CharacterType.verticalBullet) {
            bombMoves = verticalMoves(bombTargets.entries.first.key, bombTargets.entries.first.value, state, manual: true);
          }
          if (bomb == CharacterType.horizontalBullet) {
            bombMoves = horizontalMoves(bombTargets.entries.first.key, bombTargets.entries.first.value, state, manual: true);
          }
          if (bomb == CharacterType.plane) {
            bombMoves = planeMoves(bombTargets.entries.first.key, bombTargets.entries.first.value, state, manual: true);
          }
          for (dynamic bmb in bombMoves) {
            mvs.add(bmb);
          }
        }
      } else {
        mvs.add(findTargetOnBoards(state, mvs));
      }
    }
    return mvs;
  }

  static CharacterType getLastTarget(GameState state) {
    for (Map<CharacterType, int> target in state.targets) {
      if (target.entries.first.value > 0) {
        return target.entries.first.key;
      }
    }
    return CharacterType.hole;
  }

  static Map<int, int> findTargetOnBoards(
      GameState state, List<Map<int, int>> excepts) {
    List<Map<int, int>> targets = [];
    CharacterType lastTarget = getLastTarget(state);
    bool ex = false;
    for (int row = state.row; row >= 1; row--) {
      for (int col = state.col; col >= 1; col--) {
        CharacterType targetOnBard = getCharacter(state, row: row, col: col);
        //Except to finish latter
        for (Map<int, int> exp in excepts) {
          if (mapEquals(exp, {row: col})) {
            ex = true;
          }
        }
        //End except
        if (targetOnBard == lastTarget) {
          targets.add({row: col});
        }
      }
    }
    var rand = Random();
    if (targets.isEmpty) {
      return {0: 0};
    }
    return targets[rand.nextInt(targets.length)];
  }

  static Map<int, int> findRandomCharacterOnBoards(
      GameState state, List<Map<int, int>> excepts) {
    List<Map<int, int>> targets = [];
    for (int row = state.row; row >= 1; row--) {
      for (int col = state.col; col >= 1; col--) {
        targets.add({row: col});
      }
    }
    var rand = Random();
    if (targets.isEmpty) {
      return {0: 0};
    }
    return targets[rand.nextInt(targets.length)];
  }

  static List<Map<int, int>> findMatchedCharacter(
      GameState state, CharacterType matchCharacter) {
    List<Map<int, int>> targets = [];
    for (int row = state.row; row >= 1; row--) {
      for (int col = state.col; col >= 1; col--) {
        CharacterType targetOnBard = getCharacter(state, row: row, col: col);
        if (targetOnBard == matchCharacter) {
          targets.add({row: col});
        }
      }
    }
    return targets;
  }
}
