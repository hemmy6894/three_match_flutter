import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/data/models/assign.dart';
import 'package:test_game/game/data/models/game/reward.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/game.dart';
import 'package:test_game/game/ui/game/character.dart';
import 'package:test_game/game/ui/levels/widget/game_over.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';

class TaskViewWidget extends StatefulWidget {
  final AssignModel title;
  final int levelName;

  const TaskViewWidget({Key? key, required this.title, required this.levelName})
      : super(key: key);

  @override
  State<TaskViewWidget> createState() => _TaskViewWidgetState();
}

class _TaskViewWidgetState extends State<TaskViewWidget> {
  List<RewardModel> rewards = [];
  List<Map<CharacterType, int>> targets = [];
  bool startWith = false;

  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          startWith = !startWith;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Container(
          //   child: Image.network(widget.title.url, height: MediaQuery.of(context).size.height,),
          // ),
          Container(
            width: mySize.width,
            height: mySize.height,
            // color: Colors.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        widget.title.title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.white),
                      ),
                      // Text(
                      //   widget.title.description,
                      //   style:
                      //   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      // )
                    ],
                  ),
                ),
                BlocListener<UiCubit, UiState>(
                  listener: (context, state) {
                    setState(() {
                      targets = [];
                      for (RewardModel reward in state.rewards) {
                        if(BreakCharacter.isBombCharacter(reward.character)) {
                          targets.add({reward.character: reward.amount});
                        }
                      }
                    });
                  },
                  child: const Text(""),
                )
              ],
            ),
            margin: const EdgeInsets.all(2),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: allAction(),
          ),
          //
          if (startWith) startByBooster(),
        ],
      ),
    );
  }

  Widget startByBooster() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GameOverWidget.displayTarget(targets, iconHeight: ((MediaQuery.of(context).size.width - 100) / 5), iconWidth: ((MediaQuery.of(context).size.width - 100) / 5), click: (clicked) {
            if (clicked.isNotEmpty) {
              context.read<GameBlock>().add(GameClickBoosterEvent(booster: clicked.entries.first.key, amount: 1));
            }
          }),
          const SizedBox(height: 40,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonComponent(title: "Clear Selection", onPressed: () {
                context.read<GameBlock>().add(GameClearBoosterClickedEvent());
              }),
              ButtonComponent(title: "Start Game", onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        GameHome(levelName: widget.levelName, assignedId: widget.title.taskId,),
                    fullscreenDialog: true,
                  ),
                );
                startWith = false;
              })
            ],
          ),
        ],
      ),
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
