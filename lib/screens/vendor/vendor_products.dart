import 'package:bexie_mart/components/empty_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/vendor/vendor_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VendorProducts extends StatefulWidget {
  const VendorProducts({super.key});

  @override
  State<VendorProducts> createState() => _VendorProductsState();
}

class _VendorProductsState extends State<VendorProducts> {
  final VendorData vendorData = VendorData();
  final TextEditingController searchController = TextEditingController();

  String ownerCurrency = 'dollars';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.5,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: AppConstants.primaryText,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            tooltip: 'Sync inventory',
            icon: const Icon(Icons.sync),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(theme),
                    const SizedBox(height: 20),
                    _buildSearchBar(theme),
                    const SizedBox(height: 16),
                    _buildSummaryChips(theme),
                    const SizedBox(height: 24),
                    _buildItemsDisplay(theme),
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
          'Manage your catalog',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Add, edit or pause products to keep your storefront up to date.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search products, SKU or tags',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppConstants.primaryColor),
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
        const SizedBox(width: 12),
        // _buildFilterButton(),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () {
            context.push('/vendor-add-products');
          },
          icon: const Icon(Icons.add),
          label: const Text('New product'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.tune, size: 18),
      label: const Text('Filters'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppConstants.primaryText,
        side: const BorderSide(color: AppConstants.borderColor),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildSummaryChips(ThemeData theme) {
    final products = vendorData.vendorProducts;
    final total = products.length;
    final inStock =
        products.where((item) => (item['productStock'] ?? 0) > 0).length;
    final paused =
        products.where((item) => (item['productStock'] ?? 0) == 0).length;

    Widget buildChip(String label, String value, Color color) {
      return Expanded(
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppConstants.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        buildChip('Total products', '$total', AppConstants.primaryText),
        const SizedBox(width: 12),
        buildChip('In stock', '$inStock', AppConstants.successColor),
        const SizedBox(width: 12),
        buildChip('Out of Stock', '$paused', AppConstants.errorColor),
      ],
    );
  }

  Widget _buildItemsDisplay(ThemeData theme) {
    final products = vendorData.vendorProducts;
    final query = searchController.text.trim().toLowerCase();
    final filtered =
        products.where((item) {
          if (query.isEmpty) return true;
          final productName =
              (item['productName'] ?? '').toString().toLowerCase();
          final description =
              (item['productDescription'] ?? '').toString().toLowerCase();
          return productName.contains(query) || description.contains(query);
        }).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = filtered[index];
        final productImages =
            (item['productImage'] as List?)?.cast<String>() ?? [];
        final productImage =
            productImages.isNotEmpty ? productImages.first : '';
        final productName =
            item['productName']?.toString() ?? 'Unnamed product';
        final description =
            item['productDescription']?.toString() ??
            'No description provided.';

        final productPriceRaw = item['productPrice'];
        final double productPrice =
            productPriceRaw is num
                ? productPriceRaw.toDouble()
                : double.tryParse(productPriceRaw?.toString() ?? '') ?? 0;

        final stock =
            item['productStock'] is int
                ? item['productStock'] as int
                : int.tryParse(item['productStock']?.toString() ?? '') ?? 0;

        return filtered.isEmpty
            ? EmptyWidget()
            : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppConstants.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      imageUrl: productImage,
                      errorWidget:
                          (_, __, ___) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                      placeholder:
                          (_, __) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Product Details Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          productName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Description
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Price
                        Text(
                          '${ownerCurrency == "dollars" ? "\$" : "GHS"} ${productPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Stock Status with colored dot
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: stock > 0 ? Colors.blue : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              stock > 0 ? 'In Stock' : 'Out of Stock',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Edit Icon
                  IconButton(
                    onPressed: () {
                      context.push(
                        '/vendor-products/edit',
                        extra: {'item': item},
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.black87,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
      },
    );
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchController.dispose();
    super.dispose();
  }
}
