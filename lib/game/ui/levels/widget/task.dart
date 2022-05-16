import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/game/game_bloc.dart';
import 'package:test_game/game/ui/game.dart';

class TaskButton extends StatefulWidget {
  final String title;
  final int levelName;
  const TaskButton({Key? key, required this.title, required this.levelName}) : super(key: key);
  @override
  State<TaskButton> createState() => _TaskButtonState();
}

class _TaskButtonState extends State<TaskButton> {
  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  GameHome(levelName: widget.levelName),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular((mySize.width / 12))),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3) ,
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        alignment: Alignment.center,
        height: mySize.width / 8,
        width: mySize.width / 3.3,
        child: Text(
          widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
