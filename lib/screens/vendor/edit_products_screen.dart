import 'dart:io';

import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/constants/global_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProductsScreen extends StatefulWidget {
  const EditProductsScreen({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final GlobalConstants globalConstants = GlobalConstants();
  final ImagePicker _imagePicker = ImagePicker();

  String _selectedDeliveryType = 'standard';
  List<String> _productImages = [];

  @override
  void initState() {
    super.initState();
    _productImages =
        (widget.item['productImage'] as List<dynamic>? ?? [])
            .map((img) => img.toString())
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'Edit product',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppConstants.primaryText,
          ),
        ),
        iconTheme: const IconThemeData(color: AppConstants.primaryText),
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
                    _buildPageHeader(theme),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: 'Media',
                      child: _buildProductImages(),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Product details',
                      child: _buildProductDetails(),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Pricing',
                      child: _buildPricingDisplay(),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Stock & inventory',
                      child: _buildStockInventory(),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Variations',
                      child: _buildVariations(),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Delivery options',
                      child: _buildDeliveryOptions(),
                    ),
                    const SizedBox(height: 24),
                    _buildButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.item['productName'] ?? 'Unnamed product',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Keep fields consistent so buyers can trust the information.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppConstants.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildProductImages() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 110,
            child:
                _productImages.isEmpty
                    ? Center(
                      child: Text(
                        'No images yet',
                        style: TextStyle(
                          color: AppConstants.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    )
                    : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder:
                          (context, index) => const SizedBox(width: 12),
                      itemCount: _productImages.length,
                      itemBuilder: (context, index) {
                        final image = _productImages[index];
                        return _buildImagePreview(image, index);
                      },
                    ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _handleAddImage,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppConstants.borderColor),
            ),
            child: const Icon(Icons.add_photo_alternate_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(String image, int index) {
    final bool isRemote = image.startsWith('http');

    final Widget imageWidget =
        isRemote
            ? CachedNetworkImage(
              width: 110,
              height: 110,
              fit: BoxFit.cover,
              imageUrl: image,
              errorWidget:
                  (context, url, error) => Container(
                    width: 110,
                    height: 110,
                    color: AppConstants.greyedColor,
                    child: const Icon(Icons.broken_image),
                  ),
            )
            : Image.file(
              File(image),
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            );

    return Stack(
      alignment: Alignment.topRight,
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: imageWidget),
        Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(140),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
            ],
          ),
          child: IconButton(
            onPressed: () => _removeImage(index),
            icon: Icon(Icons.delete, color: AppConstants.errorColor),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDetails() {
    return Column(
      children: [
        _buildTextField(
          'Product Name',
          'Product Name',
          widget.item['productName'],
          TextInputType.text,
          (value) {},
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Product Description',
          'Product Description',
          widget.item['productDescription'],
          TextInputType.text,
          (value) {},
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        _buildDropDown(
          globalConstants.categories,
          widget.item['productCategory'],
          'Category',
        ),
      ],
    );
  }

  Widget _buildPricingDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Regular Price',
                'Regular Price',
                widget.item['productPrice'].toString(),
                TextInputType.number,
                (value) {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Discounted Price',
                'Discounted Price',
                widget.item['productDiscount'].toString(),
                TextInputType.number,
                (value) {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Show Discount Badge',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Switch(
              value: (widget.item['productDiscount'] ?? 0) > 0,
              onChanged: (value) {},
              activeColor: AppConstants.primaryColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStockInventory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Stock Quantity',
                'Quantity in Stock',
                widget.item['productStock'].toString(),
                TextInputType.number,
                (value) {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropDown(
                ['In Stock', 'Out of Stock'],
                widget.item['productStock'] > 0 ? 'In Stock' : 'Out of Stock',
                "Stock Status",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVariations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        _buildTextField(
          'Size',
          'Size',
          widget.item['productSize'] ?? "",
          TextInputType.text,
          (value) {},
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['S', 'M', 'L', 'XL'].map(_buildChip).toList(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Color',
          'Color',
          widget.item['productColor'],
          TextInputType.text,
          (value) {},
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              ['Pink', 'Brown', 'White', 'Yellow'].map(_buildChip).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String content) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: Text(content, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildDeliveryOptions() {
    List<dynamic> deliveryOptions =
        (widget.item['deliveryOptions'] as List<dynamic>?) ?? [];

    Map<String, dynamic>? standardOption;
    for (var option in deliveryOptions) {
      if ((option['deliveryType'] ?? '').toString().toLowerCase() ==
          'standard') {
        standardOption = option;
        break;
      }
    }

    final fastDuration = widget.item['deliveryDuration'] ?? '30 - 60 mins';
    final fastPrice = widget.item['deliveryFare'] ?? 0;

    final options = [
      {
        'key': 'standard',
        'title': 'Standard',
        'duration':
            standardOption != null
                ? '${standardOption['daysToDelivery']} ${standardOption['unitOfDelivery']}'
                : '3 - 5 business days',
        'price': (standardOption?['deliveryFee'] ?? 0).toString(),
        'icon': Icons.inventory_2_outlined,
        'description': 'Affordable shipping for non-urgent items.',
      },
      {
        'key': 'fast',
        'title': 'Fast',
        'duration':
            fastDuration is String ? fastDuration : fastDuration.toString(),
        'price': fastPrice.toString(),
        'icon': Icons.flash_on_outlined,
        'description': 'Prioritized dispatch for quick deliveries.',
      },
    ];

    return Column(
      children:
          options.map((option) {
            final key = option['key'] as String;
            final bool isSelected = _selectedDeliveryType == key;
            return Container(
              margin: EdgeInsets.only(bottom: option == options.last ? 0 : 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      isSelected
                          ? AppConstants.primaryColor
                          : AppConstants.borderColor,
                ),
                color:
                    isSelected
                        ? AppConstants.primaryColor.withOpacity(0.04)
                        : Colors.white,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _selectedDeliveryType = key),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: key,
                          groupValue: _selectedDeliveryType,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedDeliveryType = value);
                            }
                          },
                          activeColor: AppConstants.primaryColor,
                        ),
                        Icon(
                          option['icon'] as IconData,
                          color: AppConstants.primaryText,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          option['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppConstants.primaryText,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          option['price'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      option['description'] as String,
                      style: const TextStyle(color: AppConstants.textSecondary),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 18,
                          color: AppConstants.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(option['duration'] as String),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: AppConstants.borderColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Discard'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Save changes'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String fieldTitle,
    String fieldLabel,
    String fieldHint,
    TextInputType keyboardType,
    void Function(String)? onChanged, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: fieldLabel,
            hintText: fieldHint,
            filled: true,
            fillColor: AppConstants.backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppConstants.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppConstants.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppConstants.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropDown(
    List<String> items,
    String currentCategory,
    String fieldTitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppConstants.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, loadProps) => items,
          selectedItem: currentCategory,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppConstants.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppConstants.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppConstants.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppConstants.primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          compareFn: (item1, item2) => item1 == item2,
          popupProps: const PopupProps.menu(fit: FlexFit.loose),
        ),
      ],
    );
  }

  void _handleSave() {
    final payload = {
      'productId': widget.item['productId'],
      'name': widget.item['productName'],
      'selectedDeliveryType': _selectedDeliveryType,
      'images': _productImages,
    };

    debugPrint('Ready to send payload: $payload');
    // TODO: integrate with repository/service layer to POST payload to your API.
  }

  Future<void> _handleAddImage() async {
    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedImage != null) {
        setState(() => _productImages.add(pickedImage.path));
      }
    } catch (e) {
      debugPrint('Image pick failed: $e');
    }
  }

  void _removeImage(int index) {
    if (index < 0 || index >= _productImages.length) return;
    setState(() => _productImages.removeAt(index));
  }
}
