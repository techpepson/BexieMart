import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/form_field.dart';
import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/app_data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as dev;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  String? _radioGroupValue = 'vendor';
  bool? _accommodationStatus = true;
  String? _selectedCampus = AppData.ghanaUniversities.first;
  bool isPasswordVisible = false;

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
    setState(() {
      _radioGroupValue = 'vendor';
    });
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
                  padding: const EdgeInsets.all(16.0),
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
                        children: [
                          Text(
                            'Register',
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
                          // Text(
                          //   'Welcome to BexieMart! 💌',
                          //   style: TextStyle(
                          //     fontWeight: AppConstants.fontWeightMedium,
                          //     fontSize: 20,
                          //   ),
                          // ),
                          //name field
                          SizedBox(height: 12),
                          CustomFormField(
                            labelText: "Name",
                            hintText: "Enter your name",
                            // suffixIcon: AppConstants.personIcon,
                            isPassword: false,
                            onSuffixIconPressed: () {},
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: 12),
                          CustomFormField(
                            labelText: "Email",
                            hintText: "Enter your email",
                            // suffixIcon: AppConstants.emailIcon,
                            isPassword: false,
                            onSuffixIconPressed: () {},
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 12),
                          CustomFormField(
                            labelText: "Phone",
                            hintText: "Enter your phone number",
                            // suffixIcon: AppConstants.emailIcon,
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
                                suffixIcon:
                                    isPasswordVisible
                                        ? AppConstants.eyeOpen
                                        : AppConstants.eyeClose,
                                isPassword: true,
                                isPasswordVisible: isPasswordVisible,
                                onSuffixIconPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ],
                          ),
                          SizedBox(height: 40),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 15,
                            children: [
                              Text(
                                "Select Role",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 24,
                                  letterSpacing: -0.5,
                                  fontFamily: AppConstants.fontFamilyRaleway,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    radioTheme: RadioThemeData(
                                      fillColor:
                                          WidgetStateProperty.resolveWith<
                                            Color?
                                          >((states) {
                                            if (states.contains(
                                              WidgetState.selected,
                                            )) {
                                              return AppConstants.primaryColor;
                                            }
                                            if (states.contains(
                                              WidgetState.disabled,
                                            )) {
                                              return Colors.grey;
                                            }
                                            return AppConstants.textColor
                                                .withAlpha(120);
                                          }),
                                    ),
                                  ),
                                  child: Row(
                                    spacing: 3,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //vendor radio button
                                      // RadioMenuButton(
                                      //   value: 'student',
                                      //   groupValue: _radioGroupValue,
                                      //   toggleable: true,
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       if (value != null) {
                                      //         _radioGroupValue = value;
                                      //       }
                                      //     });
                                      //   },
                                      //   child: Text(
                                      //     'Student',
                                      //     style: TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.w600,
                                      //       fontFamily:
                                      //           AppConstants.fontFamilyNunito,
                                      //       color: AppConstants.textColor,
                                      //     ),
                                      //   ),
                                      // ),
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
                                        child: Text(
                                          'Vendor',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily:
                                                AppConstants.fontFamilyNunito,
                                            color: AppConstants.textColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      //customer radio button
                                      RadioMenuButton(
                                        value: 'generalPublic',
                                        groupValue: _radioGroupValue,
                                        toggleable: true,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _radioGroupValue = value;
                                            }
                                          });
                                        },
                                        child: Text(
                                          'General Public',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily:
                                                AppConstants.fontFamilyNunito,
                                            color: AppConstants.textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 25),

                      // campus student area
                      if (_radioGroupValue == 'student')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Do you live on Campus?",
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                fontSize: 18,
                                letterSpacing: -0.5,
                                fontFamily: AppConstants.fontFamilyRaleway,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  radioTheme: RadioThemeData(
                                    fillColor:
                                        WidgetStateProperty.resolveWith<Color?>(
                                          (states) {
                                            if (states.contains(
                                              WidgetState.selected,
                                            )) {
                                              return AppConstants.primaryColor;
                                            }
                                            if (states.contains(
                                              WidgetState.disabled,
                                            )) {
                                              return Colors.grey;
                                            }
                                            return AppConstants.textColor
                                                .withAlpha(120);
                                          },
                                        ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //vendor radio button
                                    RadioMenuButton(
                                      value: true,
                                      groupValue: _accommodationStatus,
                                      toggleable: true,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value != null) {
                                            _accommodationStatus = bool.parse(
                                              value.toString(),
                                            );
                                          }
                                        });
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily:
                                              AppConstants.fontFamilyNunito,
                                          color: AppConstants.textColor,
                                        ),
                                      ),
                                    ),
                                    RadioMenuButton(
                                      value: false,
                                      groupValue: _accommodationStatus,
                                      toggleable: true,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value != null) {
                                            _accommodationStatus = bool.parse(
                                              value.toString(),
                                            );
                                          }
                                        });
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          fontFamily:
                                              AppConstants.fontFamilyNunito,
                                          color: AppConstants.textColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                  ],
                                ),
                              ),
                            ),
                            if (_accommodationStatus == true)
                              SizedBox(
                                width: 500,
                                child: CustomFormField(
                                  labelText: "Room Number",
                                  hintText: "Enter Room Number",
                                ),
                              )
                            else
                              SizedBox(
                                width: 500,
                                child: CustomFormField(
                                  labelText: "Nearby Area",
                                  hintText: "Enter Nearby Area",
                                ),
                              ),

                            //campus selection
                            DropdownSearch<String>(
                              mode: Mode.form,
                              suffixProps: DropdownSuffixProps(
                                dropdownButtonProps: DropdownButtonProps(
                                  iconOpened: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.grey,
                                  ),
                                  iconClosed: Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              itemAsString: (item) => item,
                              dropdownBuilder: (context, String? selectedItem) {
                                if (selectedItem == null ||
                                    selectedItem.isEmpty) {
                                  return Text(
                                    'Select your school',
                                    style: TextStyle(
                                      color: AppConstants.textColor.withAlpha(
                                        120,
                                      ),
                                      fontFamily: AppConstants.fontFamilyNunito,
                                      fontSize: 14,
                                    ),
                                  );
                                }
                                return Row(
                                  children: [
                                    const Icon(
                                      Icons.school_outlined,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        selectedItem,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppConstants.textColor,
                                          fontFamily:
                                              AppConstants.fontFamilyNunito,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              selectedItem: _selectedCampus,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCampus = value;
                                  dev.log(_selectedCampus!);
                                });
                              },

                              compareFn:
                                  (item1, item2) =>
                                      item1.toLowerCase() ==
                                      item2.toLowerCase(),
                              items:
                                  (filter, loadProps) =>
                                      AppData.ghanaUniversities,
                            ),
                          ],
                        ),

                      // if (_radioGroupValue == 'vendor')
                      //   Text('Vendor data goes here'),
                      SizedBox(height: 20),
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
