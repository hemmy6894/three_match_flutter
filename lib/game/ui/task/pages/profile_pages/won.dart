import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/task/pages/all_task.dart';
import 'package:test_game/game/ui/task/pages/assign.dart';

class UserWonTask extends StatefulWidget {
  const UserWonTask({Key? key}) : super(key: key);

  @override
  State<UserWonTask> createState() => _UserWonTaskState();
}

class _UserWonTaskState extends State<UserWonTask> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Stack(
        children: const [
          AllSignedTask(getType: "won",),
          Positioned(
            right: 10,
            child: CloseButton(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
