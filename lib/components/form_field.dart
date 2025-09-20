import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.suffixIcon,
    this.isPassword = false,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onChanged,
    this.formKey,
  });

  final String labelText;
  final String hintText;
  final IconData? suffixIcon;
  final bool isPassword;
  final Function()? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onChanged;
  final GlobalKey<FormState>? formKey;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          TextFormField(
            validator: widget.validator,
            onChanged: widget.onChanged,
            controller: widget.controller,
            obscureText: widget.isPassword,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
                borderRadius: BorderRadius.circular(12),
              ),
              labelText: widget.labelText,
              hintText: widget.hintText,
              fillColor: AppConstants.greyedColor.withAlpha(50),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(widget.suffixIcon),
                onPressed: widget.onSuffixIconPressed,
              ),
              suffixIconColor: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
