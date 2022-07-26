import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:test_game/common/assets.dart';
import 'package:test_game/game/data/models/assign.dart';
import 'package:test_game/game/data/models/task.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/task/pages/widgets/task.dart';

class GameHomePage extends StatefulWidget {
  const GameHomePage({Key? key}) : super(key: key);

  @override
  State<GameHomePage> createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  List<AssignModel> assigns = [];
  List<Widget> widgets = [];
  bool loading = true;

  @override
  initState() {
    context.read<ServerBloc>().add(ServerDestroyPayload());
    context.read<ServerBloc>().add(PullAssignmentEvent());
    requestPermissionContact();
    super.initState();
  }

  requestPermissionContact() async {
    await FlutterContacts.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerBloc, ServerState>(
      listenWhen: (previous, current) => previous.assigns != current.assigns,
      listener: (context, state) {
        setState(() {
          loading = false;
          for (AssignModel assign in state.assigns) {
            if (assign.task != TaskModel.empty()) {
              widgets.add(
                TaskViewWidget(
                  title: assign,
                  levelName: int.parse(assign.task.label),
                ),
              );
            }
          }
        });
      },
      child: loading
          ? Center(
              child: Image.asset(
                Assets.logoGif,
                width: MediaQuery.of(context).size.width * 0.4,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              color: Colors.white,
              child: widgets.isEmpty
                  ? const Center(
                      child: Text(
                        "No task found",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                    )
                  : CarouselSlider(
                      items: widgets,
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.easeIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.vertical,
                      ))),
    );
  }
}
