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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;

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
        titleSpacing: 0,
        title: Text(
          "Back",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            fontFamily: AppConstants.fontFamilyNunito,
          ),
        ),
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //company logo display
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(50),
                      //   child: Image.asset(
                      //     AppConstants.appLogo,
                      //     width: 250,
                      //     height: 250,
                      //   ),
                      // ),
                      //email field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            'Login',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: AppConstants.textColor,
                              fontFamily: AppConstants.fontFamilyRaleway,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Good To See You Back! 🖤',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 19,
                              color: AppConstants.textColor,
                              fontFamily: AppConstants.fontFamilyNunito,
                            ),
                          ),
                          SizedBox(height: 12),
                          CustomFormField(
                            controller: _emailController,
                            labelText: "Email",
                            hintText: "Enter your email",
                            // suffixIcon: AppConstants.emailIcon,
                            isPassword: false,
                            onSuffixIconPressed: () {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 12),
                          //password field
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomFormField(
                                controller: _passwordController,
                                labelText: "Password",
                                hintText: "Enter your password",
                                suffixIcon:
                                    isPasswordVisible
                                        ? AppConstants.eyeOpen
                                        : AppConstants.eyeClose,
                                isPasswordVisible: isPasswordVisible,
                                onSuffixIconPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                isPassword: true,
                                validator: (value) {
                                  return value == null ||
                                          value.isEmpty ||
                                          value.length < 6
                                      ? 'Enter a valid password'
                                      : null;
                                },
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push('/reset-password');
                                },
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

                      SizedBox(height: 250),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: CustomButtonWidget(
                          buttonTitle: "Login",
                          isLoading: isLoading,
                          onPressed: () async {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {}
                            await simulateLogin();
                          },
                        ),
                      ),

                      //Don't have an account button
                      SizedBox(height: 20),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
