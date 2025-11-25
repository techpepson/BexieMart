import 'package:bexie_mart/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VendorOrderDetails extends StatefulWidget {
  VendorOrderDetails({super.key, required this.order});

  final Map<String, dynamic> order;

  @override
  State<VendorOrderDetails> createState() => _VendorOrderDetailsState();
}

class _VendorOrderDetailsState extends State<VendorOrderDetails> {
  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  String ownerCurrency = 'dollars';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    _buildOrderDetails(),
                    SizedBox(height: 16),
                    _buildCustomerDetails(),
                    SizedBox(height: 16),
                    _buildProductDetails(),
                    SizedBox(height: 16),
                    _buildDeliveryAddress(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    String orderNumber = widget.order['orderNumber'] ?? "N/A";
    String orderStatus = widget.order['orderStatus'] ?? "N/A";
    String orderDate = widget.order['orderDate'] ?? "N/A";
    String orderPaymentMethod =
        widget.order['orderPaymentMethod'] ?? 'mobile_money';
    double orderTotalAmount = widget.order['orderTotalAmount'] ?? 0.0;
    List<String> splitStatus = orderStatus.split('');
    String status =
        splitStatus[0].toUpperCase() + splitStatus.sublist(1).join("");
    List<String> splitPaymentMethod = orderPaymentMethod.split('_');
    List<String> splitFirstWord = splitPaymentMethod[0].split("");
    List<String> splitSecondWord = splitPaymentMethod[1].split("");
    String capitalizedFirstWord = splitFirstWord[0].toUpperCase();
    String capitalizedSecondWord = splitSecondWord[0].toUpperCase();
    String joinedFirstWord =
        capitalizedFirstWord + splitFirstWord.sublist(1).join("");
    String joinedSecondWord =
        capitalizedSecondWord + splitSecondWord.sublist(1).join("");

    String paymentMethod = '$joinedFirstWord $joinedSecondWord';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: AppConstants.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Order Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            _buildItem(Icons.confirmation_number, 'Order Number', orderNumber),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.grey[600]),
                SizedBox(width: 12),
                Text(
                  "Status",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                _buildStatusDisplay(status),
              ],
            ),
            SizedBox(height: 16),
            _buildItem(Icons.calendar_today, "Date", orderDate),
            SizedBox(height: 16),
            _buildItem(Icons.payment, "Payment Method", paymentMethod),
            SizedBox(height: 16),
            Divider(height: 24),
            Row(
              children: [
                Icon(Icons.attach_money, size: 20, color: Colors.grey[600]),
                SizedBox(width: 12),
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Text(
                  "${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${orderTotalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetails() {
    String customerName = widget.order['orderCustomerName'] ?? "N/A";
    String customerPhone = widget.order['orderCustomerPhone'] ?? "N/A";
    String customerEmail = widget.order['orderCustomerEmail'] ?? 'N/A';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: AppConstants.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Customer Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            _buildItem(Icons.person_outline, "Customer", customerName),
            SizedBox(height: 16),
            _buildItem(Icons.phone, "Phone", customerPhone),
            SizedBox(height: 16),
            _buildItem(Icons.email, "Email", customerEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    List<Map<String, dynamic>> orderedProducts =
        widget.order['orderProducts'] ?? [];

    if (orderedProducts.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(
              'No products found',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_bag, color: AppConstants.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Ordered Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orderedProducts.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = orderedProducts[index];

                  String itemName = item['productName'] ?? "N/A";
                  int itemQuantity = item['productQuantity'] ?? 1;
                  double productPrice = item['productPrice'] ?? 0.0;
                  String productImage =
                      item['productImage'] != null &&
                              item['productImage'].isNotEmpty
                          ? item['productImage'][0]
                          : '';

                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: productImage,
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                              errorWidget:
                                  (context, url, error) => Container(
                                    width: double.infinity,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                              placeholder:
                                  (context, url) => Container(
                                    width: double.infinity,
                                    height: 100,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            itemName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Qty: $itemQuantity',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${productPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDisplay(String status) {
    Color statusColor;
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        backgroundColor = Colors.orange.shade50;
        break;
      case 'processing':
        statusColor = Colors.blue;
        backgroundColor = Colors.blue.shade50;
        break;
      case 'completed':
      case 'delivered':
        statusColor = Colors.green;
        backgroundColor = Colors.green.shade50;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        backgroundColor = Colors.red.shade50;
        break;
      default:
        statusColor = Colors.grey;
        backgroundColor = Colors.grey.shade50;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String key, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                key,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAddress() {
    String recipientName =
        widget.order['orderRecipientName'] ??
        widget.order['orderCustomerName'] ??
        "N/A";
    String deliveryAddress = widget.order['orderRecipientAddress'] ?? "N/A";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: AppConstants.primaryColor),
                SizedBox(width: 8),
                Text(
                  'Delivery Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
            Divider(height: 24),
            if (recipientName != "N/A" &&
                recipientName != widget.order['orderCustomerName'])
              Column(
                children: [
                  _buildItem(
                    Icons.person_outline,
                    "Recipient Name",
                    recipientName,
                  ),
                  SizedBox(height: 16),
                ],
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.home, size: 20, color: Colors.grey[600]),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        deliveryAddress,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
