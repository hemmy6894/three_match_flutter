import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';

class GameRewardWidget extends StatefulWidget {
  const GameRewardWidget({Key? key}) : super(key: key);

  @override
  State<GameRewardWidget> createState() => _GameRewardWidgetState();
}

class _GameRewardWidgetState extends State<GameRewardWidget> {
  bool isOverTarget = false;
  int tickTime = 16;
  int timing = 0;
  bool showTimer = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBlock, GameState>(
      listenWhen: (p, c) => p.targets != c.targets,
      listener: (context, state) {
        if (state.targetIsOver()) {
          Timer.periodic(const Duration(seconds: 1), (timer) {
            setState((){
              timing = tickTime - timer.tick;
            });
            if(timer.tick >= tickTime){
              timer.cancel();
              setState(() {
                isOverTarget = true;
              });
            }
          });
        }
      },
      child: displayWidget(),
    );
  }

  displayWidget() {
    if(timing > 0){
      return Container(
        alignment: Alignment.center,
        color: Colors.transparent.withOpacity(0.9),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Congratulation",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: MediaQuery.of(context).size.width * 0.06),
            ),
            Text(
              "Wait for your gift",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            Text(
              "$timing",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontSize: MediaQuery.of(context).size.width * 0.06),
            ),
          ],
        )
      );
    }
    if (isOverTarget) {
      return SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Colors.transparent.withOpacity(0.8),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              if (context.read<ServerBloc>().state.assigned(
                      id: context
                          .read<GameBlock>()
                          .state
                          .assignedId
                          .toString()) !=
                  null)
                Image.network(
                  context
                      .read<ServerBloc>()
                      .state
                      .assigned(
                          id: context
                              .read<GameBlock>()
                              .state
                              .assignedId
                              .toString())!
                      .url,
                  height: MediaQuery.of(context).size.height * (1 - 0.08),
                ),
              if (context.read<ServerBloc>().state.assigned(
                      id: context
                          .read<GameBlock>()
                          .state
                          .assignedId
                          .toString()) !=
                  null)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    context
                            .read<ServerBloc>()
                            .state
                            .assigned(
                                id: context
                                    .read<GameBlock>()
                                    .state
                                    .assignedId
                                    .toString())!
                            .description +
                        "Bojan Walden nark asides Esdras designs unused asides saunas ideas standard's ideas dissident's dead astound asides ",
                    style: const TextStyle(
                      backgroundColor: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ButtonComponent(
                title: "Click to continue",
                onPressed: () {
                  Navigator.of(context).pop();
                },
                buttonIcon: Icons.arrow_forward_rounded,
              )
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
