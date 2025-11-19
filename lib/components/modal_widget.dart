import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:bexie_mart/components/elevated_button_widget.dart';

class ModalWidget extends StatelessWidget {
  ModalWidget({
    super.key,
    required this.title,
    required this.description,
    this.buttonTitle = '',
    this.buttonAction,
    this.isSuccessModal = true,
    this.requiresActionButton = true,
  });

  final String title;
  final String description;
  String buttonTitle = '';
  final Function()? buttonAction;
  final bool isSuccessModal;
  bool requiresActionButton = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Padding(
            // Extra top padding to make space for the floating badge icon
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: AppConstants.fontWeightMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: AppConstants.fontWeightRegular,
                  ),
                ),
                const SizedBox(height: 20),
                requiresActionButton
                    ? CustomButtonWidget(
                      buttonTitle: buttonTitle,
                      onPressed: buttonAction,
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Positioned(
          top: 300,
          child: Material(
            elevation: 6,
            shape: const CircleBorder(),
            color: AppConstants.backgroundColor,
            child: SizedBox(
              width: 60,
              height: 60,
              child: Icon(
                isSuccessModal
                    ? AppConstants.checkedCircleIcon
                    : AppConstants.errorIcon,
                size: 36,
                color:
                    isSuccessModal
                        ? AppConstants.primaryColor
                        : AppConstants.errorColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
