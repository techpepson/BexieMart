import 'package:bexie_mart/components/product_details_component.dart';
import 'package:bexie_mart/routes/customer_route.dart';
import 'package:bexie_mart/routes/vendor_route.dart';
import 'package:bexie_mart/screens/auth/account_detail.dart';
import 'package:bexie_mart/screens/auth/forgot_password_screen.dart';
import 'package:bexie_mart/screens/auth/login.dart';
import 'package:bexie_mart/screens/auth/new_password_screen.dart';
import 'package:bexie_mart/screens/auth/password_verify_screen.dart';
import 'package:bexie_mart/screens/auth/register.dart';
import 'package:bexie_mart/screens/customer/all_products.dart';
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
import 'package:bexie_mart/screens/utils/notification_screen.dart';
import 'package:bexie_mart/screens/vendor/add_coupon.dart';
import 'package:bexie_mart/screens/vendor/add_products.dart';
import 'package:bexie_mart/screens/vendor/edit_coupon.dart';
import 'package:bexie_mart/screens/vendor/edit_products_screen.dart';
import 'package:bexie_mart/screens/vendor/vendor_dashboard.dart';
import 'package:bexie_mart/screens/vendor/vendor_earnings.dart';
import 'package:bexie_mart/screens/vendor/vendor_order_details.dart';
import 'package:bexie_mart/screens/vendor/vendor_orders.dart';
import 'package:bexie_mart/screens/vendor/vendor_payment.dart';
import 'package:bexie_mart/screens/vendor/vendor_products.dart';
import 'package:bexie_mart/screens/vendor/vendor_settings.dart';
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
      path: '/vendor-add-products',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: AddProducts(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: NotificationScreen(),
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
      path: '/all-products',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        List<Map<String, dynamic>> items = args['items'];
        String ownerCurrency = args['ownerCurrency'];
        String title = args['title'];
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: AllProducts(
            items: items,
            ownerCurrency: ownerCurrency,
            title: title,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    ),

    GoRoute(
      path: '/product-details',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        Map<String, dynamic> item = args['item'];
        return CustomTransitionPage(
          transitionDuration: Duration(milliseconds: 300),
          key: state.pageKey,
          child: ProductDetailsComponent(item: item),
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

    //vendor routes
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              VendorRoute(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          initialLocation: '/vendor-home',
          routes: [
            GoRoute(
              path: '/vendor-home',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: VendorDashboard(),
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
              path: '/vendor-products',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: VendorProducts(),
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
                  path: 'edit',
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: EditProductsScreen(item: extra['item']),
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
              path: '/vendor-orders',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: VendorOrders(),
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
                  path: 'order-details',
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    Map<String, dynamic> order = extra['order'];
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: VendorOrderDetails(order: order),
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
              path: '/vendor-earnings',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: VendorEarnings(),
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
                  path: 'payment-screen',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: VendorPayment(),
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
              path: '/vendor-settings',
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  transitionDuration: Duration(milliseconds: 300),
                  key: state.pageKey,
                  child: VendorSettings(),
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
                  path: 'add-coupon',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: AddCoupon(),
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
                  path: 'edit-coupon',
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      transitionDuration: Duration(milliseconds: 300),
                      key: state.pageKey,
                      child: EditCoupon(),
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
    ),
  ],
);
