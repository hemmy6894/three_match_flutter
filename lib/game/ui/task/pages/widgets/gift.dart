import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_game/game/logic/server/server_bloc.dart';
import 'package:test_game/game/ui/widgets/forms/date_picker_component.dart';
import 'package:test_game/game/ui/widgets/forms/input_component.dart';

class GiftWidget extends StatefulWidget {
  final Function(PlatformFile? file) getFilet;
  const GiftWidget({Key? key,required this.getFilet}) : super(key: key);

  @override
  State<GiftWidget> createState() => _GiftWidgetState();
}

class _GiftWidgetState extends State<GiftWidget> {
  PlatformFile? myFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputComponent(
          onSave: () {},
          onChange: (value) {
            context.read<ServerBloc>().add(
                  ServerPutPayload(
                    value: value,
                    key: "title",
                  ),
                );
          },
          hintText: "Enter Task Title",
        ),
        if (myFile != null)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Image.memory(myFile!.bytes!),
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              dialogTitle: "Choose Photo(s)",
              withData: true,
              type: FileType.image,
            );
            if (result != null) {
              for (PlatformFile pf in result.files) {
                widget.getFilet(pf);
                setState(
                  () {
                    myFile = pf;
                  },
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),
                      child: Text(
                        "Select Photo",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 17,
                            ),
                      ),
                    ),
                    const Icon(
                      Icons.image,
                      color: Colors.black,
                      size: 25,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.black,
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                )
              ],
            ),
          ),
        ),
        InputComponent(
          onSave: () {},
          onChange: (value) {
            context.read<ServerBloc>().add(
              ServerPutPayload(
                value: value,
                key: "description",
              ),
            );
          },
          hintText: "Enter Photo Description",
          minLines: 4,
          maxLines: 5,
        ),
        DatePickerComponent(
          hintText: "Select start date",
          onSave: (d) {},
          onChange: (value) {
            context.read<ServerBloc>().add(
                  ServerPutPayload(
                    value: value,
                    key: "start_at",
                  ),
                );
          },
        ),
        DatePickerComponent(
          hintText: "Select end date",
          onSave: (d) {},
          onChange: (value) {
            context.read<ServerBloc>().add(
                  ServerPutPayload(
                    value: value,
                    key: "end_at",
                  ),
                );
          },
        ),
      ],
    );
  }
}
