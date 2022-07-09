import 'package:flutter/material.dart';
import 'package:test_game/common/helpers/validation.dart';

class InputComponent extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final dynamic initialValue;
  final dynamic stateValue;
  final Function onSave;
  final Function? onTap;
  final Function(dynamic) onChange;
  final String validate;
  final bool isLoading;
  final bool obscureText;
  final bool readOnly;
  final int minLines;
  final int maxLines;
  final Widget? prefixIcon;
  final String? label;
  final Color? prefixIconColor;
  final Color? labelColor;

  const InputComponent(
      {Key? key,
      this.hintText = "",
      this.errorText,
      this.maxLines = 1,
      this.label,
      this.minLines = 1,
      this.initialValue,
      this.stateValue,
      this.prefixIcon,
      this.prefixIconColor,
      required this.onSave,
      this.onTap,
      this.readOnly = false,
      required this.onChange,
      this.isLoading = false,
      this.validate = "",
      this.labelColor = Colors.white,
      this.obscureText = false})
      : super(key: key);

  @override
  _InputComponentState createState() => _InputComponentState();
}

class _InputComponentState extends State<InputComponent> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text:
            widget.initialValue != null ? widget.initialValue.toString() : "");
    if (widget.initialValue != null &&
        widget.initialValue != widget.stateValue) {
      widget.onChange(widget.initialValue);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Padding(
                padding: const EdgeInsets.only(left: 6, top: 3),
                child: Text(widget.label!,
                    style: TextStyle(
                        color: widget.labelColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )
            : Container(),
        Container(
          margin: const EdgeInsets.all(2),
          child: TextFormField(
            controller: _controller,
            minLines: widget.minLines,
            // ignore: prefer_null_aware_operators
            // initialValue: widget.initialVagit
            maxLines: widget.maxLines,
            obscureText: widget.obscureText,
            readOnly: widget.readOnly,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Colors.black.withAlpha(990),
                  fontSize: 16,
                ),
            decoration: InputDecoration(
              // prefixIcon: widget.prefixIcon,
              suffixIcon: widget.prefixIcon,
              prefixIconColor: widget.prefixIconColor,
              hintText: widget.hintText,
              labelText: widget.hintText,
              errorText: widget.errorText,
            ),
            onSaved: (dynamic value) {
              widget.onSave(value);
            },
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            onChanged: (dynamic value) {
              widget.onChange(value);
            },
            validator: (String? value) {
              return Validation.validate(widget.validate, value);
            },
          ),
        ),
      ],
    );
  }
}
