import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/animations/animate_position.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/layouts/app.dart';

class GameHome extends StatefulWidget {
  const GameHome({Key? key}) : super(key: key);

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> {
  Map<int, Map<int, CharacterType>> gameBoard = {};
  Map<int, Map<int, CharacterType>> gBoards = {};
  int row = 0;
  int col = 0;
  Map<int, int> clicked = {};
  List<Widget> characters = [];

  @override
  void initState() {
    // TODO: implement initState
    context.read<GameBlock>().add(GameStartEvent());
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocListener<GameBlock, GameState>(
              listenWhen: (p, c) => p.gameBoards != c.gameBoards,
              listener: (context, state) async {
                await Future.delayed(const Duration(milliseconds: 1000));
                setState(() {
                  gBoards = state.gameBoards;
                  // print(state.previousPosition);
                  // for(Map<int,int> d in state.previousPosition){
                  //   delayDrop(delay: 1000, index: d.entries.first.key * d.entries.first.value);
                  // }
                });
              },
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Container(
                    width: width * (col / row),
                    height: width,
                    color: Colors.black,
                  ),
                  for (var boards in gBoards.entries)
                    for (var board in boards.value.entries)
                      MojaPositionAnimation(
                        beginPosition: -2,
                        endPosition: 1,
                        position: Position(
                          left: width / row * (board.key - 1),
                          top: width / row * (boards.key - 1) * getKeyTop(board.key * boards.key),
                        ),
                        duration: 3,
                        child: Character(
                          characterType: board.value,
                          row: boards.key,
                          active: mapEquals(clicked, {boards.key: board.key}),
                          col: board.key,
                          height: width / row,
                          width: width / row,
                        ),
                      ),
                ],
              ),
            ),
            MultiBlocListener(listeners: [
              BlocListener<GameBlock, GameState>(
                  listenWhen: (p, c) => p.match != c.match,
                  listener: (context, state) {
                    if (state.match) {
                      context
                          .read<GameBlock>()
                          .add(GameMatchCharacterStateEvent(match: false));
                      context.read<GameBlock>().add(GameMatchCharacterEvent());
                    }
                  }),
              BlocListener<GameBlock, GameState>(
                  listenWhen: (p, c) => p.secondClicked != c.secondClicked,
                  listener: (context, state) {
                    if (state.secondClicked.isNotEmpty) {
                      context.read<GameBlock>().add(GameMoveCharacterEvent());
                      context.read<GameBlock>().add(GameClearCharacterEvent());
                    } else {}
                  }),
              BlocListener<GameBlock, GameState>(
                  listenWhen: (previous, current) =>
                      previous.toBreak != current.toBreak,
                  listener: (context, state) {
                    if (state.toBreak.isNotEmpty) {
                      context.read<GameBlock>().add(GameBreakMatchEvent());
                    }
                  }),
              BlocListener<GameBlock, GameState>(
                  listenWhen: (previous, current) =>
                      !mapEquals(previous.firstClicked, current.firstClicked),
                  listener: (context, state) {
                    if (state.firstClicked.isNotEmpty) {
                      setState(() {
                        clicked = state.firstClicked;
                      });
                    } else {
                      setState(() {
                        clicked = {};
                      });
                    }
                  }),
              BlocListener<GameBlock, GameState>(
                  listenWhen: (previous, current) =>
                      previous.dropDown != current.dropDown,
                  listener: (context, state) {
                    if (state.dropDown) {
                      context.read<GameBlock>().add(GameDropCharacterEvent());
                    }
                  }),
            ], child: Container()),
          ],
        ),
      ),
    );
  }

  Map<int,double> topAnimation = {};
  delayDrop({int delay = 1250, int index = 0}) async{
    for(int i = 0; i <= delay; i += 50){
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        topAnimation = { ...topAnimation,index : i / delay};
      });
    }
  }
  getKeyTop(int keyTop){
    return topAnimation[keyTop] ?? 1;
  }
}
