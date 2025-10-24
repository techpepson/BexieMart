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
}
