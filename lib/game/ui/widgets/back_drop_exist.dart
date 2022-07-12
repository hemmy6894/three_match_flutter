import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/logic/ui/ui_cubit.dart';
import 'package:test_game/game/ui/widgets/forms/button_component.dart';

class BackDropExit extends StatefulWidget {
  final Function(bool) cancel;

  const BackDropExit({Key? key, required this.cancel}) : super(key: key);

  @override
  State<BackDropExit> createState() => _BackDropExitState();
}

class _BackDropExitState extends State<BackDropExit> {
  @override
  Widget build(BuildContext context) {
    return backDropExist();
  }

  Widget backDropExist() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey.withOpacity(0.5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Color(Assets.primaryTargetBackgroundColor),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.28,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "You will lose life!!",
                  style: TextStyle(
                      color: Color(Assets.primaryBlueColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ButtonComponent(title: "Quit", onPressed: () {
                    context.read<UiCubit>().decrementLife();
                    Navigator.of(context).pop();
                  }, mainAxisAlignment: MainAxisAlignment.center, backgroundColor: Assets.redColors,),
                )
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              color: const Color(Assets.primaryBlueColor).withOpacity(0.95),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: const Color(Assets.primaryGoldColor),
                  ),
                  const Text(
                    "Quit Task?",
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Container(
                    height: 3,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: const Color(Assets.primaryGoldColor),
                  ),
                  const SizedBox(
                    height: 3,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.31,
            right: MediaQuery.of(context).size.width * 0.1,
            child: GestureDetector(
              onTap: () {
                widget.cancel(false);
              },
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
