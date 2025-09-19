import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.buttonTitle,
    this.isLoading = false,
    this.onPressed,
  });

  final String buttonTitle;
  final bool isLoading;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), //do not nest scaffolds
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : Text(buttonTitle),
    );
  }
}
