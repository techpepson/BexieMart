import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/empty_widget.dart';
import 'package:bexie_mart/components/fav_component.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ProductsData products = ProductsData();

  bool isEditingAddress = false;
  final currency = 'dollars';
  String deliveryAddress = 'Accra, Ghana';

  TextEditingController _addressController = TextEditingController();

  final AppServices appServices = AppServices();

  double totalAmount = 0.00;

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      isEditingAddress = !isEditingAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleDisplay(),
                    SizedBox(height: 12),
                    _buildCartItemsDisplay(),
                    SizedBox(height: 12),

                    // Text(
                    //   'From Your Wishlist',
                    //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    //     fontWeight: FontWeight.w700,
                    //     color: AppConstants.textColor,
                    //     fontSize: 24,
                    //     fontFamily: AppConstants.fontFamilyRaleway,
                    //   ),
                    // ),
                    // _buildFavoriteItemsDisplay(),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomSheet: Container(child: _buildCheckoutButton()),
    );
  }

  Widget _buildTitleDisplay() {
    final cartItems = products.cartItems;
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Cart',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppConstants.textColor,
                fontSize: 24,
                fontFamily: AppConstants.fontFamilyRaleway,
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withAlpha(50),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(
                  cartItems.length.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: AppConstants.fontFamilyRaleway,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppConstants.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 10),
        //conditionally display a text editing field or a container for editing address
        isEditingAddress == false
            ? Container(
              width: 335,
              height: 50,
              decoration: BoxDecoration(
                color: AppConstants.greyedColor.withAlpha(120),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            fontFamily: AppConstants.fontFamilyRaleway,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          deliveryAddress.toString(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontFamily: AppConstants.fontFamilyRaleway,
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          onPressed: () {
                            toggleEdit();
                          },
                          icon: Icon(
                            Icons.edit,
                            color: AppConstants.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ),
            )
            : SizedBox(
              height: 50,
              width: 335,
              child: TextField(
                controller: _addressController,
                onChanged: (value) {
                  setState(() {
                    deliveryAddress = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppConstants.greyedColor.withAlpha(120),
                  hint: Text(deliveryAddress.toString()),
                  label: Text('Delivery Address'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      width: 0.0,
                      style: BorderStyle.none,
                      color: AppConstants.greyedColor.withAlpha(50),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      toggleEdit();
                    },
                    icon: Icon(
                      size: 33,
                      Icons.check_circle_outline,
                      color: AppConstants.successColor,
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildCartItemsDisplay() {
    List<Map<String, dynamic>> cartItems = products.cartItems;

    //  Calculate total once
    double total = 0.0;
    for (var item in cartItems) {
      double unitPrice =
          (item['productPrice'] is double)
              ? item['productPrice']
              : double.tryParse(item['productPrice'].toString()) ?? 0.0;
      int productQuantity = item['productQuantity'] ?? 1;
      total += unitPrice * productQuantity;
    }

    // Update your state variable (if you need it for checkout)
    totalAmount = total;

    return cartItems.isEmpty
        ? EmptyWidget()
        : SizedBox(
          height: 500,
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: ListView.builder(
              itemExtent: 120,
              itemCount: cartItems.length,
              physics: PageScrollPhysics(),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                double unitPrice =
                    (item['productPrice'] is double)
                        ? item['productPrice']
                        : double.tryParse(item['productPrice'].toString()) ??
                            0.0;

                int productQuantity = item['productQuantity'];
                String productImage = item['productImage'][0] ?? "";
                double finalPrice = unitPrice * productQuantity;
                String productColor = item['productColor'];
                List splitColorText = productColor.split('');
                String productSize = item['productSize'];
                int productId = item['productId'];
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
                          borderRadius: BorderRadius.circular(5.0),
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
                                      products.cartItems,
                                      productId,
                                    );
                                setState(() {
                                  products.cartItems = newItems;
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 196,
                          child: Text(
                            overflow: TextOverflow.clip,
                            item['productName'],
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontFamily: AppConstants.fontFamilyNunito,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Text(
                          '$color, Size $sizePlaceholder',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontFamily: AppConstants.fontFamilyNunito,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${currency == 'dollars' ? "\$" : "\GHS"} $finalPrice',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontFamily: AppConstants.fontFamilyRaleway,
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(width: 30),
                            Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    border: BoxBorder.all(
                                      style: BorderStyle.solid,
                                      color: AppConstants.primaryColor,
                                    ),
                                    color: AppConstants.backgroundColor,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      onPressed: () {
                                        productQuantity > 1
                                            ? setState(() {
                                              item['productQuantity']--;
                                              // totalAmount -=
                                              //     unitPrice * productQuantity;
                                            })
                                            : null;
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        color: AppConstants.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  width: 37,
                                  height: 30,

                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryColor.withAlpha(
                                      50,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$productQuantity',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    border: BoxBorder.all(
                                      style: BorderStyle.solid,
                                      color: AppConstants.primaryColor,
                                    ),
                                    color: AppConstants.backgroundColor,
                                  ),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    onPressed: () {
                                      setState(() {
                                        item['productQuantity']++;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: AppConstants.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
  }

  Widget _buildFavoriteItemsDisplay() {
    return FavComponent();
  }

  Widget _buildCheckoutButton() {
    final List<Map<String, dynamic>> cartItems = products.cartItems;
    return SizedBox(
      width: 375,
      height: 60,
      child: Row(
        children: [
          Text(
            'Total ${currency == 'dollars' ? '\$' : 'GHS'}$totalAmount',
            style: TextStyle(
              fontFamily: AppConstants.fontFamilyRaleway,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          Spacer(),
          CustomButtonWidget(
            buttonTitle: 'Checkout',
            isLoading: false,
            isDisabled: cartItems.isEmpty,
            onPressed: () {
              context.push(
                '/payment',
                extra: {'items': cartItems, 'totalAmount': totalAmount},
              );
            },
          ),
        ],
      ),
    );
  }
}
