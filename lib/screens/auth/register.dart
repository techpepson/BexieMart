import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/form_field.dart';
import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  String? _radioGroupValue = 'customer';

  //function to simulate signup
  Future<void> simulateSignup() async {
    if (isLoading) return; // guard against multiple CustomTransitionPage
    setState(() => isLoading = true);
    try {
      // delay for 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      // show custom modal from function
      await showCustomModal();
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
                              'Register',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: AppConstants.fontWeightMedium,
                                fontSize: 40,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Welcome to BexieMart! 💌',
                              style: TextStyle(
                                fontWeight: AppConstants.fontWeightMedium,
                                fontSize: 20,
                              ),
                            ),
                            //name field
                            SizedBox(height: 12),
                            CustomFormField(
                              labelText: "Name",
                              hintText: "Enter your name",
                              suffixIcon: AppConstants.personIcon,
                              isPassword: false,
                              onSuffixIconPressed: () {},
                              keyboardType: TextInputType.emailAddress,
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
                              ],
                            ),
                            SizedBox(height: 15),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Role",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontWeight: AppConstants.fontWeightMedium,
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //vendor radio button
                                      RadioMenuButton(
                                        value: 'vendor',
                                        groupValue: _radioGroupValue,
                                        toggleable: true,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _radioGroupValue = value;
                                            }
                                          });
                                        },
                                        child: Text('Vendor'),
                                      ),
                                      SizedBox(width: 12),
                                      //customer radio button
                                      RadioMenuButton(
                                        value: 'customer',
                                        groupValue: _radioGroupValue,
                                        toggleable: true,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _radioGroupValue = value;
                                            }
                                          });
                                        },
                                        child: Text('Customer'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        //register button
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: CustomButtonWidget(
                            buttonTitle: "Register",
                            isLoading: isLoading,
                            onPressed: () async {
                              await simulateSignup();
                            },
                          ),
                        ),

                        //Don't have an account button
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            context.push('/login');
                          },
                          child: Text(
                            "Already have an account? Login",
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

  //function to show custom modal
  Future<void> showCustomModal() async {
    return showDialog(
      context: context,
      builder: (context) {
        return ModalWidget(
          title: 'Done!',
          description:
              'Your account has been created successfully. Please verify your email to login.',
          buttonTitle: 'Login',
          buttonAction: () {
            context.go('/login');
          },
        );
      },
    );
  }
}
