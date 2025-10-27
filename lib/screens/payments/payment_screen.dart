import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({super.key, required this.items, required this.totalAmount});

  List<Map<String, dynamic>> items;
  double totalAmount;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String deliveryAddress = 'Accra, Ghana';
  String contactAddress = '+233551875432';
  bool isEditingAddress = false;
  bool isEditingContact = false;

  AppServices appServices = AppServices();

  Map<String, dynamic> selectedOptionMap = {};

  bool isStandardSelected = true;

  String _selectedDeliveryOption = 'standard';

  double duePaymentAmount = 0.0;

  final ProductsData productsData = ProductsData();

  String ownerCurrency = 'dollars';

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  void toggleEdit() {
    setState(() {
      isEditingAddress = !isEditingAddress;
    });
  }

  void toggleEditContact() {
    setState(() {
      isEditingContact = !isEditingContact;
    });
  }

  DateTime getDuration(int days) {
    return appServices.getDaysDuration(days);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildEditableFields(),
                  SizedBox(height: 12),
                  _buildItemsDisplay(),
                  SizedBox(height: 12),
                  _buildDeliveryOptions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableFields() {
    return Padding(
      padding: const EdgeInsets.all(26.0),
      child: Column(
        children: [
          Text('Payment'),
          isEditingAddress == false
              ? Container(
                width: 335,
                height: 70,
                decoration: BoxDecoration(
                  color: AppConstants.errorColor.withAlpha(40),
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
                height: 70,
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

          SizedBox(height: 16),

          isEditingContact == false
              ? Container(
                width: 335,
                height: 70,
                decoration: BoxDecoration(
                  color: AppConstants.errorColor.withAlpha(40),
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
                            'Contact Information',
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
                            contactAddress.toString(),
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
                              toggleEditContact();
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
                height: 70,
                width: 335,
                child: TextField(
                  controller: _contactController,
                  onChanged: (value) {
                    setState(() {
                      contactAddress = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppConstants.greyedColor.withAlpha(120),
                    hint: Text(contactAddress.toString()),
                    label: Text('Contact Information'),
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
                        toggleEditContact();
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
      ),
    );
  }

  Widget _buildItemsDisplay() {
    final List<Map<String, dynamic>> items = widget.items;
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Text('Items'),
              Text(widget.items.length.toString()),
              OutlinedButton(onPressed: () {}, child: Text('Add Coupons')),
            ],
          ),

          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: widget.items.length,
              physics: PageScrollPhysics(),
              itemBuilder: (context, index) {
                final int productQuantity =
                    items[index]['productQuantity'] ?? 1;

                final String productImage =
                    items[index]['productImage'][0] ?? "";

                final String productName =
                    items[index]['productName'] ??
                    "No name found for this product";
                double unitPrice = items[index]['productPrice'] ?? 0.0;
                double totalItemPrice = unitPrice * productQuantity;
                return Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            child: CachedNetworkImage(
                              height: 30,
                              width: 30,
                              imageUrl: productImage,
                              errorWidget:
                                  (context, url, error) =>
                                      Icon(Icons.broken_image),
                              placeholder:
                                  (context, url) => CircularProgressIndicator(
                                    color: AppConstants.primaryColor,
                                  ),
                            ),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            child: Text(productQuantity.toString()),
                          ),
                        ),
                      ],
                    ),

                    Text(productName.toString()),

                    Text(
                      '${ownerCurrency == 'dollars' ? "\$" : "GHS"} $totalItemPrice',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptions() {
    List<Map<String, dynamic>> deliveryOptions = productsData.deliveryOptions;
    final optionMap = selectedOptionMap;
    final daysToDelivery = optionMap['daysToDelivery'] ?? 5;

    return Column(
      children: [
        Text('Delivery Options'),
        Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: deliveryOptions.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> option = deliveryOptions[index];
                String deliveryType = option['deliveryType'] ?? 'standard';
                final splitDeliveryType = deliveryType.split('');

                final capitalizedFirstLetter =
                    splitDeliveryType[0].toUpperCase();

                final joinDeliveryType =
                    capitalizedFirstLetter +
                    splitDeliveryType.sublist(1).join('');
                String unitOfDelivery = option['unitOfDelivery'] ?? 'days';

                int daysToDelivery = option['daysToDelivery'] ?? 5;

                double deliveryFee = option['deliveryFee'];
                int optionId = option['optionId'] ?? 1;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOptionMap = option;
                    });
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(),
                        Text(joinDeliveryType.toString()),
                        Container(
                          child: Text("$daysToDelivery $unitOfDelivery"),
                        ),
                        Text(
                          "${deliveryFee == 0.0 ? "FREE" : "${ownerCurrency == 'dollars' ? "\$" : "GHS"}$deliveryFee"}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        optionMap['daysToDelivery'] != null
            ? Text('Delivered on or before ${getDuration(daysToDelivery)}')
            : SizedBox(),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Container();
  }

  void showCoupons() {}

  void showPaymentMethods() {}
}
