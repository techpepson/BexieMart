import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/components/payment_processing.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/payment_data.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  PaymentData paymentData = PaymentData();

  String defaultPaymentMethod = 'mobile_money';

  AppServices appServices = AppServices();

  Map<String, dynamic> selectedOptionMap = {};

  bool isStandardSelected = true;

  String _selectedDeliveryOption = 'standard';

  double duePaymentAmount = 0.0;

  final ProductsData productsData = ProductsData();

  String ownerCurrency = 'dollars';

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool isProceedingToPay = false;

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

  Future<void> proceedToPay() async {
    try {
      setState(() {
        isProceedingToPay = true;
      });

      // Step 1: Show loading modal
      await showLoadingModal();

      // Step 2: Wait for 3 seconds (simulate payment)
      await Future.delayed(const Duration(seconds: 3), () async {
        // Step 4: Show success modal
        if (mounted) {
          await showSuccessModal();
        }
      });

      setState(() {
        isProceedingToPay = false;
      });
    } catch (e) {
      setState(() {
        isProceedingToPay = false;
      });
      if (mounted) {
        await showErrorModal();
      }

      setState(() {
        isProceedingToPay = false;
      });
    }
  }

  Map<String, dynamic>? appliedCoupon;
  String? appliedCouponMessage;

  Future<void> applyCoupon(Map<String, dynamic> discount) async {
    try {
      String discountType = discount['discountType'] ?? '';
      double discountRate = (discount['discountRate'] ?? 0).toDouble();

      double newAmount = widget.totalAmount;
      if (appliedCoupon != null &&
          appliedCoupon!['discountTitle'] == discount['discountTitle']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('This coupon is already applied.'),
            backgroundColor: AppConstants.accentColor,
          ),
        );
        if (mounted) {
          context.pop();
        }
        return;
      }

      // Apply the discount
      if (discountType == 'percentage') {
        newAmount =
            widget.totalAmount - (widget.totalAmount * (discountRate / 100));

        setState(() {
          duePaymentAmount = newAmount;
        });
      } else if (discountType == 'fixed') {
        newAmount = widget.totalAmount - discountRate;
        setState(() {
          duePaymentAmount = newAmount;
        });
      }

      // Ensure total doesn’t go below zero
      if (newAmount < 0) newAmount = 0;

      setState(() {
        duePaymentAmount = newAmount;
        appliedCoupon = discount;
        appliedCouponMessage = 'Coupon "${discount['discountTitle']}" applied!';
      });

      // Close the coupon sheet
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appliedCouponMessage ?? 'Coupon applied!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to apply coupon: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      duePaymentAmount = widget.totalAmount;
    });
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SizedBox(
        width: 375,
        child: Row(
          children: [
            Text(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontFamily: AppConstants.fontFamilyRaleway,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
              'Total ${ownerCurrency == 'dollars' ? '\$' : 'GHS'} $duePaymentAmount',
            ),
            Spacer(),
            CustomButtonWidget(
              buttonTitle: 'Pay',
              isDisabled: false,
              onPressed: () async {
                if (mounted) {
                  await proceedToPay();
                }
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildEditableFields(),
                    SizedBox(height: 12),
                    _buildItemsDisplay(),
                    SizedBox(height: 12),
                    _buildDeliveryOptions(),
                    SizedBox(height: 12),
                    _buildPaymentMethod(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 8),

        // --- Delivery Address Section ---
        isEditingAddress
            ? TextField(
              controller: _addressController,
              onChanged: (value) => setState(() => deliveryAddress = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppConstants.greyedColor.withAlpha(120),
                labelText: 'Delivery Address',
                hintText: deliveryAddress,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: toggleEdit,
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: AppConstants.successColor,
                  ),
                ),
              ),
            )
            : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.errorColor.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
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
                        const SizedBox(height: 4),
                        Text(
                          deliveryAddress,
                          overflow: TextOverflow.ellipsis,
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
                  ),
                  IconButton(
                    onPressed: toggleEdit,
                    icon: Icon(Icons.edit, color: AppConstants.primaryColor),
                  ),
                ],
              ),
            ),

        const SizedBox(height: 16),

        // --- Contact Info Section ---
        isEditingContact
            ? TextField(
              controller: _contactController,
              onChanged: (value) => setState(() => contactAddress = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppConstants.greyedColor.withAlpha(120),
                labelText: 'Contact Information',
                hintText: contactAddress,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  onPressed: toggleEditContact,
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: AppConstants.successColor,
                  ),
                ),
              ),
            )
            : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppConstants.errorColor.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
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
                        const SizedBox(height: 4),
                        Text(
                          contactAddress,
                          overflow: TextOverflow.ellipsis,
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
                  ),
                  IconButton(
                    onPressed: toggleEditContact,
                    icon: Icon(Icons.edit, color: AppConstants.primaryColor),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildItemsDisplay() {
    final List<Map<String, dynamic>> items = widget.items;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 339,
          height: 120,
          child: Row(
            children: [
              Text(
                'Items',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: AppConstants.fontFamilyRaleway,
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                  color: AppConstants.textColor,
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withAlpha(30),
                ),
                child: Center(
                  child: Text(
                    widget.items.length.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textColor,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppConstants.primaryColor,
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  showCoupons();
                },
                child: Text(
                  'Add Coupons',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 240,
          child: ListView.builder(
            itemCount: widget.items.length,
            physics: BouncingScrollPhysics(),
            itemExtent: 70.0,
            itemBuilder: (context, index) {
              final int productQuantity = items[index]['productQuantity'] ?? 1;

              final String productImage = items[index]['productImage'][0] ?? "";

              final String productName =
                  items[index]['productName'] ??
                  "No name found for this product";
              double unitPrice = items[index]['productPrice'] ?? 0.0;
              double totalItemPrice = unitPrice * productQuantity;
              return Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2.0,
                            color: AppConstants.backgroundColor,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: productImage,
                            errorWidget:
                                (context, url, error) =>
                                    Icon(Icons.broken_image),
                            placeholder:
                                (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              productQuantity.toString(),
                              style: const TextStyle(
                                color: AppConstants.backgroundColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 8),

                  SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        Text(
                          productName.toString(),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontFamily: AppConstants.fontFamilyNunito,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${ownerCurrency == 'dollars' ? "\$" : "GHS"}$totalItemPrice',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            fontFamily: AppConstants.fontFamilyRaleway,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
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
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    List<Map<String, dynamic>> deliveryOptions = productsData.deliveryOptions;
    final optionMap = selectedOptionMap;
    final daysToDelivery = optionMap['daysToDelivery'] ?? 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Options',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 21,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: deliveryOptions.length,
          itemBuilder: (context, index) {
            final option = deliveryOptions[index];
            final deliveryType = option['deliveryType'] ?? 'standard';
            final daysToDelivery = option['daysToDelivery'] ?? 5;
            final deliveryFee = option['deliveryFee'] ?? 0.0;
            final isSelected = _selectedDeliveryOption == deliveryType;

            final String formattedType =
                deliveryType[0].toUpperCase() +
                deliveryType.substring(1).toLowerCase();

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedOptionMap = option;
                  _selectedDeliveryOption = deliveryType;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppConstants.primaryColor.withAlpha(35)
                          : AppConstants.greyedColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppConstants.primaryColor
                            : Colors.transparent,
                    width: 1.5,
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     blurRadius: 4,
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color:
                          isSelected
                              ? AppConstants.primaryColor
                              : AppConstants.textColor.withOpacity(0.6),
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedType,
                            style: TextStyle(
                              fontFamily: AppConstants.fontFamilyRaleway,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppConstants.textColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "$daysToDelivery days delivery",
                            style: TextStyle(
                              fontFamily: AppConstants.fontFamilyRaleway,
                              fontSize: 13,
                              color: AppConstants.textColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      deliveryFee == 0.0
                          ? "FREE"
                          : "${ownerCurrency == 'dollars' ? '\$' : 'GHS'}${deliveryFee.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyRaleway,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color:
                            isSelected
                                ? AppConstants.primaryColor
                                : AppConstants.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        if (optionMap['daysToDelivery'] != null)
          Text(
            'Estimated delivery: ${getDuration(daysToDelivery).toLocal().toString().split(" ")[0]}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppConstants.textColor,
              fontFamily: AppConstants.fontFamilyRaleway,
              fontSize: 16,
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    //format the method name
    List<String> methodArray = defaultPaymentMethod.split('_');

    String capitalizedFirstLetter = methodArray[0].split('')[0].toUpperCase();
    String capitalizedSecondWord = methodArray[1].split('')[0].toUpperCase();
    String joinedMethodName =
        capitalizedFirstLetter +
        methodArray[0].substring(1) +
        " " +
        capitalizedSecondWord +
        methodArray[1].substring(1);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 400,
          child: Row(
            children: [
              Text(
                "Payment Method",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: AppConstants.fontFamilyRaleway,
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                ),
              ),
              Spacer(),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    showPaymentMethods();
                  },
                  icon: Icon(Icons.edit, color: AppConstants.backgroundColor),
                ),
              ),
            ],
          ),
        ),
        Text(joinedMethodName),
      ],
    );
  }

  void showCoupons() {
    List<Map<String, dynamic>> cartItems = widget.items;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              final List<dynamic> discounts = item['discounts'] ?? [];

              // ✅ Skip if there are no discounts
              if (discounts.isEmpty) {
                return ListTile(
                  title: Text(item['productName'] ?? 'Unknown Product'),
                  subtitle: const Text("No coupons available."),
                );
              }

              // ✅ Show coupons
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['productName'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    itemCount: discounts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, discountIndex) {
                      final discount = discounts[discountIndex];

                      String validCouponDuration =
                          discount['discountEndDate'] ?? "";
                      double discountRate =
                          (discount['discountRate'] ?? 0.0).toDouble();
                      String discountDescription =
                          discount['discountDescription'] ?? "";
                      String discountTitle = discount['discountTitle'] ?? "";
                      String discountType = discount['discountType'] ?? "";

                      // ✅ Check expiration
                      DateTime parsedEndDate = appServices.parseStringToDate(
                        validCouponDuration,
                      );
                      bool isCouponExpired = parsedEndDate.isBefore(
                        DateTime.now(),
                      );

                      int day = parsedEndDate.day;
                      int month = parsedEndDate.month;
                      int year = parsedEndDate.year;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withAlpha(40),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(discountTitle),
                                isCouponExpired
                                    ? const Text(
                                      'Coupon expired',
                                      style: TextStyle(color: Colors.red),
                                    )
                                    : Text('Valid until $day.$month.$year'),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const DottedDashedLine(
                              height: 1,
                              width: 336,
                              axis: Axis.horizontal,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              discountDescription,
                              style: const TextStyle(fontSize: 13),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  discountType == 'percentage'
                                      ? '$discountRate% off your order'
                                      : '${ownerCurrency == 'dollars' ? '\$' : 'GHS'}$discountRate off your order',
                                ),
                                CustomButtonWidget(
                                  buttonTitle: 'Apply',
                                  isDisabled: isCouponExpired,
                                  isLoading: false,
                                  onPressed: () async {
                                    await applyCoupon(discount);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showPaymentMethods() {
    final paymentMethods = paymentData.paymentMethods;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Text(
                'Select Payment Method',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamilyRaleway,
                  color: AppConstants.textColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),

              // --- Payment Methods List ---
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paymentMethods.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  final methodName = method['methodName'] ?? '';

                  // Format name: e.g., "mobile_money" → "Mobile Money"
                  final formattedName = methodName
                      .split('_')
                      .map(
                        (word) =>
                            word.isNotEmpty
                                ? '${word[0].toUpperCase()}${word.substring(1)}'
                                : '',
                      )
                      .join(' ');

                  final isDebitCard = methodName == 'debit_card';
                  final isSelected = defaultPaymentMethod == methodName;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        defaultPaymentMethod = methodName;
                      });
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            isSelected
                                ? AppConstants.primaryColor.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.05),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppConstants.primaryColor
                                  : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // --- Icon or Image ---
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              isDebitCard
                                  ? 'assets/images/debit.jpg'
                                  : 'assets/images/momo.jpg',
                              width: 50,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // --- Method Name ---
                          Expanded(
                            child: Text(
                              formattedName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConstants.fontFamilyRaleway,
                                color: AppConstants.textColor,
                              ),
                            ),
                          ),

                          // --- Check Icon ---
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppConstants.primaryColor,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> showLoadingModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          width: 300,
          child: PaymentProcessingWidget(
            title: 'Payment is in progress',
            requiresAction: false,
            description: 'Please wait while we process your payment',
            buttonTitle: 'OK',
            buttonAction: () {},
          ),
        );
      },
    );
  }

  Future<dynamic> showSuccessModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return ModalWidget(
          title: 'Payment is successful',
          description: 'Your payment has been processed successfully',
          buttonTitle: 'Track Order',
          buttonAction: () {
            if (mounted) {
              context.pop();
            }
          },
        );
      },
    );
  }

  Future<dynamic> showErrorModal() {
    return showDialog(
      context: context,
      builder: (context) {
        return ModalWidget(
          title: 'Payment Failed',
          description: 'Payment Processing Failed. Please Try Again.',
          buttonTitle: 'Try Again',
          buttonAction: () {
            context.pop();
          },
        );
      },
    );
  }
}
