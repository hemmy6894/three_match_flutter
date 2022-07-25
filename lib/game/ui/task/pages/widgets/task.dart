import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/assign.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/levels/widget/game_over.dart';
import 'package:test_game/game/ui/levels/widget/game_reward.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';
import 'package:test_game/game/ui/widgets/package.dart';
import 'package:test_game/game/ui/widgets/text_more.dart';

class TaskViewWidget extends StatefulWidget {
  final AssignModel title;
  final int levelName;
  final bool won;
  final bool assigns;

  const TaskViewWidget(
      {Key? key,
      required this.title,
      required this.levelName,
      this.won = false,
      this.assigns = false})
      : super(key: key);

  @override
  State<TaskViewWidget> createState() => _TaskViewWidgetState();
}

class _TaskViewWidgetState extends State<TaskViewWidget> {
  List<RewardModel> rewards = [];
  List<Map<CharacterType, int>> targets = [];
  List<Map<CharacterType, int>> gameTargets = [];
  bool startWith = false;
  int startIn = 0;
  int nowTime = 0;
  String startInMessage = "";
  late Timer timer;
  bool canPlay = false;

  @override
  initState() {
    Map<String, dynamic> level1 = Assets.levels[widget.levelName];
    var target = level1["targets"];
    if (target.isNotEmpty) {
      gameTargets = target;
    }
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        nowTime = DateTime.now().millisecondsSinceEpoch;
        startIn = widget.title.startAt.millisecondsSinceEpoch - nowTime;
        if (startIn < 0) {
          startIn = widget.title.endAt.millisecondsSinceEpoch - nowTime;
          if (startIn > 0) {
            canPlay = true;
            startInMessage =
                "End At " + Helpers.getTimeInMinutes(startIn ~/ 1000);
          } else {
            startInMessage = "Ended";
            canPlay = false;
          }
        } else {
          canPlay = false;
          startInMessage =
              "Start At " + Helpers.getTimeInMinutes(startIn ~/ 1000);
        }
      });
    });
    super.initState();
  }

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (widget.won ||
            (widget.title.assigner.id != widget.title.user.id &&
                widget.assigns)) {
          return;
        }
        if (canPlay) {
          if (widget.title.wonAt != null) {
            context.read<UiCubit>().initiateCount();
            return;
          }
          setState(() {
            startWith = !startWith;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(startInMessage),
            ),
          );
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: (widget.won || widget.assigns)
                ? Image.network(
                    widget.won ? widget.title.url : widget.title.wallpaper,
                    // if assigns display wallpaper
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fitHeight,
                    errorBuilder: (context, _, d) {
                      return Image.asset(
                        Assets.background,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.network(
                    widget.title.wallpaper,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, d) {
                      return Image.asset(
                        Assets.background,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          Container(
            width: mySize.width,
            height: mySize.height,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocListener<UiCubit, UiState>(
                  listener: (context, state) {
                    setState(() {
                      targets = [];
                      List<RewardModel> rws = [];
                      if (state.rewards.isEmpty) {
                        for (CharacterType c
                            in BreakCharacter.characterInRewards()) {
                          rws.add(RewardModel(character: c, amount: 0));
                        }
                      } else {
                        rws = state.rewards;
                      }
                      for (RewardModel reward in rws) {
                        if (reward.character !=
                            CharacterType.horizontalBullet) {
                          if (BreakCharacter.isBombCharacter(
                              reward.character)) {
                            targets.add({reward.character: reward.amount});
                          }
                        }
                      }
                    });
                  },
                  child: const Text(""),
                ),
              ],
            ),
            margin: const EdgeInsets.all(2),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: allAction(),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "@" + widget.title.assigner.name,
                        style: const TextStyle(
                            // fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "#" + widget.title.task.name,
                        style: const TextStyle(
                            // fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      if (!widget.won || widget.assigns)
                        Text(
                          startInMessage,
                          style: const TextStyle(
                            fontSize: 10,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      Text(
                        widget.title.title,
                        style: const TextStyle(
                            // fontSize: 10,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      if (widget.won || widget.assigns)
                        Container(
                          alignment: Alignment.topLeft,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextWithMore(
                            text: widget.title.description,
                            displayTextCount: 90,
                            style: const TextStyle(color: Colors.white),
                            moreStyle: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.won)
            Positioned(
              top: 15,
              left: 10,
              child: Text(
                "WON AT: ${widget.title.wonAt!.toString()}",
                style: const TextStyle(
                  // fontSize: 10,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          if (startWith)
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.7),
            ),
          if (startWith) startByBooster(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.91,
            child: GameRewardWidget(
              assignedId: widget.title.id,
            ),
          )
        ],
      ),
    );
  }

  bool retry = false;

  Widget startByBooster() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: Colors.white.withOpacity(0.9),
          height: MediaQuery.of(context).size.height * 0.5,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Targets:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 7,
              ),
              GameOverWidget.displayTarget(
                gameTargets,
                iconHeight: ((MediaQuery.of(context).size.width - 100) / 5),
                iconWidth: ((MediaQuery.of(context).size.width - 100) / 5),
                click: (clicked) {},
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.033,
              ),
              const Text(
                "Select Booster:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 7,
              ),
              GameOverWidget.displayTarget(targets,
                  iconHeight: ((MediaQuery.of(context).size.width - 100) / 5),
                  iconWidth: ((MediaQuery.of(context).size.width - 100) / 5),
                  click: (clicked) {
                if (clicked.isNotEmpty) {
                  if (clicked.entries.first.value > 0) {
                    context.read<GameBlock>().add(GameClickBoosterEvent(
                        booster: clicked.entries.first.key, amount: 1));
                  }
                }
              }, plusClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const PackageWidget(),
                    fullscreenDialog: true,
                  ),
                );
              }),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                color: const Color(Assets.primaryGoldColor),
                child: Text(
                  widget.title.task.name,
                  style: const TextStyle(
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
          top: 30,
          right: 22,
          child: Transform.rotate(
            angle: 180,
            child: IconButton(
              icon: const Icon(
                Icons.add,
              ),
              onPressed: () {
                setState(() {
                  startWith = !startWith;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 15,
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
                    title: retry ? "Retry" : "Play",
                    mainAxisAlignment: MainAxisAlignment.center,
                    buttonSizeHeight: MediaQuery.of(context).size.height * 0.06,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.033),
                    onPressed: () async {
                      startWith = false;
                      retry = false;
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => GameHome(
                            levelName: widget.levelName,
                            assignedId: widget.title.id,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      if (!mounted) return;
                      if (result != null) {
                        startWith = true;
                        retry = true;
                      } else {
                        startWith = false;
                        retry = false;
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool expand = true;

  Widget allAction() {
    return Column(
      children: [
        if (expand) actionButton(Icons.person),
        if (expand) actionButton(Icons.notification_important_rounded),
        if (expand) actionButton(Icons.share),
        GestureDetector(
          onTap: () {
            setState(() {
              expand = !expand;
            });
          },
          child: actionButton(expand ? Icons.close : Icons.add,
              color: expand ? Colors.white : Colors.white),
        ),
      ],
    );
  }

  Widget actionButton(IconData icon, {Color color = Colors.white}) {
    return Container(
      child: Icon(
        icon,
        color: color,
        size: 35,
      ),
      padding: const EdgeInsets.all(5),
    );
  }
}
