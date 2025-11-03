import 'package:bexie_mart/routes/customer_route.dart';
import 'package:bexie_mart/screens/auth/account_detail.dart';
import 'package:bexie_mart/screens/auth/forgot_password_screen.dart';
import 'package:bexie_mart/screens/auth/login.dart';
import 'package:bexie_mart/screens/auth/new_password_screen.dart';
import 'package:bexie_mart/screens/auth/password_verify_screen.dart';
import 'package:bexie_mart/screens/auth/register.dart';
import 'package:bexie_mart/screens/customer/cart_screen.dart';
import 'package:bexie_mart/screens/customer/customer_earn.dart';
import 'package:bexie_mart/screens/customer/customer_food.dart';
import 'package:bexie_mart/screens/customer/customer_home.dart';
import 'package:bexie_mart/screens/customer/customer_shop.dart';
import 'package:bexie_mart/screens/customer/customer_wallet.dart';
import 'package:bexie_mart/screens/customer/favorites_screen.dart';
import 'package:bexie_mart/screens/customer/recently_viewed.dart';
import 'package:bexie_mart/screens/launch_screen.dart';
import 'package:bexie_mart/screens/onboarding_screens.dart';
import 'package:bexie_mart/screens/payments/payment_screen.dart';
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
      path: '/payment',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final items = args['items'];
        final totalAmount = args['totalAmount'];
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: PaymentScreen(items: items, totalAmount: totalAmount),
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
    GoRoute(
      path: '/reset-password',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/verify-password-reset',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: PasswordVerifyScreen(recoveryType: extra['recovery-type']),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/account-detail',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: AccountDetail(recoveryType: extra['recovery-type']),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/new-password',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          child: NewPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              CustomerRoute(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          initialLocation: '/customer-home',
          routes: [
            GoRoute(
              path: '/customer-home',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: CustomerHome(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
              routes: [
                GoRoute(
                  path: 'show-all',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: CustomerHome(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    );
                  },
                ),
                GoRoute(
                  path: 'cart',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: CartScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    );
                  },
                ),
                GoRoute(
                  path: 'favorites',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: FavoritesScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    );
                  },
                ),
                GoRoute(
                  path: 'recently-viewed',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: RecentlyViewed(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer-shop',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: CustomerShop(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer-food',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: CustomerFood(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer-earn',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: CustomerEarn(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/customer-wallet',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: CustomerWallet(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
