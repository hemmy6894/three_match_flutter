part of 'game_bloc.dart';

class GameState extends Equatable {
  final Map<int, Map<int, CharacterType>> gameBoards;
  final Map<int, Map<int, bool>> carpets;
  final Map<int, int> firstClicked;
  final Map<int, int> secondClicked;
  final Map<int, int> tempClicked;
  final Map<int, int> tempSecClicked;
  final List<Map<CharacterType, int>> targets;
  final List<Map<int, int>> toBreak;
  final List<Map<int, int>> planes;
  final List<Map<int, int>> bombs;
  final List<Map<int, int>> bulletVerticals;
  final List<Map<int, int>> bulletHorizontals;
  final List<Map<int, int>> superBombs;
  final List<Map<int, int>> previousPosition;
  final List<Map<int, int>> currentPosition;
  final CharacterType? selectedHelper;
  final int col;
  final int moves;
  final int row;
  final List<Map<CharacterType, int>> rewards;
  final bool match;
  final bool reversed;
  final bool dropDown;
  final bool matchAll;
  final bool bombTouched;

  const GameState(
      {required this.gameBoards,
      required this.carpets,
      required this.firstClicked,
      required this.tempClicked,
      required this.tempSecClicked,
      required this.targets,
      required this.rewards,
      required this.toBreak,
      required this.planes,
      required this.bombs,
      required this.bulletVerticals,
      required this.bulletHorizontals,
      required this.superBombs,
      required this.previousPosition,
      required this.currentPosition,
      required this.row,
      required this.col,
      required this.moves,
      required this.match,
      required this.reversed,
      required this.dropDown,
      required this.matchAll,
      required this.selectedHelper,
      required this.bombTouched,
      required this.secondClicked});

  factory GameState.empty() => const GameState(
      gameBoards: {},
      carpets: {},
      firstClicked: {},
      toBreak: [],
      planes: [],
      bulletVerticals: [],
      bulletHorizontals: [],
      bombs: [],
      superBombs: [],
      previousPosition: [],
      currentPosition: [],
      secondClicked: {},
      tempClicked: {},
      tempSecClicked: {},
      targets: [],
      rewards: [],
      moves: 10,
      col: 10,
      row: 11,
      match: false,
      reversed: false,
      matchAll: false,
      selectedHelper: null,
      bombTouched: true,
      dropDown: false);

  GameState copyWith({
    Map<int, Map<int, CharacterType>>? gameBoards,
    Map<int, Map<int, bool>>? carpets,
    Map<int, int>? firstClicked,
    Map<int, int>? secondClicked,
    Map<int, int>? tempClicked,
    Map<int, int>? tempSecClicked,
    List<Map<CharacterType, int>>? targets,
    List<Map<CharacterType, int>>? rewards,
    List<Map<int, int>>? toBreak,
    List<Map<int, int>>? planes,
    List<Map<int, int>>? bulletHorizontals,
    List<Map<int, int>>? bulletVerticals,
    List<Map<int, int>>? bombs,
    List<Map<int, int>>? superBombs,
    List<Map<int, int>>? previousPosition,
    List<Map<int, int>>? currentPosition,
    int? moves,
    int? col,
    int? row,
    bool? match,
    bool? reversed,
    bool? dropDown,
    bool? matchAll,
    bool? bombTouched,
    CharacterType? selectedHelper,
  }) {
    return GameState(
      gameBoards: gameBoards ?? this.gameBoards,
      carpets: carpets ?? this.carpets,
      firstClicked: firstClicked ?? this.firstClicked,
      secondClicked: secondClicked ?? this.secondClicked,
      tempClicked: tempClicked ?? this.tempClicked,
      tempSecClicked: tempSecClicked ?? this.tempSecClicked,
      targets: targets ?? this.targets,
      rewards: rewards ?? this.rewards,
      toBreak: toBreak ?? this.toBreak,
      planes: planes ?? this.planes,
      bulletVerticals: bulletVerticals ?? this.bulletVerticals,
      bulletHorizontals: bulletHorizontals ?? this.bulletHorizontals,
      bombs: bombs ?? this.bombs,
      superBombs: superBombs ?? this.superBombs,
      previousPosition: previousPosition ?? this.previousPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      moves: moves ?? this.moves,
      row: row ?? this.row,
      col: col ?? this.col,
      match: match ?? this.match,
      reversed: reversed ?? this.reversed,
      matchAll: matchAll ?? this.matchAll,
      dropDown: dropDown ?? this.dropDown,
      bombTouched: bombTouched ?? this.bombTouched,
      selectedHelper: selectedHelper ?? this.selectedHelper,
    );
  }

  bool checkClicked({required int row, required int col}) {
    bool clicked = false;
    if (firstClicked.isNotEmpty) {
      int firstRow = firstClicked.entries.first.key;
      int firstCol = firstClicked.entries.first.value;
      if ((row == firstRow && col == firstCol)) {
        clicked = true;
      }
    }
    return clicked;
  }

  bool hasCarpet({required int row, required int col}) {
    bool clicked = false;
    clicked = (carpets[row] ?? {})[col] ?? false;
    return clicked;
  }

  bool targetIsOver() {
    bool target = false;
    int totalTarget = 0;
    for (Map<CharacterType, int> trg in targets) {
      totalTarget += trg.entries.first.value;
    }
    if (totalTarget < 1) {
      target = true;
    }
    return target;
  }

  @override
  List<Object?> get props => [
        gameBoards.entries,
        carpets.entries,
        firstClicked.entries,
        secondClicked.entries,
        col,
        row,
        moves,
        match,
        tempClicked.entries,
        tempSecClicked.entries,
        previousPosition,
        currentPosition,
        reversed,
        toBreak,
        planes,
        bulletVerticals,
        bulletHorizontals,
        bombs,
        superBombs,
        dropDown,
        matchAll,
        bombTouched,
        selectedHelper,
        targets,
        rewards
      ];
}
