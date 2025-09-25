import 'dart:async';

import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/form_field.dart';
import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import "dart:developer" as dev;

import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final String phoneNumber = '0551875432';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  Future<void> simulateSubmit() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      await _showModal();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                            'Setup New Password',
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
                              'Please, setup a new password for your account',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontFamily: AppConstants.fontFamilyNunito,
                                fontSize: 19,
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CustomFormField(
                              labelText: 'New Password',
                              hintText: 'Enter new password',
                            ),
                          ),
                          SizedBox(height: 15),
                          CustomFormField(
                            labelText: 'Repeat Password',
                            hintText: 'Repeat entered password',
                          ),
                        ],
                      ),

                      SizedBox(height: 200),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 330,
                            height: 54,
                            child: CustomButtonWidget(
                              buttonTitle: 'Submit',
                              isLoading: _isLoading,
                              onPressed: () async {
                                await simulateSubmit();
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

  Future<void> _showModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return ModalWidget(
          title: 'Done',
          description: 'You have successfully updated your password',
          buttonTitle: 'Login',
          buttonAction: () => context.go('/login'),
        );
      },
    );
  }
}
