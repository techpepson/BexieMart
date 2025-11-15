import 'package:bexie_mart/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VendorRoute extends StatefulWidget {
  const VendorRoute({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<VendorRoute> createState() => _VendorRouteState();
}

class _VendorRouteState extends State<VendorRoute> {
  String userProfile =
      'https://images.unsplash.com/photo-1580489944761-15a19d654956?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZSUyMGltYWdlfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: false,
        actions: [
          ClipOval(
            child: CachedNetworkImage(
              width: 35,
              height: 35,
              imageUrl: userProfile,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.person),
              placeholder:
                  (context, url) => SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.notifications),
            color: AppConstants.primaryColor,
            onPressed: () {
              context.push('/notifications');
            },
          ),
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
              Icons.dashboard,
              color:
                  widget.navigationShell.currentIndex == 0
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_bag,
              color:
                  widget.navigationShell.currentIndex == 1
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.receipt,
              color:
                  widget.navigationShell.currentIndex == 2
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.money_outlined,
              color:
                  widget.navigationShell.currentIndex == 3
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings,
              color:
                  widget.navigationShell.currentIndex == 4
                      ? AppConstants.primaryColor
                      : const Color.fromARGB(255, 104, 98, 98),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
