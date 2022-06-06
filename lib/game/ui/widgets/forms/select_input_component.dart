import 'package:flutter/material.dart';
import 'package:test_game/common/assets.dart';

class SelectInputComponent extends StatefulWidget {
  final Map<String, dynamic> items;
  final String hintText;
  final dynamic errorText;
  final String? initialValue;
  final Function onSave;
  final Function onChange;
  final String validate;
  final bool isLoading;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final Icon? prefixIcon;
  final String? label;
  final Color? prefixIconColor;
  const SelectInputComponent(
      {Key? key,
      this.hintText = "",
      this.errorText,
      this.maxLines = 1,
      this.minLines = 1,
      this.initialValue,
      this.prefixIcon,
      this.prefixIconColor,
      required this.onSave,
      required this.onChange,
      this.label,
      this.isLoading = false,
      this.validate = "",
      required this.items,
      this.obscureText = false})
      : super(key: key);

  @override
  _SelectInputComponentState createState() => _SelectInputComponentState();
}

class _SelectInputComponentState extends State<SelectInputComponent> {
  late List<String> keys = [];
  String? initial;
  @override
  void initState() {
    initial = widget.initialValue;
    for (var item in widget.items.keys) {
      keys.add(item);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool saveError = false;
    if (widget.errorText != "" && widget.errorText != null) {
      saveError = true;
    } else {
      saveError = false;
    }
    return Container(
      decoration: BoxDecoration(
        border: saveError ? Border.all(
            color: Colors.red,
            width: 1
        ) : null,
      ),
      child: Column(
        mainAxisAlignment:  MainAxisAlignment.start,
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          widget.label != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 6, top: 3),
                  child: Text(widget.label!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )
              : Container(),
          DropdownButton<String>(
            isExpanded: true,
            autofocus: true,
            hint: Text(
              widget.hintText,
              style: const TextStyle(color: Colors.white),
            ),
            // value: initial,
            icon: const Icon(Icons.arrow_downward,
                color: Color(Assets.primaryColor)),
            elevation: 16,
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: const Color(Assets.primaryColor),
            ),
            onChanged: (String? newValue) {
              widget.onChange(newValue);
              setState(() {
                initial = newValue;
              });
            },
            items: keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(widget.items[value],
                    style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
          ),
          saveError
              ? Text(
            widget.errorText ?? "",
            style: TextStyle(color: Colors.red, fontSize: 12),
          )
              : Container(),
        ],
      ),
    );
  }
}
