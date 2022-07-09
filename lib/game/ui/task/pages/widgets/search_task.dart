import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/data/models/task.dart';
import 'package:test_game/game/ui/levels/widget/game_over.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';

class SearchTask extends StatefulWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel) clicked;

  const SearchTask({Key? key, required this.tasks, required this.clicked})
      : super(key: key);

  static Widget selected({required TaskModel task, double width = 0}) {
    Map<String, dynamic> level = Assets.levels[int.parse(task.label)];
    int row = level["row"] ?? 0;
    int col = level["col"] ?? 0;
    int moves = level["moves"] ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                task.name + " Moves: $moves Targets:",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 6,),
              GameOverWidget.displayTarget(
                level["targets"] ?? [],
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.grey.withOpacity(0.3),
            width: width,
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  double ratio = 0.3;
  int i = 0;
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * ratio,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Select Task",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          InputComponent(
            hintText: "Search task",
            onSave: () {},
            onChange: (v) {
              setState(
                () {
                  search = v;
                  if (search != "") {
                    ratio = 0.6;
                  } else {
                    ratio = 0.3;
                  }
                },
              );
            },
            // initialValue: search,
            // stateValue: search,
          ),
          ...displayResults(),
        ],
      ),
    );
  }

  List<Widget> searched() {
    List<Widget> w = [];
    if (search != "") {
      for (var task in widget.tasks) {
        if (task.name.toLowerCase().contains(search.toLowerCase())) {
          w.add(singleTaskView(task: task));
        }
      }
    }
    return w;
  }

  Widget singleTaskView({required TaskModel task}) {
    return GestureDetector(
      onTap: () {
        widget.clicked(task);
        setState(() {
          ratio = 0.3;
          search = "";
        });
      },
      child: SearchTask.selected(
          task: task, width: MediaQuery.of(context).size.width),
    );
  }

  List<Widget> displayResults() {
    List<Widget> displays = [];
    int i = 0;
    for (int i = 0; i < searched().length && i < 2; i++) {
      displays.add(searched()[i]);
    }
    return displays;
  }
}
