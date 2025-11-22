import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/vendor/vendor_data.dart';
import 'package:bexie_mart/services/app_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({super.key});

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  VendorData vendorData = VendorData();

  String ownerCurrency = 'dollars';

  int ownerEarnings = 3250;

  AppServices appServices = AppServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFamily: AppConstants.fontFamilyRaleway,
                        color: AppConstants.textColor,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildOverViewItems(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildSalesSummary(),
                    const SizedBox(height: 24),
                    _buildRecentActivities(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOverViewItems() {
    List<Map<String, dynamic>> vendorProducts = vendorData.vendorProducts;
    List<Map<String, dynamic>> vendorOrders = vendorData.vendorOrders;

    List<Map<String, dynamic>> ordersThisMonth = appServices.getItemsOverMonth(
      vendorOrders,
    );

    List<Map<String, dynamic>> pendingOrders = appServices.getItemByStatus(
      'pending',
      vendorOrders,
    );

    List<Map<String, dynamic>> deliveredOrders = appServices.getItemByStatus(
      'delivered',
      vendorOrders,
    );

    List<Map<String, dynamic>> cancelledOrders = appServices.getItemByStatus(
      'cancelled',
      vendorOrders,
    );

    //use GridView.count to escape itemCount
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildOverviewItem(
          Icons.inventory_2_outlined,
          'Total Products',
          vendorProducts.length.toString(),
          AppConstants.successColor,
        ),
        _buildOverviewItem(
          Icons.shopping_cart_outlined,
          'Orders This Month',
          ordersThisMonth.length.toString(),
          Colors.orange,
        ),
        _buildOverviewItem(
          Icons.account_balance_wallet,
          'Earnings',
          '${ownerCurrency == 'dollars' ? "\$" : 'GHS'} $ownerEarnings',
          Colors.lightGreenAccent,
        ),
        _buildOverviewItem(
          Icons.pending_outlined,
          'Pending Orders',
          pendingOrders.length.toString(),
          AppConstants.errorColor,
        ),
        _buildOverviewItem(
          Icons.check_circle_outline,
          'Delivered Orders',
          deliveredOrders.length.toString(),
          AppConstants.successColor,
        ),
        _buildOverviewItem(
          Icons.cancel_outlined,
          'Cancelled Orders',
          cancelledOrders.length.toString(),
          AppConstants.errorColor,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: 5,
            itemBuilder: (context, index) {
              final actions = [
                {
                  'icon': Icons.add_circle_outline,
                  'title': 'Add Product',
                  'location': '/vendor-add-products',
                },
                {
                  'icon': Icons.shopping_bag_outlined,
                  'title': 'View Orders',
                  'location': '/vendor-orders',
                },
                {
                  'icon': Icons.local_offer_outlined,
                  'title': 'Create Coupon',
                  'location': '',
                },
                {
                  'icon': Icons.trending_up_outlined,
                  'title': 'Check Earnings',
                  'location': '/vendor-earnings',
                },
                {
                  'icon': Icons.account_balance_outlined,
                  'title': 'Withdraw',
                  'location': '',
                },
              ];
              return _buildQuickActionItem(
                actions[index]['icon'] as IconData,
                () => context.push(actions[index]['location'] as String),
                actions[index]['title'] as String,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSalesSummary() {
    List<Map<String, dynamic>> orders = vendorData.vendorOrders;
    List<SalesData> monthlySales = appServices.getMonthlySales(orders);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales Summary',
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withAlpha(50)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  fontFamily: AppConstants.fontFamilyRaleway,
                  fontSize: 12,
                ),
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  fontFamily: AppConstants.fontFamilyRaleway,
                  fontSize: 12,
                ),
              ),
              title: ChartTitle(
                text: 'Monthly Sales',
                textStyle: TextStyle(
                  fontFamily: AppConstants.fontFamilyRaleway,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              legend: const Legend(isVisible: false),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: [
                LineSeries<SalesData, String>(
                  dataSource: monthlySales,
                  xValueMapper: (SalesData data, _) => data.month,
                  yValueMapper: (SalesData data, _) => data.totalAmount,
                  color: AppConstants.primaryColor,
                  width: 3,
                  markerSettings: const MarkerSettings(
                    isVisible: true,
                    height: 6,
                    width: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    List<Map<String, dynamic>> logs = vendorData.vendorLogs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ...logs.take(10).map((log) {
          String logTitle = log['logTitle'] ?? "";
          String logDesc = log['logDescription'] ?? "";
          String logDateAsString = log['logDate'];
          DateTime parsedLogDate = appServices.parseStringToDate(
            logDateAsString,
          );

          DateTime now = DateTime.now();
          Duration difference = now.difference(parsedLogDate);

          String timeAgo;
          if (difference.inMinutes < 60) {
            timeAgo = '${difference.inMinutes} mins ago';
          } else if (difference.inHours < 24) {
            timeAgo = '${difference.inHours} hours ago';
          } else {
            timeAgo = '${difference.inDays} days ago';
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withAlpha(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: AppConstants.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (logTitle.isNotEmpty)
                        Text(
                          logTitle,
                          style: TextStyle(
                            fontFamily: AppConstants.fontFamilyRaleway,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppConstants.textColor,
                          ),
                        ),
                      if (logTitle.isNotEmpty) const SizedBox(height: 4),
                      Text(
                        logDesc,
                        style: TextStyle(
                          fontFamily: AppConstants.fontFamilyRaleway,
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: AppConstants.textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontFamily: AppConstants.fontFamilyRaleway,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildOverviewItem(
    IconData icon,
    String title,
    String count,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(
              fontFamily: AppConstants.fontFamilyRaleway,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              color: AppConstants.textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppConstants.fontFamilyRaleway,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    IconData icon,
    void Function()? onTap,
    String actionText,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.grey.withAlpha(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppConstants.backgroundColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            actionText,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppConstants.fontFamilyRaleway,
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: AppConstants.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
