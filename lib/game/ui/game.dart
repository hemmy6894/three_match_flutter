import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/animations/animate_position.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/levels/widget/game_over.dart';
import 'package:test_game/game/ui/levels/widget/move.dart';
import 'package:test_game/game/ui/levels/widget/target.dart';

class GameHome extends StatefulWidget {
  final int levelName;

  const GameHome({Key? key, required this.levelName}) : super(key: key);

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  Map<int, Map<int, CharacterType>> gameBoard = {};
  Map<int, Map<int, CharacterType>> gBoards = {};
  Map<int, Map<int, bool>> carpets = {};
  int row = 0;
  int col = 0;
  int moves = 1;
  Map<int, int> clicked = {};
  List<Widget> characters = [];
  CharacterType? selectedCharacter;

  @override
  void initState() {
    // TODO: implement initState
    context.read<GameBlock>().add(GameStartEvent(levelName: widget.levelName));
    row = context.read<GameBlock>().state.row;
    col = context.read<GameBlock>().state.col;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double height = screenSize.height;
    double width = screenSize.width;
    double temp = 0;
    if (width > height) {
      temp = width;
      width = height;
      height = temp;
    }
    return AppLayout(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(Assets.background),
        //   ),
        // ),
        child: Column(
          children: [
            Container(
              color: Colors.red.withOpacity(0.95),
              child: Row(
                children: [
                  const Expanded(
                    child: TargetWidget(),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 90,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(Assets.orange),
                        const Text(
                          "Give Away",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: MoveWidget(),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            gameListeners(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: width * (col / row),
                    height: width,
                    color: const Color(Assets.boardColor),
                  ),
                  for (var boards in gBoards.entries)
                    for (var board in boards.value.entries)
                      MojaPositionAnimation(
                        beginPosition: -2,
                        endPosition: 1,
                        position: Position(
                          left: width / row * (board.key - 1),
                          top: width /
                              row *
                              (boards.key - 1) *
                              getKeyTop(board.key * boards.key),
                        ),
                        duration: 3,
                        child: Character(
                          characterType: board.value,
                          row: boards.key,
                          active: mapEquals(clicked, {boards.key: board.key}),
                          col: board.key,
                          asCarpet: hasCarpet(row: boards.key, col: board.key),
                          height: width / row,
                          width: width / row,
                        ),
                      ),
                  GameOverWidget(
                      height: width,
                      width: width * (col / row),
                      levelName: widget.levelName),
                ],
              ),
            ),
            SizedBox(
              height: width * (0.3 / row),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Character(
                  characterType: CharacterType.hummer,
                  row: 100,
                  active: CharacterType.hummer == selectedCharacter,
                  col: 100,
                  isHelper: true,
                  height: (width / row),
                  width: (width / row),
                ),
                const SizedBox(
                  width: 5,
                ),
                Character(
                  characterType: CharacterType.hand,
                  row: 100,
                  isHelper: true,
                  active: CharacterType.hand == selectedCharacter,
                  col: 100,
                  height: (width / row),
                  width: (width / row),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<int, double> topAnimation = {};

  delayDrop({int delay = 1250, int index = 0}) async {
    for (int i = 0; i <= delay; i += 50) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        topAnimation = {...topAnimation, index: i / delay};
      });
    }
  }

  bool hasCarpet({required int row, required int col}) {
    bool clicked = false;
    clicked = (carpets[row] ?? {})[col] ?? false;
    return clicked;
  }

  getKeyTop(int keyTop) {
    return topAnimation[keyTop] ?? 1;
  }

  Widget gameListeners({required Widget child}) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GameBlock, GameState>(
          listenWhen: (p, c) => p.gameBoards != c.gameBoards,
          listener: (context, state) async {
            await Future.delayed(const Duration(milliseconds: 1000));
            setState(() {
              gBoards = state.gameBoards;
              col = state.col;
              row = state.row;
            });
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (p, c) => p.match != c.match,
          listener: (context, state) {
            if (state.match) {
              context
                  .read<GameBlock>()
                  .add(GameMatchCharacterStateEvent(match: false));
              context.read<GameBlock>().add(GameMatchCharacterEvent());
            }
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (p, c) => p.carpets != c.carpets,
          listener: (context, state) {
            setState(() {
              carpets = state.carpets;
            });
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (p, c) => p.selectedHelper != c.selectedHelper,
          listener: (context, state) {
            setState(() {
              selectedCharacter = state.selectedHelper;
            });
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (p, c) => p.secondClicked != c.secondClicked,
          listener: (context, state) {
            if (state.secondClicked.isNotEmpty) {
              context.read<GameBlock>().add(GameMoveCharacterEvent());
              context.read<GameBlock>().add(GameClearCharacterEvent());
            } else {}
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (previous, current) =>
              previous.toBreak != current.toBreak,
          listener: (context, state) {
            if (state.toBreak.isNotEmpty) {
              context.read<GameBlock>().add(GameBreakMatchEvent());
            }
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (previous, current) => previous.moves != current.moves,
          listener: (context, state) {
            setState(() {
              moves = state.moves;
            });
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (previous, current) =>
              !mapEquals(previous.firstClicked, current.firstClicked),
          listener: (context, state) {
            if (state.firstClicked.isNotEmpty) {
              context.read<GameBlock>().add(GameIsCapturedEvent());
              setState(() {
                clicked = state.firstClicked;
              });
            } else {
              setState(() {
                clicked = {};
              });
            }
          },
        ),
        BlocListener<GameBlock, GameState>(
          listenWhen: (previous, current) =>
              previous.dropDown != current.dropDown,
          listener: (context, state) {
            if (state.dropDown) {
              context.read<GameBlock>().add(GameDropCharacterEvent());
            }
          },
        ),
      ],
      child: child,
    );
  }
}
