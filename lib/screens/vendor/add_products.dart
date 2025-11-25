import 'dart:io';

import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/constants/global_constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final GlobalConstants globalConstants = GlobalConstants();
  final ImagePicker _imagePicker = ImagePicker();

  static const int _maxProductImages = 4;
  String _selectedDeliveryType = 'standard';
  final List<String> _productImages = [];

  bool isLoading = false;

  Future<void> handleImageUpload(ImageSource source) async {
    try {
      if (_productImages.length >= _maxProductImages) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only upload up to 4 images.')),
        );
        return;
      }

      final pickedImage = await _imagePicker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _productImages.add(pickedImage.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An Error Occurred Uploading Image')),
        );
      }
    }
  }

  Future<void> handleSubmit() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 3));

      setState(() async {
        isLoading = false;
        await showSuccessModal(context);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product Addition Failed',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.backgroundColor,
              ),
            ),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
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
          'Add Product',
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
                      title: 'Product Media',
                      child: _buildImageDisplay(),
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

  Widget _buildImageDisplay() {
    final theme = Theme.of(context);
    final canAddMore = _productImages.length < _maxProductImages;

    if (_productImages.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMediaPlaceholder(canAddMore),
          const SizedBox(height: 12),
          _buildMediaHelperText(theme),
        ],
      );
    }

    final mediaTiles = <Widget>[
      ..._productImages.asMap().entries.map(
        (entry) => _buildImagePreview(entry.value, entry.key),
      ),
      if (canAddMore) _buildCompactAddTile(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 135,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 4),
            itemCount: mediaTiles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => mediaTiles[index],
          ),
        ),
        const SizedBox(height: 12),
        _buildMediaHelperText(theme),
      ],
    );
  }

  Widget _buildMediaPlaceholder(bool canAddMore) {
    return InkWell(
      onTap: canAddMore ? () => showSource(context) : null,
      borderRadius: BorderRadius.circular(18),
      child: DottedBorder(
        options: const RectDottedBorderOptions(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppConstants.backgroundColor.withOpacity(0.6),
          ),
          child: Row(
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  size: 30,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Upload product images',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap to add up to $_maxProductImages HD photos (JPG, PNG).',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactAddTile() {
    return GestureDetector(
      onTap: () => showSource(context),
      child: DottedBorder(
        options: const RectDottedBorderOptions(),
        child: Container(
          width: 115,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppConstants.backgroundColor,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: AppConstants.primaryColor,
              ),
              SizedBox(height: 6),
              Text(
                'Add more',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppConstants.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(String imagePath, int index) {
    return SizedBox(
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(File(imagePath), fit: BoxFit.cover),
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: () => _removeImage(index),
              child: Container(
                height: 26,
                width: 26,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaHelperText(ThemeData theme) {
    return Text(
      'Best results with square images, at least 1024px.',
      style: theme.textTheme.bodySmall?.copyWith(
        color: AppConstants.textSecondary,
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      children: [
        _buildTextField(
          'Product Name',
          'Product Name',
          '',
          TextInputType.text,
          (value) {},
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Product Description',
          'Product Description',
          "",
          TextInputType.text,
          (value) {},
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        _buildDropDown(globalConstants.categories, '', 'Category'),
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
                '',
                TextInputType.number,
                (value) {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Discounted Price',
                'Discounted Price',
                '',
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
              value: true,
              onChanged: (value) {},
              activeThumbColor: AppConstants.primaryColor,
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
                '',
                TextInputType.number,
                (value) {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropDown(
                ['In Stock', 'Out of Stock'],
                '',
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
        _buildTextField('Size', 'Size', '', TextInputType.text, (value) {}),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['S', 'M', 'L', 'XL'].map(_buildChip).toList(),
        ),
        const SizedBox(height: 16),
        _buildTextField('Color', 'Color', '', TextInputType.text, (value) {}),
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
    List<dynamic> deliveryOptions = [];

    Map<String, dynamic>? standardOption;
    for (var option in deliveryOptions) {
      if ((option['deliveryType'] ?? '').toString().toLowerCase() ==
          'standard') {
        standardOption = option;
        break;
      }
    }

    final fastDuration = '';
    final fastPrice = '';

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
        'duration': fastDuration,
        'price': fastPrice,
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
            onPressed: isLoading ? null : handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child:
                isLoading
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppConstants.primaryColor,
                      ),
                    )
                    : const Text('Save changes'),
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
      'productId': '',
      'name': '',
      'selectedDeliveryType': _selectedDeliveryType,
      'images': _productImages,
    };

    debugPrint('Ready to send payload: $payload');
    // TODO: integrate with repository/service layer to POST payload to your API.
  }

  Future<void> showSource(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppConstants.borderColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Choose source',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppConstants.primaryText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add crisp, well-lit photos to inspire shopper confidence.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSourceSheetTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Gallery',
                  subtitle: 'Pick an existing photo from your device',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await handleImageUpload(ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 12),
                _buildSourceSheetTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Camera',
                  subtitle: 'Capture a new photo instantly',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await handleImageUpload(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceSheetTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Future<void> Function() onTap,
  }) {
    return Material(
      color: AppConstants.backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppConstants.borderColor),
                ),
                child: Icon(icon, color: AppConstants.primaryColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppConstants.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppConstants.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppConstants.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showSuccessModal(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ModalWidget(
          title: "Successful",
          description: 'Product has been added',
          requiresActionButton: true,
          buttonTitle: 'Go Home',
          buttonAction: () => context.pop(),
        );
      },
    );
  }

  void _removeImage(int index) {
    if (index < 0 || index >= _productImages.length) return;
    setState(() => _productImages.removeAt(index));
  }
}
