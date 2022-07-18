import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/levels/widget/game_over.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';

class GameRewardWidget extends StatefulWidget {
  final double width;
  final String? assignedId;
  const GameRewardWidget({Key? key, this.width = 0, this.assignedId}) : super(key: key);

  @override
  State<GameRewardWidget> createState() => _GameRewardWidgetState();
}

class _GameRewardWidgetState extends State<GameRewardWidget> {
  bool isOverTarget = false;
  int tickTime = 16;
  int timing = 0;
  bool showTimer = false;


  @override
  initState() {
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
    return BlocListener<UiCubit, UiState>(
      listenWhen: (p, c) => p.startCounting != c.startCounting,
      listener: (context, state) {
        initiateTimer();
      },
      child: timing > 15 ? Container() : displayWidget(),
    );
  }

  displayWidget() {
    if (timing > 0) {
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
                fontSize: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
            Text(
              "Wait for your gift",
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            Text(
              "$timing",
              style: TextStyle(
                color: Colors.white.withOpacity(0.95),
                fontSize: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
          ],
        ),
      );
    }
    if (isOverTarget) {
      return SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              if (context.read<ServerBloc>().state.assigned(
                      id: widget.assignedId ?? context
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
                          id: widget.assignedId ?? context
                              .read<GameBlock>()
                              .state
                              .assignedId
                              .toString())!
                      .url,
                  height: MediaQuery.of(context).size.height * (1 - 0.1),
                ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: const Text(
                  "Gift Description:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              if (context.read<ServerBloc>().state.assigned(
                      id: widget.assignedId ?? context
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
                            id: widget.assignedId ?? context
                                .read<GameBlock>()
                                .state
                                .assignedId
                                .toString())!
                        .description,
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
                  if(widget.assignedId != null){
                    setState((){
                      isOverTarget = false;
                    });
                    dispose();
                  }else {
                    Navigator.of(context).pop();
                  }
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
