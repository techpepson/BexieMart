import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/services/app_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class AppServices {
  Map<String, dynamic> getTopProducts(List<Map<String, dynamic>> products) {
    if (products.isEmpty) {
      return {'sortedProducts': <Map<String, dynamic>>[], 'topRating': null};
    }
    final topRating = products.reduce(
      (curr, next) =>
          ((curr['productRating'] ?? 0).compareTo(next['productRating'] ?? 0) >=
                  0)
              ? curr
              : next,
    );
    final sortedProducts = List<Map<String, dynamic>>.from(products)..sort(
      (a, b) => (b['productRating'] ?? 0).compareTo(a['productRating'] ?? 0),
    );
    return {'sortedProducts': sortedProducts, 'topRating': topRating};
  }

  // get latest items
  List getLatestItems(List<Map<String, dynamic>> products) {
    final currentDate = DateTime.now();
    return products.where((product) {
        final uploadDate = DateTime.parse(product['uploadDate']);
        final daysOld = currentDate.difference(uploadDate).inDays;
        return daysOld >= 0 && daysOld <= 7;
      }).toList()
      ..sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        final uploadDateA = DateTime.parse(a['uploadDate']);
        final uploadDateB = DateTime.parse(b['uploadDate']);
        return uploadDateB.compareTo(uploadDateA);
      });
  }

  List getDiscountedItems(List<Map<String, dynamic>> products) {
    return products.where((product) {
        return product['productDiscount'] != null &&
            product['productDiscount'] > 0;
      }).toList()
      ..sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        final discountA = a['productDiscount'] ?? 0;
        final discountB = b['productDiscount'] ?? 0;
        return discountB.compareTo(discountA);
      });
  }

  //get most popular items
  List getMostPopularItems(List<Map<String, dynamic>> products) {
    return products.where((product) {
        return product['productLikes'] != null && product['productLikes'] >= 10;
      }).toList()
      ..sort((Map<String, dynamic> a, Map<String, dynamic> b) {
        final likesA = a['productLikes'] ?? 0;
        final likesB = b['productLikes'] ?? 0;
        return likesB.compareTo(likesA);
      });
  }

  //delete items from a list
  List<Map<String, dynamic>> deleteItemFromList(
    List<Map<String, dynamic>> products,
    int productId,
  ) {
    return products.where((product) {
      return product['productId'] != productId;
    }).toList();
  }

  DateTime parseStringToDate(String stringDate) {
    DateTime currentDate = DateTime.parse(stringDate);
    return currentDate;
  }

  DateTime getDaysDuration(int days) {
    DateTime currentDate = DateTime.now();
    return currentDate.add(Duration(days: days));
  }

  //get items over a period

  List<Map<String, dynamic>> getItemsOverTime(
    List<Map<String, dynamic>> items,
    String selectedDate,
  ) {
    DateTime targetDate = parseStringToDate(selectedDate);

    return items.where((item) {
      DateTime? watchDate;

      try {
        watchDate = parseStringToDate(item['watchDate']);
      } catch (_) {
        return false;
      }

      return watchDate.year == targetDate.year &&
          watchDate.month == targetDate.month &&
          watchDate.day == targetDate.day;
    }).toList();
  }

  Future<void> copyLink(String itemToCopy, BuildContext context) async {
    if (itemToCopy.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No item copied.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppConstants.backgroundColor,
            ),
          ),
          backgroundColor: AppConstants.accentColor,
        ),
      );

      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: itemToCopy));
      SnackBar(
        content: Text(
          '$itemToCopy copied to clipboard',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppConstants.backgroundColor),
        ),
        backgroundColor: AppConstants.successColor,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to copy link: $e')));
    }
  }

  Future<void> shareItem(
    String shareText,
    String shareTitle,
    String subject,
    BuildContext context,
  ) async {
    final params = ShareParams(
      text: shareText,
      title: shareTitle,
      subject: subject,
    );

    try {
      await SharePlus.instance.share(params);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error occurred sharing item.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppConstants.backgroundColor,
            ),
          ),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    }
  }

  List<Map<String, dynamic>> getItemsOverMonth(
    List<Map<String, dynamic>> items,
  ) {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> newItems =
        items
            .where(
              (item) => parseStringToDate(item['orderDate']).month == now.month,
            )
            .toList();

    return newItems;
  }

  List<Map<String, dynamic>> getItemByStatus(
    String status,
    List<Map<String, dynamic>> items,
  ) {
    List<Map<String, dynamic>> newItems =
        items.where((item) => item['orderStatus'] == status).toList();

    return newItems;
  }

  List<Map<String, dynamic>> getTotalOrdersPerPeriod(
    List<Map<String, dynamic>> items,
    int month,
  ) {
    DateTime today = DateTime.now();

    List<Map<String, dynamic>> orders =
        items.where((order) {
          String orderDateAsString = order['orderDate'];
          DateTime orderDateAsDate = parseStringToDate(orderDateAsString);

          return orderDateAsDate.month == month &&
              orderDateAsDate.year == today.year;
        }).toList();

    return orders;
  }

  double getTotalCount(List<Map<String, dynamic>> items) {
    double totalOrders = items.fold(
      0.0,
      (sum, order) => sum + (order['orderTotalAmount'] ?? 0),
    );

    return double.parse(totalOrders.toString());
  }

  List<SalesData> getMonthlySales(List<Map<String, dynamic>> orders) {
    Map<int, double> monthlyTotals = {for (int i = 1; i <= 12; i++) i: 0.0};

    for (var order in orders) {
      DateTime date = parseStringToDate(order['orderDate']);
      double amount = (order['orderTotalAmount'] ?? 0).toDouble();

      monthlyTotals[date.month] = monthlyTotals[date.month]! + amount;
    }

    return monthlyTotals.entries
        .map((e) => SalesData(_monthName(e.key), e.value))
        .toList();
  }

  String _monthName(int month) {
    const names = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return names[month];
  }
}
