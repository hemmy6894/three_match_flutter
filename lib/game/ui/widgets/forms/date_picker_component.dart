import 'package:flutter/material.dart';
import 'package:test_game/common/helpers/three.dart';
import 'package:test_game/common/helpers/validation.dart';

class DatePickerComponent extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final DateTime? initialValue;
  final DateTime? stateValue;
  final Function(DateTime?) onSave;
  final Function(DateTime?) onChange;
  final String validate;
  final bool isLoading;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final Icon? prefixIcon;
  final String? label;
  final Color? prefixIconColor;
  const DatePickerComponent(
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
      required this.onChange,
      this.isLoading = false,
      this.validate = "",
      this.obscureText = false})
      : super(key: key);

  @override
  _DatePickerComponentState createState() => _DatePickerComponentState();
}

class _DatePickerComponentState extends State<DatePickerComponent> {
  TextEditingController? controller;
  late DateTime dateSelected;
  late String inTime = "";
  @override
  void initState() {
    controller = TextEditingController(text: inTime);
    dateSelected = DateTime.now();
    inTime = ThreeMatchHelper.dateFormat(dateTime: dateSelected);
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              )
            : Container(),
        Container(
          margin: const EdgeInsets.all(2),
          child: TextFormField(
            controller: controller,
            minLines: widget.minLines,
            readOnly: true,
            // initialValue: inTime,
            maxLines: widget.maxLines,
            obscureText: widget.obscureText,
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () async {
                  final DateTime? selectedDateFromUser = await showDatePicker(
                      context: context,
                      initialDate: dateSelected,
                      firstDate:
                          DateTime.now().add(const Duration(days: -(365 * 10))),
                      lastDate:
                          DateTime.now().add(const Duration(days: (365 * 10))),
                      selectableDayPredicate: (DateTime date) {
                        return true;
                      });

                  if (selectedDateFromUser != null &&
                      selectedDateFromUser != dateSelected) {
                    setState(() {
                      dateSelected = selectedDateFromUser;
                      inTime = ThreeMatchHelper.dateFormat(dateTime: dateSelected);;
                      controller = TextEditingController(text: inTime);
                    });

                    widget.onChange(dateSelected);
                  }
                },
                child: const Icon(Icons.calendar_month),
              ),
              prefixIconColor: widget.prefixIconColor,
              filled: true,
              hintText: widget.hintText,
              errorText: widget.errorText,
            ),
            onSaved: (String? value) {
              widget.onSave(DateTime.tryParse(value!));
            },
            onChanged: (value) {
              widget.onChange(DateTime.tryParse(value));
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
