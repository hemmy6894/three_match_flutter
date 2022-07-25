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
  final bool withTime;
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
      this.withTime = false})
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
            style: const TextStyle(fontSize: 18.0, color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () async {
                  final DateTime? selectedDateFromUser = await showDatePicker(
                      context: context,
                      initialDate: dateSelected,
                      firstDate:
                          DateTime.now().add(const Duration(days: -(365 * 0))),
                      lastDate:
                          DateTime.now().add(const Duration(days: (365 * 10))),
                      selectableDayPredicate: (DateTime date) {
                        return true;
                      });

                  if (selectedDateFromUser != null &&
                      selectedDateFromUser != dateSelected) {
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime:  TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
                    );

                    if(newTime != null) {
                      setState(() {
                        String m = selectedDateFromUser.month<10 ? ("0"+selectedDateFromUser.month.toString()) : selectedDateFromUser.month.toString();
                        String d = selectedDateFromUser.day<10 ? ("0"+selectedDateFromUser.day.toString()) : selectedDateFromUser.day.toString();
                        String h = newTime.hour<10 ? ("0"+newTime.hour.toString()) : newTime.hour.toString();
                        String min = newTime.minute<10 ? ("0"+newTime.minute.toString()) : newTime.minute.toString();
                        String formDate = "${selectedDateFromUser.year}-$m-$d $h:$min:00";
                        DateTime myViewTime = DateTime.parse(formDate);
                        dateSelected = myViewTime;
                        inTime = ThreeMatchHelper.dateFormat(dateTime: dateSelected, format: "yyyy-MM-dd HH:mm:00");
                        controller = TextEditingController(text: inTime);
                      });
                    }
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
