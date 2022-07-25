import 'package:flutter/material.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/task/pages/all_task.dart';
import 'package:test_game/game/ui/task/pages/assign.dart';

class UserAssignedTask extends StatefulWidget {
  const UserAssignedTask({Key? key}) : super(key: key);

  @override
  State<UserAssignedTask> createState() => _UserAssignedTaskState();
}

class _UserAssignedTaskState extends State<UserAssignedTask> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Stack(
        children: const [
          AllSignedTask(),
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
