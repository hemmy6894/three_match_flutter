import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';
import 'package:test_game/game/ui/widgets/package.dart';

class GameOverWidget extends StatefulWidget {
  final double height;
  final double width;
  final int levelName;

  const GameOverWidget({
    Key? key,
    required this.width,
    required this.levelName,
    required this.height,
  }) : super(key: key);

  static Widget displayTarget(
    List<Map<CharacterType, int>> targets, {
    Function(Map<CharacterType, int>)? click,
    Function()? plusClicked,
    double iconWidth = 33,
    double iconHeight = 33,
  }) {
    Map<CharacterType, bool> disableClick = {};
    for (Map<CharacterType, int> target in targets) {
      disableClick[target.entries.first.key] = false;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (Map<CharacterType, int> target in targets)
              GestureDetector(
                onTap: () {
                  bool dis = disableClick[target.entries.first.key] ?? false;
                  if (click != null && !dis) {
                    click(target);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(iconHeight),
                      child: Container(
                        color: Colors.blueGrey,
                        child: Image.asset(
                          Assets.getCharacter(
                              characterType: target.entries.first.key),
                          height: iconHeight,
                          width: iconWidth,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular((iconHeight / 4)),
                          ),
                        ),
                        child: target.entries.first.value < 1 &&
                                BreakCharacter.isBombCharacter(
                                    target.entries.first.key)
                            ? GestureDetector(
                                child: const Icon(Icons.add),
                                onTap: () {
                                  if (plusClicked != null) {
                                    plusClicked();
                                  }
                                },
                              )
                            : Text(
                                target.entries.first.value.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: (iconHeight / 4)),
                              ),
                      ),
                    ),
                    BlocBuilder<GameBlock, GameState>(
                      builder: (context, state) {
                        int? boosted = context
                            .read<GameBlock>()
                            .state
                            .selectedBooster(booster: target.entries.first.key);
                        if (boosted == null) {
                          return Container();
                        }
                        if (boosted >= 3) {
                          //target.entries.first.value) {
                          disableClick[target.entries.first.key] = true;
                        } else {
                          disableClick[target.entries.first.key] = false;
                        }
                        if (boosted < 1) {
                          return Container();
                        }
                        return Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular((iconHeight / 4)),
                              ),
                            ),
                            child: Text(
                              boosted.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: (iconHeight / 4)),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
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

  int waitingLogo = 5;

  @override
  void initState() {
    timer = Timer(const Duration(days: 2), () {});
    super.initState();
  }

  @override
  dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  late Timer timer;
  int tickTime = 10;
  int timing = 1;
  bool isOverTarget = false;

  initiateTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timing = tickTime - timer.tick;
      });
      if (timer.tick >= tickTime) {
        timer.cancel();
        setState(() {
          isOverTarget = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if (moves < 1 && gameOver) {
      return Container(
        color: Colors.grey.withOpacity(0.8),
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: widget.width * 0.8,
            height: widget.height * 0.7,
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
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GameOverWidget.displayTarget(
                      targets,
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     restartGame(),
                    //   ],
                    // ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        color: const Color(Assets.primaryGoldColor),
                        child: const Text(
                          "Out of moves",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -4,
                  right: -8,
                  child: Transform.rotate(
                    angle: 180,
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        Navigator.pop(context,context.read<GameBlock>().state.assignedId);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: -5,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ButtonComponent(
                            title: "Play on 700 coin",
                            mainAxisAlignment: MainAxisAlignment.center,
                            buttonSizeHeight:
                                MediaQuery.of(context).size.height * 0.06,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.023),
                            onPressed: () {
                              int count = context
                                  .read<UiCubit>()
                                  .state
                                  .getRewardCount(CharacterType.coin);
                              if (count < 700) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const PackageWidget(),
                                    fullscreenDialog: true,
                                  ),
                                );
                              } else {
                                bool isOver = false;
                                int numberMove = 5;
                                context.read<UiCubit>().incrementLife();
                                context.read<GameBlock>().add(
                                    GameIncrementMovesEvent(moves: numberMove));
                                context.read<UiCubit>().receiveRewards(
                                    rewards: [
                                      const RewardModel(
                                          character: CharacterType.coin,
                                          amount: 0 - 700)
                                    ]);
                                setState(() {
                                  gameOver = isOver;
                                  moves = numberMove;
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (targetFinished) {
      if (timing > 0) {
        return Stack(
          children: [
            Container(
              color: Colors.transparent.withOpacity(0.4),
              alignment: Alignment.center,
              width: widget.width,
              height: widget.height,
              child: SizedBox(
                width: widget.width * 0.5,
                height: widget.height * 0.5,
                child: Image.asset(
                  Assets.finalLogo,
                  width: widget.width * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        );
      }
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
            child: const Text(""),
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
                  color: const Color(Assets.primaryTargetBackgroundColor),
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
                      "Score",
                      style: TextStyle(
                          color: Colors.red.withOpacity(0.95),
                          fontSize: widget.width * 0.07),
                    ),
                    displayRewards(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonComponent(
                            title: "Continue",
                            onPressed: () {
                              context.read<UiCubit>().initiateCount();
                            })
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
            initiateTimer();
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
    if (!isRewarded) {
      context.read<UiCubit>().receiveRewards(rewards: rewards);
      if (context.read<GameBlock>().state.assignedId != null) {
        context.read<ServerBloc>().add(
            WonTaskEvent(taskId: context.read<GameBlock>().state.assignedId!));
      }
      setState(() {
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
