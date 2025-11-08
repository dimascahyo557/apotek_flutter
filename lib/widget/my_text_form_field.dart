import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? Function(String?)? validator;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final bool obscureText;

  const MyTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.validator,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Variables.colorMuted, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Variables.colorMuted, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Variables.colorDanger, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Variables.colorDanger, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: widget.validator,
    );
  }
}