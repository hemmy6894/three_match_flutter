// import 'package:flutter/material.dart';
// import 'package:mkondo_app_new/mkondo/ui/mkondo/widgets/forms/input_component.dart';

// class EmailInput extends StatefulWidget {
//   final String hintText;
//   final Function? onSave;
//   final Function? onChange;
//   final String validate;
//   final bool isLoading;
//   final bool obscureText;
//   const EmailInput(
//       {Key? key,
//       this.hintText = "Email",
//       this.onSave,
//       this.onChange,
//       this.isLoading = false,
//       this.validate = "email",
//       this.obscureText = false})
//       : super(key: key);
//   @override
//   State<EmailInput> createState() => _EmailInputState();
// }

// class _EmailInputState extends State<EmailInput> {
//   @override
//   Widget build(BuildContext context) {
//     return InputComponent(
//               hintText: widget.hintText,
//               onSave: (String? value) => print("object"),
//               onChange: (value) => context
//                   .read<AuthBloc>()
//                   .add(AuthEventPutPayload(value: value, key: "email")),
//               validate: "email");
//   }
// }