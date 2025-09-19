import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import "dart:developer" as dev;

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              AppConstants.appLogo,
                              width: 100,
                              height: 100,
                            ),
                          ),
                          Text(
                            "BexieMart",
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: AppConstants.fontWeightMedium,
                              fontSize: 40,
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: 200,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Shop Smart, Live Easy - Your Campus Marketplace",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: AppConstants.fontWeightMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //button display
                  Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: CustomButtonWidget(
                          buttonTitle: "Get Started",
                          isLoading: false,
                          onPressed: () {},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("I already have an account"),
                            TextButton(
                              onPressed: () {},
                              child: Icon(
                                AppConstants.forwardArrowIcon,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
