import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/levels/widget/header.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';
import 'package:test_game/game/ui/levels/widget/task.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return AppLayout(child: Container(
      color: Colors.blueGrey,
      child: Stack(
        children: [
          const LiveCount(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10,),
              const TitleBar(),
              const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                    TaskButton(title: "Task 1",levelName: 1,),
                    TaskButton(title: "Task 2", levelName: 2,),
                    TaskButton(title: "Task 3",levelName: 3,),
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  TaskButton(title: "Task 4",levelName: 4,),
                  TaskButton(title: "Task 5",levelName: 5,),
                ],
              )
            ],
          ),
        ],
      ),
    ));
  }
}
