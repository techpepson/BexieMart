import 'package:bexie_mart/screens/auth/login.dart';
import 'package:bexie_mart/screens/auth/register.dart';
import 'package:bexie_mart/screens/launch_screen.dart';
import 'package:bexie_mart/screens/onboarding_screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: LaunchScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/onboard',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: OnboardingScreens(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
  ],
  initialLocation: "/",
);
