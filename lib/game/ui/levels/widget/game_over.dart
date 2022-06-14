import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';

class GameOverWidget extends StatefulWidget {
  final double height;
  final double width;
  final int levelName;

  const GameOverWidget({Key? key,
    required this.width,
    required this.levelName,
    required this.height})
      : super(key: key);

  static Widget displayTarget(List<Map<CharacterType, int>> targets) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (Map<CharacterType, int> target in targets)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    Assets.getCharacter(
                        characterType: target.entries.first.key),
                    height: 33,
                    width: 33,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: Text(
                        target.entries.first.value.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
          ],
        )
      ],
    );
  }

  @override
  State<GameOverWidget> createState() => _GameOverWidgetState();
}

class _GameOverWidgetState extends State<GameOverWidget> {
  List<Map<CharacterType, int>> targets = [];
  List<RewardModel> rewards = [];
  int moves = 1;
  bool gameOver = false;
  bool targetFinished = false;
  bool notAlive = false;
  Map<CharacterType, int> received = {};

  @override
  Widget build(BuildContext context) {
    if (moves < 1 && gameOver) {
      return Container(
        color: Colors.transparent,
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: widget.width * 0.8,
            height: widget.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  8,
                ),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.75),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(
                    0,
                    5,
                  ), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Out Of Moves",
                  style: TextStyle(
                    color: Colors.red.withOpacity(
                      0.95,
                    ),
                    fontSize: widget.width * 0.09,
                  ),
                ),
                GameOverWidget.displayTarget(
                  targets,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    restartGame(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (targetFinished) {
      return Stack(
        children: [
          BlocListener<UiCubit, UiState>(
            listenWhen: (previous, current) =>
            !mapEquals(previous.received, current.received),
            listener: (context, state) {
              setState(() {
                received = state.received;
              });
            },
            child: Text(""),
          ),
          Container(
            color: Colors.transparent,
            width: widget.width,
            height: widget.height,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                width: widget.width * 0.6,
                height: widget.height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.75),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: const Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Congratulation",
                      style: TextStyle(
                          color: Colors.red.withOpacity(0.95),
                          fontSize: widget.width * 0.07),
                    ),
                    displayRewards(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        goHome(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (received.isNotEmpty)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    Assets.getCharacter(
                        characterType: received.entries.first.key),
                    height: 90,
                    width: 90,
                  ),
                  Positioned(
                    right: widget.width * 0.40,
                    bottom: widget.height * 0.40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        received.entries.first.value.toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                  )
                ],
              ),
            )
        ],
      );
    }

    if (notAlive) {
      return Container(
        color: Colors.transparent,
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: widget.width * 0.6,
            height: widget.height * 0.6,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.75),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Not Alive",
                  style: TextStyle(
                      color: Colors.red.withOpacity(0.95),
                      fontSize: widget.width * 0.09),
                ),
                const LiveCount(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    goHome(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    return MultiBlocListener(listeners: [
      BlocListener<GameBlock, GameState>(
        listenWhen: (p, c) => p.moves != c.moves,
        listener: (context, state) async {
          bool isOver = false;
          if (state.moves == 0) {
            if (!state.targetIsOver()) {
              isOver = true;
              context.read<UiCubit>().decrementLife();
            }
          }
          setState(() {
            gameOver = isOver;
            moves = state.moves;
            targets = state.targets;
          });
        },
      ),
      BlocListener<GameBlock, GameState>(
        listenWhen: (p, c) => p.targets != c.targets,
        listener: (context, state) {
          if (state.targetIsOver()) {
            setState(() {
              targetFinished = true;
              targets = state.targets;
              gameOver = false;
              rewards = state.rewards;
            });
          }
        },
      ),
      BlocListener<UiCubit, UiState>(
        listenWhen: (previous, current) =>
        !mapEquals(previous.received, current.received),
        listener: (context, state) {
          setState(() {
            received = state.received;
          });
        },
      ),
      BlocListener<UiCubit, UiState>(
        listener: (context, state) {
          setState(() {
            notAlive = state.lastLifeCount < 1;
          });
        },
      ),
    ], child: const Text(""));
  }

  bool isRewarded = false;
  Widget displayRewards() {
    if(!isRewarded) {
      context.read<UiCubit>().receiveRewards(rewards: rewards);
      setState((){
        isRewarded = true;
      });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (RewardModel target in rewards)
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    Assets.getCharacter(characterType: target.character),
                    height: 33,
                    width: 33,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                      ),
                      child: Text(
                        target.amount.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
          ],
        )
      ],
    );
  }

  Widget restartGame() {
    return GestureDetector(
      onTap: () {
        context
            .read<GameBlock>()
            .add(GameStartEvent(levelName: widget.levelName));
        setState(() {
          moves = 1;
        });
      },
      child: Image.asset(
        Assets.restart,
        height: widget.height * 0.08,
      ),
    );
  }

  Widget goHome() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Image.asset(
        Assets.orange,
        height: widget.height * 0.08,
      ),
    );
  }
}
