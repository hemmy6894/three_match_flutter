import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:test_game/game/ui/layouts/app.dart';
import 'package:test_game/game/ui/task/widgets/task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> items = [1, 2, 3, 4, 5];
  List<Widget> widgets = [];

  @override
  initState(){
    for(int index in items){
      widgets.add(TaskPage(title: "Task $index", levelName: index));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Container(
        color: Colors.blueGrey,
        child: CarouselSlider(
            items: widgets,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              aspectRatio: 16/9,
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
            )
        )
      ),
    );
  }
}
