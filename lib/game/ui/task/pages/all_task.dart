import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/data/models/assign.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/task/pages/widgets/task.dart';
import 'package:test_game/game/ui/task/widgets/task_page.dart';

class AllSignedTask extends StatefulWidget {
  const AllSignedTask({Key? key}) : super(key: key);

  @override
  State<AllSignedTask> createState() => _AllSignedTaskState();
}

class _AllSignedTaskState extends State<AllSignedTask> {
  List<AssignModel> assigns = [];
  List<Widget> widgets = [];

  @override
  initState() {
    context.read<ServerBloc>().add(ServerDestroyPayload());
    context
        .read<ServerBloc>()
        .add(ServerPutPayload(value: "user", key: "type"));
    context.read<ServerBloc>().add(PullAssignmentEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerBloc, ServerState>(
      listenWhen: (previous, current) => previous.assigns != current.assigns,
      listener: (context, state) {
        setState(() {
          for (AssignModel assign in state.assigns) {
            if (assign.type != "company") {
              widgets.add(
                TaskViewWidget(
                  title: assign,
                  levelName: int.parse(
                    assign.task.label,
                  ),
                ),
              );
            }
          }
        });
      },
      child: Container(
          color: Colors.blueGrey,
          child: CarouselSlider(
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
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.vertical,
              ))),
    );
  }
}
