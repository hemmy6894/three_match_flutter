import 'package:flutter/material.dart';

class CheckboxComponent extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final bool initialValue;
  final Function onSave;
  final Function onChange;
  final String validate;
  final bool isLoading;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final Icon? prefixIcon;
  final Color? prefixIconColor;
  const CheckboxComponent(
      {Key? key,
      this.hintText = "",
      this.errorText,
      this.maxLines = 1,
      this.minLines = 1,
      this.initialValue = false,
      this.prefixIcon,
      this.prefixIconColor,
      required this.onSave,
      required this.onChange,
      this.isLoading = false,
      this.validate = "",
      this.obscureText = false})
      : super(key: key);

  @override
  _CheckboxComponentState createState() => _CheckboxComponentState();
}

class _CheckboxComponentState extends State<CheckboxComponent> {
  late  bool isChecked;
  @override
  void initState() {
    isChecked = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = !isChecked;
              widget.onChange(isChecked);
            });
          },
        ),
        Expanded(
            child: Text(widget.hintText,
                style: const TextStyle(color: Colors.white, fontSize: 14)))
      ],
    );
  }
}
