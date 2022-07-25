import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/widgets/forms/date_picker_component.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';

class RankWidget extends StatefulWidget {
  const RankWidget({Key? key}) : super(key: key);

  @override
  State<RankWidget> createState() => _RankWidgetState();
}

class _RankWidgetState extends State<RankWidget> {
  PlatformFile? myFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox( height: MediaQuery.of(context).size.height * 0.05,),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Enter User Rank", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30),)
            ],
          ),
        ),
        SizedBox( height: MediaQuery.of(context).size.height * 0.10,),
        InputComponent(
          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
          onSave: () {},
          onChange: (value) {
            context.read<ServerBloc>().add(
                  ServerPutPayload(
                    value: value,
                    key: "rank",
                  ),
                );
          },
          hintText: "Enter win rank",
        ),
      ],
    );
  }
}
