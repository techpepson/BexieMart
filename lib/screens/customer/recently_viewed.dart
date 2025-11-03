import 'package:bexie_mart/components/all_items_display_component.dart';
import 'package:bexie_mart/components/empty_favorites.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentlyViewed extends StatefulWidget {
  const RecentlyViewed({super.key});

  @override
  State<RecentlyViewed> createState() => _RecentlyViewedState();
}

class _RecentlyViewedState extends State<RecentlyViewed> {
  ProductsData products = ProductsData();

  String ownerCurrency = 'cedis';

  DateTime targetDate = DateTime.now();

  AppServices appServices = AppServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [_buildDateSelectButtons(), _buildItemDisplay()],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color primaryBlue = AppConstants.primaryColor;

  Widget _buildDateSelectButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- Today Button ---
          _dateButton(
            label: 'Today',
            isSelected: _isSameDay(targetDate, DateTime.now()),
            onTap: () {
              setState(() {
                targetDate = DateTime.now();
              });
            },
          ),

          // --- Yesterday Button ---
          _dateButton(
            label: 'Yesterday',
            isSelected: _isSameDay(
              targetDate,
              DateTime.now().subtract(Duration(days: 1)),
            ),
            onTap: () {
              setState(() {
                targetDate = DateTime.now().subtract(Duration(days: 1));
              });
            },
          ),

          // --- Custom Date Picker Button ---
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              DateTime? picked = await displayDatePicker(context);
              if (picked != null) {
                setState(() {
                  targetDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryBlue.withOpacity(0.7),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: primaryBlue, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM d').format(targetDate),
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// reusable button for Today / Yesterday
  Widget _dateButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected
                    ? AppConstants.primaryColor
                    : AppConstants.primaryColor.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isSelected ? Colors.white : AppConstants.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: compare two dates ignoring time
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Styled DatePicker
  Future<DateTime?> displayDatePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: targetDate,
      firstDate: DateTime(now.year - 1),
      lastDate: now.add(const Duration(days: 366)),
      builder: (context, child) {
        // Themed blue date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryColor, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return pickedDate;
  }

  Widget _buildItemDisplay() {
    List<Map<String, dynamic>> favoritesItems = products.recentlyWatched;

    String defaultViewedDate = DateFormat('yyy-MM-dd').format(targetDate);

    List<Map<String, dynamic>> timeBaseItems = appServices.getItemsOverTime(
      favoritesItems,
      defaultViewedDate,
    );

    return timeBaseItems.isEmpty
        ? EmptyFavorites()
        : AllItemsDisplayComponent(
          items: timeBaseItems,
          ownerCurrency: ownerCurrency,
        );
  }

  // Future<DateTime?> displayDatePicker(BuildContext context) async {
  //   DateTime startDate = DateTime.now();

  //   DateTime endDate = startDate.add(Duration(days: 366));
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     firstDate: startDate,
  //     lastDate: endDate,
  //   );

  //   return pickedDate;
  // }
}
