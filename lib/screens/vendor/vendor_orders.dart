import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/vendor/vendor_data.dart';
import 'package:flutter/material.dart';

class VendorOrders extends StatefulWidget {
  const VendorOrders({super.key});

  @override
  State<VendorOrders> createState() => _VendorOrdersState();
}

class _VendorOrdersState extends State<VendorOrders> {
  VendorData vendorData = VendorData();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedStatus = 'All';

  List<String> get _availableStatuses {
    final statuses =
        vendorData.vendorOrders
            .map<String>((order) => order['orderStatus'] as String)
            .toSet()
            .toList()
          ..sort();
    return ['All', ...statuses];
  }

  List<Map<String, dynamic>> get _filteredOrders {
    final lowerQuery = _query.toLowerCase();
    return vendorData.vendorOrders.where((order) {
      final matchesQuery =
          lowerQuery.isEmpty ||
          order.values.any(
            (value) => value.toString().toLowerCase().contains(lowerQuery),
          );

      final matchesStatus =
          _selectedStatus == 'All' ||
          order['orderStatus'].toString().toLowerCase() ==
              _selectedStatus.toLowerCase();

      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0.4,
        centerTitle: false,
        foregroundColor: AppConstants.primaryText,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme),
                    const SizedBox(height: 16),
                    _buildSearchBar(theme),
                    const SizedBox(height: 14),
                    _buildStatusFilters(),
                    const SizedBox(height: 18),
                    _buildOrderSummary(theme),
                    const SizedBox(height: 12),
                    _buildOrderDisplay(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Orders',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppConstants.primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Track, fulfill, and stay on top of your customers.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      controller: _searchController,
      onChanged:
          (value) => setState(() {
            _query = value.trim();
          }),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search_outlined),
        hintText: 'Search orders, customers, status...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppConstants.primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon:
            _query.isEmpty
                ? null
                : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
      ),
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildStatusFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _availableStatuses.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final status = _availableStatuses[index];
          final List<String> splitStatus = status.split('');
          String firstCharacter = splitStatus[0].toString().toUpperCase();
          String capitalizedStatus =
              firstCharacter + splitStatus.sublist(1).join('');

          final isSelected = _selectedStatus == status;
          return ChoiceChip(
            label: Text(capitalizedStatus),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedStatus = status),
            selectedColor: AppConstants.primaryColor.withOpacity(0.15),
            labelStyle: TextStyle(
              color:
                  isSelected
                      ? AppConstants.primaryColor
                      : AppConstants.primaryText,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color:
                    isSelected
                        ? AppConstants.primaryColor
                        : AppConstants.borderColor,
              ),
            ),
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(ThemeData theme) {
    final total = vendorData.vendorOrders.length;
    final pending =
        vendorData.vendorOrders
            .where(
              (order) => order['orderStatus'].toString().toLowerCase().contains(
                'pending',
              ),
            )
            .length;
    final delivered =
        vendorData.vendorOrders
            .where(
              (order) => order['orderStatus'].toString().toLowerCase().contains(
                'delivered',
              ),
            )
            .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: Row(
        children: [
          _buildSummaryStat(theme, 'Total', total.toString()),
          _buildDivider(),
          _buildSummaryStat(theme, 'Pending', pending.toString()),
          _buildDivider(),
          _buildSummaryStat(theme, 'Delivered', delivered.toString()),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(ThemeData theme, String label, String value) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppConstants.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 42,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: AppConstants.borderColor,
    );
  }

  Widget _buildOrderDisplay() {
    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppConstants.borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: AppConstants.textSecondary,
            ),
            SizedBox(height: 12),
            Text(
              'No orders match your filters',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryText,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Try adjusting the search or status options.',
              style: TextStyle(color: AppConstants.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final orderNumber = order['orderNumber'].toString();
        final orderStatus = order['orderStatus'] as String;
        final List<String> splitStatus = orderStatus.split('');
        String firstCharacter = splitStatus[0].toString().toUpperCase();
        String capitalizedStatus =
            firstCharacter + splitStatus.sublist(1).join('');
        final orderDate = order['orderDate'] as String;
        final customerName = order['orderCustomerName'] as String;
        final address = order['orderRecipientAddress'] as String;
        final products = List<Map<String, dynamic>>.from(
          order['orderProducts'] as List,
        );

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppConstants.borderColor),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#$orderNumber',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _buildStatusBadge(capitalizedStatus),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      customerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppConstants.primaryText,
                      ),
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text(orderDate),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      address,
                      style: const TextStyle(color: AppConstants.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildProductPreview(products),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Details'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Update status'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color background;
    Color foreground;

    switch (status.toLowerCase()) {
      case 'delivered':
        background = Colors.green.withOpacity(0.15);
        foreground = Colors.green.shade700;
        break;
      case 'pending':
      case 'processing':
        background = Colors.orange.withOpacity(0.15);
        foreground = Colors.orange.shade700;
        break;
      case 'cancelled':
        background = Colors.red.withOpacity(0.15);
        foreground = Colors.red.shade700;
        break;
      default:
        background = AppConstants.primaryColor.withOpacity(0.15);
        foreground = AppConstants.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildProductPreview(List<Map<String, dynamic>> products) {
    final previewProducts = products.take(3).toList();
    final remaining = products.length - previewProducts.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        ...previewProducts.map((product) {
          final name = product['productName'] as String? ?? 'Unknown item';
          final variant = product['productVariant'] as String? ?? '';
          final qty = product['productQuantity'].toString();

          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.inventory_2_outlined, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppConstants.primaryText,
                        ),
                      ),
                      if (variant.isNotEmpty)
                        Text(
                          variant,
                          style: const TextStyle(
                            color: AppConstants.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Text('x$qty'),
              ],
            ),
          );
        }),
        if (remaining > 0)
          Text(
            '+$remaining more item(s)',
            style: const TextStyle(color: AppConstants.textSecondary),
          ),
      ],
    );
  }
}
