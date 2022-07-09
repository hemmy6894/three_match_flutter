import 'package:flutter/material.dart';
import 'package:test_game/game/data/models/country.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';

class SearchCountry extends StatefulWidget {
  final List<CountryModel> countries;
  final Function(CountryModel) clicked;


  const SearchCountry({Key? key, required this.countries, required this.clicked})
      : super(key: key);

  static Widget selected({required CountryModel country}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Text(
        country.name,
        style: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  State<SearchCountry> createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry> {
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
                Text("Select Country", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30),)
              ],
            ),
          ),
          SizedBox( height: MediaQuery.of(context).size.height * 0.10,),
          InputComponent(
            hintText: "Search country",
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
      for (var country in widget.countries) {
        if (country.name.toLowerCase().contains(search.toLowerCase()) ||
            country.name.toLowerCase().contains(search.toLowerCase())) {
          w.add(singleCountryView(country: country));
        }
      }
    }
    return w;
  }

  Widget singleCountryView({required CountryModel country}) {
    return GestureDetector(
      onTap: () {
        widget.clicked(country);
        setState(() {
          ratio = 0.3;
          search = "";
        });
      },
      child: SearchCountry.selected(country: country),
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
