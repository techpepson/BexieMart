import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                    flex: 2,
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
                            textAlign: TextAlign.center,
                            "BexieMart",
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: AppConstants.fontWeightMedium,
                              fontSize: 52,
                              letterSpacing: -0.52,
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: 249,
                            height: 59,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Shop Smart, Live Easy - Your Campus Marketplace",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 19,
                                fontFamily: AppConstants.fontFamilyNunito,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //button display
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 330,
                        height: 54,
                        child: CustomButtonWidget(
                          buttonTitle: "Get Started",
                          isLoading: false,
                          onPressed: () {
                            context.push('/register');
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12, left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "I already have an account",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                fontFamily: AppConstants.fontFamilyNunito,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.push('/login');
                              },
                              child: Icon(
                                AppConstants.forwardArrowIcon,
                                color: AppConstants.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 64),
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
