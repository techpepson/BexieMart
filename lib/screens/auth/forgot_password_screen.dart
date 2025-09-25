import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String selectedChoice = 'sms';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Back',
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyNunito,
            fontWeight: FontWeight.w500,
            color: AppConstants.textColor,
          ),
        ),
        titleSpacing: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    focalRadius: 10.5,
                    center: Alignment.topRight,
                    tileMode: TileMode.clamp,
                    colors: [
                      AppConstants.gradientBlue,
                      AppConstants.backgroundColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            'Password Recovery',
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge?.copyWith(
                              fontFamily: AppConstants.fontFamilyRaleway,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: 290,
                            height: 57,
                            child: Text(
                              textAlign: TextAlign.center,
                              'How would you like to recover your password?',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontFamily: AppConstants.fontFamilyNunito,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //sms and email options
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedChoice = 'sms';
                          });
                        },
                        child: Container(
                          width: 199,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(18),
                            color:
                                selectedChoice == 'sms'
                                    ? AppConstants.fadedBlue
                                    : AppConstants.fadedRed,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                textAlign: TextAlign.center,
                                'SMS',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontFamily: AppConstants.fontFamilyRaleway,
                                  fontSize: 16,
                                  color:
                                      selectedChoice == 'sms'
                                          ? AppConstants.primaryColor
                                          : AppConstants.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              selectedChoice == 'sms'
                                  ? Icon(
                                    Icons.check_circle,
                                    size: 28,
                                    color: AppConstants.primaryColor,
                                    shadows: [
                                      BoxShadow(
                                        color: AppConstants.primaryColor,
                                        offset: Offset(0, 0),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  )
                                  : Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        238,
                                        209,
                                        209,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2.1,
                                        color: AppConstants.backgroundColor,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppConstants.backgroundColor,
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                  ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      //email choice
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedChoice = 'email';
                          });
                        },
                        child: Container(
                          width: 199,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(18),
                            color:
                                selectedChoice == 'email'
                                    ? AppConstants.fadedBlue
                                    : AppConstants.fadedRed,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                textAlign: TextAlign.center,
                                'Email',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontFamily: AppConstants.fontFamilyRaleway,
                                  fontSize: 16,
                                  color:
                                      selectedChoice == 'sms'
                                          ? AppConstants.primaryColor
                                          : AppConstants.textColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              selectedChoice == 'email'
                                  ? Icon(
                                    Icons.check_circle,
                                    size: 28,
                                    color: AppConstants.primaryColor,
                                    shadows: [
                                      BoxShadow(
                                        color: AppConstants.primaryColor,
                                        offset: Offset(0, 0),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  )
                                  : Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        238,
                                        209,
                                        209,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2.1,
                                        color: AppConstants.backgroundColor,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppConstants.backgroundColor,
                                          blurRadius: 4.0,
                                        ),
                                      ],
                                    ),
                                  ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 200),

                      //next button
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 330,
                            height: 54,
                            child: CustomButtonWidget(
                              buttonTitle: 'Next',
                              isLoading: false,
                              onPressed: () {
                                context.push(
                                  '/account-detail',
                                  extra: {'recovery-type': selectedChoice},
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              context.go('/login');
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: AppConstants.fontFamilyNunito,
                                fontWeight: FontWeight.w300,
                                color: AppConstants.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
