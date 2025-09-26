import 'package:intl/intl.dart';

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

  Map<String, dynamic> getLatestItems(List<Map<String, dynamic>> products) {
    final dateFormatOfUpload = DateFormat(
      'yyyy-MM-dd',
    ).parse(products.map((e) => e['uploadDate']).toList().join());

    final numberOfDays = DateTime.now().difference(dateFormatOfUpload).inDays;
    if (products.isEmpty) {
      return {
        'latestProducts': <Map<String, dynamic>>[],
        'latestProduct': null,
      };
    }
    if (numberOfDays < 7) {
      return {
        'latestProducts': <Map<String, dynamic>>[],
        'latestProduct': null,
      };
    }
    final latestProduct = products.reduce(
      (curr, next) =>
          ((curr['uploadDate'] ?? 0).compareTo(next['uploadDate'] ?? 0) >=
                  0)
              ? curr
              : next,
    );
    final sortedProducts = List<Map<String, dynamic>>.from(products)
      ..sort((a, b) => (b['uploadDate'] ?? 0).compareTo(a['uploadDate'] ?? 0));
    return {'sortedProducts': sortedProducts, 'latestProduct': latestProduct};
  }
}
