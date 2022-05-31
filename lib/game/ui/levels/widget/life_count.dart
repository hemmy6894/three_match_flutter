import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';

class LiveCount extends StatefulWidget {
  const LiveCount({Key? key}) : super(key: key);

  @override
  State<LiveCount> createState() => _LiveCountState();
}

class _LiveCountState extends State<LiveCount> {
  int liveCount = 0;
  int fullLives = 0;
  int remainingTime = 0;

  @override
  void initState() {
    liveCount = context.read<UiCubit>().state.lastLifeCount;
    fullLives = context.read<UiCubit>().state.fullLiveCount;
    remainingTime = context.read<UiCubit>().state.remainingTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UiCubit, UiState>(
      listenWhen: (previous, current) =>
          previous.remainingTime != current.remainingTime,
      listener: (context, state) {
        setState(() {
          liveCount = state.lastLifeCount;
          fullLives = state.fullLiveCount;
          remainingTime = state.remainingTime;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width * 0.016)),
            // border: Border.all(color: Colors.black, width: 1)
            color: Colors.white),
        margin: const EdgeInsets.all(3),
        width: MediaQuery.of(context).size.width * (liveCount < fullLives ?  0.17 : 0.07),
        height: MediaQuery.of(context).size.height * 0.03,
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.orange,
                ),
                Text(
                  liveCount.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
            if(liveCount < fullLives)
              Expanded(
                child: Text(" " +Helpers.getTimeInMinutes(remainingTime ~/ 1000)),
              )

            // for (int i = 0; i < fullLives; i++)
            //   if (i < liveCount)
            //     Container(
            //       color: Colors.red,
            //       width: MediaQuery.of(context).size.width * 0.12 / fullLives,
            //       height: MediaQuery.of(context).size.height * 0.03,
            //     )
          ],
        ),
      ),
    );
  }
}
