import 'package:bexie_mart/components/onboard_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  final int _totalPages = 2;
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    focal: Alignment.topLeft,
                    tileMode: TileMode.clamp,
                    focalRadius: 0.5,
                    radius: 0.5,
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.backgroundColor,
                    ],
                  ),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _currentPage != _totalPages - 1
                          ? TextButton(
                            onPressed: () {
                              _pageController.animateToPage(
                                _totalPages - 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text(
                              "Skip",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: AppConstants.fontWeightMedium,
                                fontSize: AppConstants.fontSizeMedium,
                              ),
                            ),
                          )
                          : TextButton(
                            onPressed: () {
                              context.go('/');
                            },
                            child: Text(
                              "Done",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                fontWeight: AppConstants.fontWeightMedium,
                                fontSize: AppConstants.fontSizeMedium,
                              ),
                            ),
                          ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            OnboardWidget(
                              image: AppConstants.onboardLargeImage1,
                              title: "Buy Everything in One Place",
                              description:
                                  "From food to fashion, Bexiemart connects you with vendors around your campus - fast, reliable, and easy.",
                            ),
                            OnboardWidget(
                              isLastScreen: true,
                              image: AppConstants.onboardLargeImage2,
                              title: "Buy Everything in One Place",
                              description:
                                  "From food to fashion, Bexiemart connects you with vendors around your campus - fast, reliable, and easy.",
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          2,
                          (index) => Container(
                            height: 15,
                            width: _currentPage == index ? 30 : 20,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  _currentPage == index
                                      ? AppConstants.primaryColor
                                      : AppConstants.greyedColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
