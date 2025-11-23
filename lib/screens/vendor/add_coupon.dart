import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/form_field.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCoupon extends StatefulWidget {
  const AddCoupon({super.key});

  @override
  State<AddCoupon> createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {
  bool isFirstPurchaseOnly = true;
  String? selectedDiscountType;
  DateTime? selectedDate;
  final TextEditingController validUntilController = TextEditingController();

  @override
  void dispose() {
    validUntilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildTitle(),
                    const SizedBox(height: 32),
                    _buildFormFields(),
                    const SizedBox(height: 16),
                    _buildDiscountType(),
                    const SizedBox(height: 16),
                    _buildValidity(),
                    const SizedBox(height: 16),
                    _buildDescription(),
                    const SizedBox(height: 24),
                    _buildFirstPurchase(),
                    const SizedBox(height: 32),
                    _buildCreateButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          color: AppConstants.textColor,
        ),
        const SizedBox(width: 8),
        Text(
          'Back',
          style: TextStyle(
            fontSize: 16,
            color: AppConstants.textColor,
            fontWeight: AppConstants.fontWeightMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Create Coupon',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppConstants.textColor,
        fontFamily: AppConstants.fontFamilyNunito,
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        CustomFormField(labelText: 'Coupon Title', hintText: 'Coupon Title'),
        const SizedBox(height: 16),
        CustomFormField(labelText: 'Coupon Code', hintText: 'Coupon Code'),
      ],
    );
  }

  Widget _buildDiscountType() {
    const List<String> discountTypes = ['percentage', 'fixed_amount'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownSearch<String>(
          items: (filter, loadProps) => discountTypes,
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            menuProps: MenuProps(borderRadius: BorderRadius.circular(16)),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: 'Discount Type',
              hintText: 'Discount Type',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16),
              ),
              fillColor: AppConstants.greyedColor.withAlpha(70),
              filled: true,
              labelStyle: TextStyle(
                color: AppConstants.textColor.withAlpha(90),
              ),
              hintStyle: TextStyle(color: AppConstants.textColor.withAlpha(90)),
            ),
          ),
          onChanged: (value) {
            setState(() {
              selectedDiscountType = value;
            });
          },
          selectedItem: selectedDiscountType,
          compareFn: (item1, item2) => item1 == item2,
        ),
      ],
    );
  }

  Widget _buildValidity() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Valid Until',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textColor.withAlpha(90),
                  fontWeight: AppConstants.fontWeightMedium,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showSelectPeriod(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.greyedColor.withAlpha(70),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate == null
                              ? ''
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                selectedDate == null
                                    ? AppConstants.textColor.withAlpha(90)
                                    : AppConstants.textColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: AppConstants.textColor.withAlpha(90),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Usage Limit',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.textColor.withAlpha(90),
                  fontWeight: AppConstants.fontWeightMedium,
                ),
              ),
              const SizedBox(height: 8),
              CustomFormField(
                labelText: '',
                hintText: '',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return CustomFormField(
      labelText: 'Description',
      hintText: 'Description',
      maxLines: 4,
    );
  }

  Widget _buildFirstPurchase() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'First Purchase Only',
          style: TextStyle(
            fontSize: 16,
            color: AppConstants.textColor,
            fontWeight: AppConstants.fontWeightMedium,
            fontFamily: AppConstants.fontFamilyNunito,
          ),
        ),
        Switch.adaptive(
          value: isFirstPurchaseOnly,
          onChanged: (value) {
            setState(() {
              isFirstPurchaseOnly = value;
            });
          },
          activeColor: AppConstants.primaryColor,
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButtonWidget(
        buttonTitle: 'Create Coupon',
        isDisabled: false,
        onPressed: () {
          // Handle create coupon logic here
        },
      ),
    );
  }

  Future<void> _showSelectPeriod(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryColor,
              onPrimary: AppConstants.backgroundColor,
              surface: AppConstants.backgroundColor,
              onSurface: AppConstants.textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
