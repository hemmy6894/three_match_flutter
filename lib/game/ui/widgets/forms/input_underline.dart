import 'package:flutter/material.dart';
import 'package:test_game/common/helpers/validation.dart';

class InputUnderLineComponent extends StatelessWidget {
  final String hintText;
  final String? errorText;
  final Function onSave;
  final Function onChange;
  final String validate;
  final bool isLoading;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final Icon? prefixIcon;
  final Color? prefixIconColor;
  const InputUnderLineComponent(
      {Key? key,
      this.hintText = "",
      this.errorText,
      this.maxLines = 1,
      this.minLines = 1,
      this.prefixIcon,
      this.prefixIconColor,
      required this.onSave,
      required this.onChange,
      this.isLoading = false,
      this.validate = "",
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: TextFormField(
        minLines: minLines,
        maxLines: maxLines,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor,
          filled: true,
          fillColor: Colors.grey,
          hintText: hintText,
          errorText: errorText,
          // labelText: 'Email',
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onSaved: (String? value) {
          onSave(value);
        },
        onChanged: (value) {
          onChange(value);
        },
        validator: (String? value) {
          return Validation.validate(validate, value);
        },
      ),
    );
  }
}
