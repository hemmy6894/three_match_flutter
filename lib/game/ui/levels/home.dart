import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/levels/widget/header.dart';
import 'package:test_game/game/ui/levels/widget/life_count.dart';
import 'package:test_game/game/ui/levels/widget/task.dart';
import 'package:test_game/game/ui/task/widgets/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> items = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Container(
        color: Colors.blueGrey,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return TaskPage(title: "Task ${index + 1}", levelName: index + 1);
          },
        ),
      ),
    );
  }
}
