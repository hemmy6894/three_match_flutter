import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/data/models/task.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/task/pages/widgets/gift.dart';
import 'package:test_game/game/ui/task/pages/widgets/search.dart';
import 'package:test_game/game/ui/task/pages/widgets/search_task.dart';

class AssignTask extends StatefulWidget {
  final Function(int) taped;
  const AssignTask({Key? key, required this.taped}) : super(key: key);

  @override
  State<AssignTask> createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  List<PhoneModel> friends = [];
  List<TaskModel> tasks = [];
  late PhoneModel selectedUser;
  late TaskModel selectedTask;
  int _currentStep = 0;

  @override
  initState() {
    selectedUser = PhoneModel.empty();
    selectedTask = TaskModel.empty();
    context.read<ServerBloc>().add(PullFriendEvent());
    context.read<ServerBloc>().add(PullTaskEvent());
    friends = context.read<ServerBloc>().state.friends;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ServerBloc, ServerState>(
            listenWhen: (previous, current) =>
                previous.friends != current.friends,
            listener: (context, state) {
              setState(() {
                friends = state.friends;
              });
            },
          ),
          BlocListener<ServerBloc, ServerState>(
            listenWhen: (previous, current) => previous.tasks != current.tasks,
            listener: (context, state) {
              setState(() {
                tasks = state.tasks;
              });
            },
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _selectUser(),
            _selectTask(),
            _enterPrize(),
          ],
        ),
      ),
    );
  }

  Widget _selectUser() {
    if (_currentStep == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchUser(
            friends: friends,
            clicked: (phone) {
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: phone.id, key: "user_id"));
              setState(() {
                selectedUser = phone;
              });
            },
          ),
          if (selectedUser != PhoneModel.empty())
            Row(
              children: [
                const Text("SELECTED: "),
                SearchUser.selectedUser(friend: selectedUser),
              ],
            ),
          nextButton()
        ],
      );
    }
    return Container();
  }

  Widget _selectTask() {
    if (_currentStep == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchTask(
            tasks: tasks,
            clicked: (task) {
              context
                  .read<ServerBloc>()
                  .add(ServerPutPayload(value: task.id, key: "task_id"));
              setState(() {
                selectedTask = task;
              });
            },
          ),
          if (selectedTask != TaskModel.empty())
            Row(
              children: [
                const Text("SELECTED: "),
                SearchTask.selected(task: selectedTask),
              ],
            ),
          Row(
            children: [
              nextButton(),
              backButton(),
            ],
          )
        ],
      );
    }
    return Container();
  }

  Widget _enterPrize() {
    if (_currentStep == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GiftWidget(),
          Row(
            children: [
              backButton(),
              saveButton(),
            ],
          ),
        ],
      );
    }
    return Container();
  }

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        setState(
          () {
            _currentStep++;
          },
        );
      },
      child: const Text(
        "Next",
      ),
    );
  }

  bool isLoading = false;
  bool clicked = false;
  Widget saveButton() {
    return ElevatedButton(
      onPressed: () {
        setState(
          () {
            context.read<ServerBloc>().add(AssignTaskEvent());
            clicked = true;
          },
        );
      },
      child: BlocListener<ServerBloc,ServerState>(
        listenWhen: (previous,current) => previous.logging != current.logging,
        listener: (context, state) {
          if(!isLoading && clicked){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Assigned Success"),
              ),
            );
            widget.taped(0);
          }
          setState(() {
            isLoading = state.logging;
          });
        },
        child: isLoading ? const SizedBox(width: 15,height: 15, child: CircularProgressIndicator()) : const Text(
          "Save",
        ),
      ),
    );
  }


  Widget backButton() {
    return TextButton(
      onPressed: () {
        setState(
          () {
            _currentStep--;
          },
        );
      },
      child: const Text(
        "Back",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
