import 'package:bexie_mart/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerRoute extends StatefulWidget {
  const CustomerRoute({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<CustomerRoute> createState() => _CustomerRouteState();
}

class _CustomerRouteState extends State<CustomerRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(backgroundColor: AppConstants.textColor, width: 24),
      appBar: AppBar(
        title: Text(
          "BexieMart",
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppConstants.textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.favorite_border, weight: 350.0),
          SizedBox(width: 16),
          Icon(Icons.shopping_cart_outlined, weight: 350.0),
          SizedBox(width: 16),
        ],
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppConstants.backgroundColor,
        animationDuration: Duration(seconds: 1),
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (int index) {
          widget.navigationShell.goBranch(index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home,
              color:
                  widget.navigationShell.currentIndex == 0
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color:
                  widget.navigationShell.currentIndex == 1
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.fastfood,
              color:
                  widget.navigationShell.currentIndex == 2
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Food',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.money_outlined,
              color:
                  widget.navigationShell.currentIndex == 3
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Earn',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.wallet_sharp,
              color:
                  widget.navigationShell.currentIndex == 4
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Wallet',
          ),
        ],
      ),
    );
  }
}
