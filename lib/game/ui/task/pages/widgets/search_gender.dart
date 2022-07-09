import 'package:flutter/material.dart';
import 'package:test_game/game/data/models/gender.dart';
import 'package:test_game/game/data/models/phone.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';

class SearchGender extends StatefulWidget {
  final List<GenderModel> genders;
  final Function(GenderModel) clicked;


  const SearchGender({Key? key, required this.genders, required this.clicked})
      : super(key: key);

  static Widget selected({required GenderModel gender}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Text(
        gender.name,
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  State<SearchGender> createState() => _SearchGenderState();
}

class _SearchGenderState extends State<SearchGender> {
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
          SizedBox( height: MediaQuery.of(context).size.height * 0.05,),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Select Gender", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30),)
              ],
            ),
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.10,),
          InputComponent(
            hintText: "Search gender",
            onSave: () {},
            onChange: (v) {
              setState(
                () {
                  search = v;
                  if (search != "") {
                    ratio = 0.38;
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
      for (var gender in widget.genders) {
        if (gender.name.toLowerCase().contains(search.toLowerCase()) ||
            gender.name.toLowerCase().contains(search.toLowerCase())) {
          w.add(singleGenderView(gender: gender));
        }
      }
    }
    return w;
  }

  Widget singleGenderView({required GenderModel gender}) {
    return GestureDetector(
      onTap: () {
        widget.clicked(gender);
        setState(() {
          ratio = 0.3;
          search = "";
        });
      },
      child: SearchGender.selected(gender: gender),
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
