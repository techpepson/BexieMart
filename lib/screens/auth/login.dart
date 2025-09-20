import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/form_field.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isFirstTime = true;

  //function to simulate login
  Future<void> simulateLogin() async {
    if (isLoading) return; // guard against multiple taps
    setState(() => isLoading = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      // Replace the route so this page is disposed and spinner can't persist
      context.go(isFirstTime ? '/onboard' : '/');
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(AppConstants.backArrowIcon),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //company logo display
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            AppConstants.appLogo,
                            width: 250,
                            height: 250,
                          ),
                        ),
                        //email field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: AppConstants.fontWeightMedium,
                                fontSize: 40,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Good To See You Back! 💌',
                              style: TextStyle(
                                fontWeight: AppConstants.fontWeightMedium,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 12),
                            CustomFormField(
                              labelText: "Email",
                              hintText: "Enter your email",
                              suffixIcon: AppConstants.emailIcon,
                              isPassword: false,
                              onSuffixIconPressed: () {},
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 12),
                            //password field
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomFormField(
                                  labelText: "Password",
                                  hintText: "Enter your password",
                                  suffixIcon: AppConstants.passwordIcon,
                                  isPassword: true,
                                  onSuffixIconPressed: () {},
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Forgot Password?",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      fontWeight: AppConstants.fontWeightMedium,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                            //login button
                          ],
                        ),

                        SizedBox(
                          width: 300,
                          height: 50,
                          child: CustomButtonWidget(
                            buttonTitle: "Login",
                            isLoading: isLoading,
                            onPressed: () async {
                              await simulateLogin();
                            },
                          ),
                        ),

                        //Don't have an account button
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            context.push('/register');
                          },
                          child: Text(
                            "Don't have an account? Register",
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
              );
            },
          ),
        ),
      ),
    );
  }
}
