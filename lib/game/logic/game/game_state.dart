part of 'game_bloc.dart';

class GameState extends Equatable {
  final Map<int, Map<int, CharacterType>> gameBoards;
  final Map<int, int> firstClicked;
  final Map<int, int> secondClicked;
  final Map<int, int> tempClicked;
  final Map<int, int> tempSecClicked;
  final List<Map<int, int>> toBreak;
  final List<Map<int, int>> planes;
  final List<Map<int, int>> bombs;
  final List<Map<int, int>> bullets;
  final List<Map<int, int>> superBombs;
  final List<Map<int, int>> previousPosition;
  final List<Map<int, int>> currentPosition;
  final int col;
  final int row;
  final bool match;
  final bool reversed;
  final bool dropDown;
  final bool matchAll;
  final bool bombTouched;

  const GameState(
      {required this.gameBoards,
      required this.firstClicked,
      required this.tempClicked,
      required this.tempSecClicked,
      required this.toBreak,
      required this.planes,
      required this.bombs,
      required this.bullets,
      required this.superBombs,
      required this.previousPosition,
      required this.currentPosition,
      required this.row,
      required this.col,
      required this.match,
      required this.reversed,
      required this.dropDown,
      required this.matchAll,
      required this.bombTouched,
      required this.secondClicked});

  factory GameState.empty() => const GameState(
      gameBoards: {},
      firstClicked: {},
      toBreak: [],
      planes: [],
      bullets: [],
      bombs: [],
      superBombs: [],
      previousPosition: [],
      currentPosition: [],
      secondClicked: {},
      tempClicked: {},
      tempSecClicked: {},
      col: 6,
      row: 7,
      match: false,
      reversed: false,
      matchAll: false,
      bombTouched: true,
      dropDown: false);

  GameState copyWith({
    Map<int, Map<int, CharacterType>>? gameBoards,
    Map<int, int>? firstClicked,
    Map<int, int>? secondClicked,
    Map<int, int>? tempClicked,
    Map<int, int>? tempSecClicked,
    List<Map<int, int>>? toBreak,
    List<Map<int, int>>? planes,
    List<Map<int, int>>? bullets,
    List<Map<int, int>>? bombs,
    List<Map<int, int>>? superBombs,
    List<Map<int, int>>? previousPosition,
    List<Map<int, int>>? currentPosition,
    int? col,
    int? row,
    bool? match,
    bool? reversed,
    bool? dropDown,
    bool? matchAll,
    bool? bombTouched,
  }) {
    return GameState(
      gameBoards: gameBoards ?? this.gameBoards,
      firstClicked: firstClicked ?? this.firstClicked,
      secondClicked: secondClicked ?? this.secondClicked,
      tempClicked: tempClicked ?? this.tempClicked,
      tempSecClicked: tempSecClicked ?? this.tempSecClicked,
      toBreak: toBreak ?? this.toBreak,
      planes: planes ?? this.planes,
      bullets: bullets ?? this.bullets,
      bombs: bombs ?? this.bombs,
      superBombs: superBombs ?? this.superBombs,
      previousPosition: previousPosition ?? this.previousPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      row: row ?? this.row,
      col: col ?? this.col,
      match: match ?? this.match,
      reversed: reversed ?? this.reversed,
      matchAll: matchAll ?? this.matchAll,
      dropDown: dropDown ?? this.dropDown,
      bombTouched: bombTouched ?? this.bombTouched,
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

  @override
  List<Object?> get props => [
        gameBoards.entries,
        firstClicked.entries,
        secondClicked.entries,
        col,
        row,
        match,
        tempClicked.entries,
        tempSecClicked.entries,
        previousPosition,
        currentPosition,
        reversed,
        toBreak,
        planes,
        bullets,
        bombs,
        superBombs,
        dropDown,
        matchAll,
        bombTouched
      ];
}
