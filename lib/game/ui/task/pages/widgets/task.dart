import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/animations/animate_position.dart';
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
  int startIn = 0;
  int nowTime = 0;
  String startInMessage = "";
  late Timer timer;
  bool canPlay = false;
  @override
  initState(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        nowTime = DateTime.now().millisecondsSinceEpoch;
        startIn =  widget.title.startAt.millisecondsSinceEpoch - nowTime;
        if(startIn < 0){
          startIn =  widget.title.endAt.millisecondsSinceEpoch - nowTime;
          if(startIn > 0){
            canPlay = true;
            startInMessage = "End At " + Helpers.getTimeInMinutes(startIn ~/ 1000);
          }else{
            startInMessage = "Ended";
            canPlay = false;
          }
        }else{
          canPlay = false;
          startInMessage = "Start At " + Helpers.getTimeInMinutes(startIn ~/ 1000);
        }
      });
    });
    super.initState();
  }

  @override
  dispose(){
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if(canPlay) {
          setState(() {
            startWith = !startWith;
          });
        }else{
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
                    ],
                  ),
                ),
                BlocListener<UiCubit, UiState>(
                  listener: (context, state) {
                    setState(() {
                      targets = [];
                      List<RewardModel> rws = [];
                      if(state.rewards.isEmpty){
                        for(CharacterType c in BreakCharacter.characterInRewards()){
                          rws.add(RewardModel(character: c, amount: 0));
                        }
                      }else{
                        rws = state.rewards;
                      }
                      for (RewardModel reward in rws) {
                        if (BreakCharacter.isBombCharacter(reward.character)) {
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
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              startInMessage,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.white),
            ),
          ),
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
          GameOverWidget.displayTarget(targets,
              iconHeight: ((MediaQuery.of(context).size.width - 100) / 5),
              iconWidth: ((MediaQuery.of(context).size.width - 100) / 5),
              click: (clicked) {
            if (clicked.isNotEmpty) {
              if(clicked.entries.first.value > 0) {
                context.read<GameBlock>().add(GameClickBoosterEvent(booster: clicked.entries.first.key, amount: 1));
              }
            }
          }),
          const SizedBox(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ButtonComponent(
              //     title: "Clear Selection",
              //     onPressed: () {
              //       context.read<GameBlock>().add(GameClearBoosterClickedEvent());
              //     }),
              ButtonComponent(
                  title: "Start Game",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => GameHome(
                          levelName: widget.levelName,
                          assignedId: widget.title.taskId,
                        ),
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
