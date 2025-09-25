import 'dart:async';

import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import "dart:developer" as dev;

import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PasswordVerifyScreen extends StatefulWidget {
  const PasswordVerifyScreen({super.key, required this.recoveryType});
  final String recoveryType;

  @override
  State<PasswordVerifyScreen> createState() => _PasswordVerifyScreenState();
}

class _PasswordVerifyScreenState extends State<PasswordVerifyScreen> {
  final String phoneNumber = '0551875432';
  final String emailAddress = 'techpepson@gmail.com';
  String displayPhone = '';
  String displayEmail = '';
  String securityCode = '';
  int _seconds = 60;
  bool _isLoading = false;

  Timer? _timer;

  Future<void> startCountDown() async {
    setState(() {
      _seconds = 60; //set the seconds to 60 at the start of countdown
    });

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<String> stripContact() async {
    String finalString = '';
    if (widget.recoveryType == 'sms') {
      final int phoneLength = phoneNumber.length;
      String firstThreeNumbers = phoneNumber.substring(0, 3);
      String lastTwoNumbers = phoneNumber.substring(
        phoneLength - 2,
        phoneLength,
      );
      finalString =
          firstThreeNumbers +
          List.generate(phoneLength - 5, (value) => '*').join('') +
          lastTwoNumbers;
      displayPhone = finalString;
    }
    return finalString;
  }

  Future<void> simulateAPICall() async {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        context.push('/new-password');
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<String> stripEmail() async {
    String finalString = '';
    if (widget.recoveryType == 'email') {
      final int emailLength = emailAddress.length;
      String firstThreeNumbers = emailAddress.substring(0, 3);
      String lastTwoNumbers = emailAddress.substring(
        emailLength - 2,
        emailLength,
      );
      finalString =
          firstThreeNumbers +
          List.generate(emailLength - 5, (value) => '*').join('') +
          lastTwoNumbers;
      displayEmail = finalString;
    }
    return finalString;
  }

  @override
  void initState() {
    if (widget.recoveryType == 'sms') {
      stripContact();
    } else {
      stripEmail();
    }
    startCountDown();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

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
              child: SingleChildScrollView(
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
                        SizedBox(height: 90),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: SizedBox(
                            width: 106,
                            height: 106,
                            child: Image.asset(AppConstants.onboardLargeImage1),
                          ),
                        ),
                        SizedBox(height: 15),
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
                                widget.recoveryType == 'sms'
                                    ? 'Enter the 4-digits code we sent to your phone number'
                                    : 'Enter the 4-digits code we sent to your email address',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  fontFamily: AppConstants.fontFamilyNunito,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.recoveryType == 'sms'
                                  ? displayPhone
                                  : displayEmail,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontFamily: AppConstants.fontFamilyNunito,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 10),
                            PinCodeTextField(
                              obscureText: true,
                              obscuringCharacter: '*',
                              mainAxisAlignment: MainAxisAlignment.center,
                              appContext: context,
                              length: 4,
                              onChanged: (value) {
                                setState(() {
                                  securityCode = value;
                                });
                              },
                              pinTheme: PinTheme(
                                fieldOuterPadding: EdgeInsets.all(15),
                                shape: PinCodeFieldShape.circle,
                                fieldHeight: 50,
                                fieldWidth: 50,
                                inactiveColor: AppConstants.primaryColor,
                                activeColor: AppConstants.primaryColor,
                                selectedColor: AppConstants.primaryColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 110),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 63,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Did not receive the code? ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontFamily:
                                            AppConstants.fontFamilyNunito,
                                        fontWeight: FontWeight.w300,
                                        color: AppConstants.textColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'You can resend it again in ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontFamily:
                                            AppConstants.fontFamilyNunito,
                                        fontWeight: FontWeight.w300,
                                        color: AppConstants.textColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    TextSpan(
                                      text: _seconds.toString(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontFamily:
                                            AppConstants.fontFamilyNunito,
                                        fontSize: 13,
                                        color: AppConstants.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    TextSpan(
                                      text: ' sec',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        fontFamily:
                                            AppConstants.fontFamilyNunito,
                                        fontSize: 13,
                                        color: AppConstants.primaryColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 330,
                              height: 54,
                              child: CustomButtonWidget(
                                buttonTitle: 'Next',
                                isLoading: _isLoading,
                                onPressed: () async {
                                  await simulateAPICall();
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                _seconds == 0 ? startCountDown() : null;
                              },
                              child: Text(
                                'Send Again',
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
            ),
          );
        },
      ),
    );
  }
}
