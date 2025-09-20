import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';

class OnboardWidget extends StatefulWidget {
  const OnboardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.isLastScreen,
  });

  final String image;
  final String title;
  final String description;
  final bool? isLastScreen;

  @override
  State<OnboardWidget> createState() => _OnboardWidgetState();
}

class _OnboardWidgetState extends State<OnboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 28.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(
          spacing: 50,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(widget.image, height: 367),
            ),

            Column(
              spacing: 10,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: AppConstants.fontWeightBold,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Text(
                    textAlign: TextAlign.center,
                    widget.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: AppConstants.fontWeightLight,
                      fontSize: AppConstants.fontSizeMedium,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                //display button when the screen is the last
                widget.isLastScreen == true
                    ? CustomButtonWidget(
                      onPressed: () {},
                      buttonTitle: "Let's Start",
                    )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
