import 'package:flutter/material.dart';
import 'package:test_game/game/data/models/assign.dart';
import 'package:test_game/game/ui/game.dart';

class TaskViewWidget extends StatefulWidget {
  final AssignModel title;
  final int levelName;

  const TaskViewWidget({Key? key, required this.title, required this.levelName})
      : super(key: key);

  @override
  State<TaskViewWidget> createState() => _TaskViewWidgetState();
}

class _TaskViewWidgetState extends State<TaskViewWidget> {
  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                GameHome(levelName: widget.levelName, assignedId: widget.title.id,),
            fullscreenDialog: true,
          ),
        );
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
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        widget.title.title,
                        style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.white),
                      ),
                      // Text(
                      //   widget.title.description,
                      //   style:
                      //   const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      // )
                    ],
                  ),
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
          child: actionButton(expand ? Icons.close : Icons.add, color: expand ? Colors.white : Colors.white),
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
