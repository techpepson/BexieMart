import 'package:bexie_mart/components/empty_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavComponent extends StatefulWidget {
  const FavComponent({super.key});

  @override
  State<FavComponent> createState() => _FavComponentState();
}

class _FavComponentState extends State<FavComponent> {
  final ProductsData products = ProductsData();
  AppServices appServices = AppServices();
  String currency = 'dollars';
  @override
  Widget build(BuildContext context) {
    final favoriteItems = products.userFavorite;
    return favoriteItems.isEmpty
        ? EmptyWidget()
        : SizedBox(
          height: 300,
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: ListView.builder(
              itemCount: favoriteItems.length,
              itemExtent: 120,
              physics: PageScrollPhysics(),
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                double unitPrice =
                    item['productPrice'] is double
                        ? item['productPrice']
                        : double.parse(item['productPrice']);

                int productQuantity = index == 0 ? index + 1 : (index ~/ 1);
                String productImage = item['productImage'][0] ?? "";
                double finalPrice = unitPrice * productQuantity;
                String productColor = item['productColor'];
                int productId = item['productId'];
                List splitColorText = productColor.split('');
                String productSize = item['productSize'];
                String sizePlaceholder;
                String capitalizedFirstLetter =
                    splitColorText[0].toString().toUpperCase();

                String color =
                    capitalizedFirstLetter +
                    splitColorText
                        .sublist(1)
                        .join(
                          '',
                        ); //like substring, sublist gives access to a list items

                //product size
                switch (productSize) {
                  case 'small':
                    sizePlaceholder = 'S';
                    break;
                  case 'medium':
                    sizePlaceholder = 'M';
                    break;
                  case 'large':
                    sizePlaceholder = 'L';
                  case 'extraLarge':
                    sizePlaceholder = 'XL';
                  default:
                    sizePlaceholder = 'L';
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: 121.18,
                            height: 101.16,
                            imageUrl: productImage,
                            errorWidget:
                                (context, url, error) =>
                                    Icon(Icons.image_not_supported_outlined),
                            placeholder: (context, url) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.asset(
                                  'assets/images/appLogo.jpg',
                                  width: 100,
                                  height: 100,
                                ),
                              );
                            },
                          ),
                        ),

                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppConstants.backgroundColor,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.all(0.0),
                              onPressed: () {
                                List<Map<String, dynamic>> newItems =
                                    appServices.deleteItemFromList(
                                      products.userFavorite,
                                      productId,
                                    );
                                setState(() {
                                  products.userFavorite = newItems;
                                });
                              },
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: AppConstants.errorColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['productName'],
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontFamily: AppConstants.fontFamilyNunito,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${currency == 'dollars' ? "\$" : "\GHS"} $unitPrice',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontFamily: AppConstants.fontFamilyRaleway,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            width: 335,
                            child: Row(
                              children: [
                                Container(
                                  width: 54,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    color: AppConstants.primaryColor.withAlpha(
                                      50,
                                    ),
                                  ),
                                  child: Center(child: Text(color)),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  width: 54,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    color: AppConstants.primaryColor.withAlpha(
                                      50,
                                    ),
                                  ),
                                  child: Center(child: Text(sizePlaceholder)),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.add_shopping_cart_sharp,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
  }
}
