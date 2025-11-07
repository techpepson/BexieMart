import 'package:bexie_mart/components/all_items_display_component.dart';
import 'package:bexie_mart/components/empty_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:flutter/material.dart';

class CustomerShop extends StatefulWidget {
  const CustomerShop({super.key});

  @override
  State<CustomerShop> createState() => _CustomerShopState();
}

class _CustomerShopState extends State<CustomerShop> {
  TextEditingController searchFieldController = TextEditingController();

  Future<void> handleSearchFieldChange() async {}
  String ownerCurrency = 'dollars';

  ProductsData products = ProductsData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildItemsDisplay(),
            
          ],
        ),
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return
  // }

  Widget _buildItemsDisplay() {
    List<Map<String, dynamic>> items = products.products;
    return items.isEmpty
        ? EmptyWidget()
        : AllItemsDisplayComponent(items: items, ownerCurrency: ownerCurrency);
  }
}
