import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/payment_data.dart';
import 'package:bexie_mart/data/vendor/vendor_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class VendorEarnings extends StatefulWidget {
  const VendorEarnings({super.key});

  @override
  State<VendorEarnings> createState() => _VendorEarningsState();
}

class _VendorEarningsState extends State<VendorEarnings> {
  VendorData vendorData = VendorData();
  AppServices appServices = AppServices();

  PaymentData paymentData = PaymentData();

  String ownerCurrency = 'dollars';

  double pendingBalance = 300.0;

  double availableBalance = 950.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Earnings',
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
                    _buildCards(),
                    SizedBox(height: 24),
                    _buildWithdrawalButton(),
                    SizedBox(height: 24),
                    _buildRecentEarnings(),
                    SizedBox(height: 24),
                    _buildWithdrawalHistory(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCards() {
    List<Map<String, dynamic>> completedOrders = appServices.getItemByStatus(
      'completed',
      vendorData.vendorOrders,
    );

    List<Map<String, dynamic>> itemsThisMonth = appServices.getItemsThisMonth(
      completedOrders,
    );

    double totalEarningsThisMonth = itemsThisMonth.fold<double>(
      0.0,
      (previousElement, element) =>
          previousElement + element['orderTotalAmount'],
    );

    double totalEarnings = completedOrders.fold(
      0.0,
      (previousElement, currentElement) =>
          previousElement + currentElement['orderTotalAmount'],
    );

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildCard(
          Icons.account_balance_wallet,
          "Total Earnings",
          '${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${totalEarnings.toStringAsFixed(2)}',
          Colors.blue,
        ),
        _buildCard(
          Icons.calendar_today,
          "Earnings This Month",
          '${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${totalEarningsThisMonth.toStringAsFixed(2)}',
          Colors.blue,
        ),
        _buildCard(
          Icons.pending,
          'Pending Balance',
          "${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${pendingBalance.toStringAsFixed(2)}",
          Colors.blue,
        ),
        _buildCard(
          Icons.check_circle,
          'Available Balance',
          "${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${availableBalance.toStringAsFixed(2)}",
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildWithdrawalButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: CustomButtonWidget(
        buttonTitle: "Request Withdrawal",
        onPressed: () {
          context.push('/vendor-earnings/payment-screen');
        },
        isDisabled: false,
      ),
    );
  }

  Widget _buildRecentEarnings() {
    List<Map<String, dynamic>> earningsLogs = vendorData.recentEarnings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, color: AppConstants.textColor),
            SizedBox(width: 8),
            Text(
              'Recent Earnings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        earningsLogs.isEmpty
            ? Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No recent earnings',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: earningsLogs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> log = earningsLogs[index];

                String earningNumber = log['earningNumber'] ?? "N/A";
                double earningAmount = log['earningAmount'] ?? 0.0;
                String status = log['earningStatus'] ?? 'pending';
                String logDate = log['earningDate'] ?? "N/A";
                String formatDate;
                try {
                  DateTime parsedDate = appServices.parseStringToDate(logDate);
                  formatDate = DateFormat('MMM dd, yyyy').format(parsedDate);
                } catch (e) {
                  formatDate = logDate;
                }

                List<String> splitStatus = status.split("");
                String capitalizedStatus =
                    status[0].toUpperCase() + splitStatus.sublist(1).join("");

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                earningNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${earningAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    formatDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(capitalizedStatus),
                      ],
                    ),
                  ),
                );
              },
            ),
      ],
    );
  }

  Widget _buildWithdrawalHistory() {
    List<Map<String, dynamic>> withdrawalLogs = vendorData.withdrawalHistory;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, color: Colors.grey[900]),
            SizedBox(width: 8),
            Text(
              'Withdrawal History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.textColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        withdrawalLogs.isEmpty
            ? Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No withdrawal history',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: withdrawalLogs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> log = withdrawalLogs[index];

                String withdrawalNumber = log['withdrawalId'] ?? "N/A";
                double withdrawalAmount = log['withdrawalAmount'] ?? 0.0;
                String status = log['withdrawalStatus'] ?? 'pending';
                String logDate = log['withdrawalDate'] ?? "N/A";
                String formatDate;
                try {
                  DateTime parsedDate = appServices.parseStringToDate(logDate);
                  formatDate = DateFormat('MMM dd, yyyy').format(parsedDate);
                } catch (e) {
                  formatDate = logDate;
                }

                List<String> splitStatus = status.split("");
                String capitalizedStatus =
                    status[0].toUpperCase() + splitStatus.sublist(1).join("");

                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                withdrawalNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${ownerCurrency == 'dollars' ? "\$" : "GHS"} ${withdrawalAmount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    formatDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildStatusBadge(capitalizedStatus),
                      ],
                    ),
                  ),
                );
              },
            ),
      ],
    );
  }

  Widget _buildCard(IconData icon, String heading, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              heading,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
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
      case 'approved':
        statusColor = Colors.green;
        backgroundColor = Colors.green.shade50;
        break;
      case 'cancelled':
      case 'rejected':
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

  Future<dynamic> showWithdrawalMethod(BuildContext context) {
    List<Map<String, dynamic>> paymentMethods = paymentData.paymentMethods;
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Expanded(child: TextField()),
            DropdownSearch(items: (filter, loadProps) => paymentMethods),
          ],
        );
      },
    );
  }
}
