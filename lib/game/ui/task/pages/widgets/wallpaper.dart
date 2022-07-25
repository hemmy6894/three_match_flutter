import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
class WallpaperWidget extends StatefulWidget {
  final Function(PlatformFile? file) getFilet;
  const WallpaperWidget({Key? key,required this.getFilet}) : super(key: key);

  @override
  State<WallpaperWidget> createState() => _WallpaperWidgetState();
}

class _WallpaperWidgetState extends State<WallpaperWidget> {
  PlatformFile? myFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (myFile != null)
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Image.memory(myFile!.bytes!),
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              dialogTitle: "Choose Wallpaper(s)",
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
                        "Select Wallpaper",
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
      ],
    );
  }
}
