import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.suffixIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onSuffixIconPressed,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onChanged,
    this.formKey,
    this.maxLines = 1,
  });

  final String labelText;
  final String hintText;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool? isPasswordVisible;
  final Function()? onSuffixIconPressed;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Function(String?)? onChanged;
  final GlobalKey<FormState>? formKey;
  final int maxLines;

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
            obscureText: widget.isPassword && !widget.isPasswordVisible!,
            keyboardType: widget.keyboardType,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
                borderRadius: BorderRadius.circular(16),
              ),
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: AppConstants.textColor.withAlpha(90),
              ),
              hintStyle: TextStyle(color: AppConstants.textColor.withAlpha(90)),
              hintText: widget.hintText,
              fillColor: AppConstants.greyedColor.withAlpha(70),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  widget.suffixIcon,
                  color: AppConstants.textColor.withAlpha(190),
                  fill: 0,
                  weight: 1,
                ),
                onPressed: widget.onSuffixIconPressed,
              ),
              suffixIconColor: AppConstants.textColor.withAlpha(190),
            ),
          ),
        ],
      ),
    );
  }
}
