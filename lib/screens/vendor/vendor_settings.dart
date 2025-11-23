import 'dart:io';

import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/form_field.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/vendor/vendor_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class VendorSettings extends StatefulWidget {
  const VendorSettings({super.key});

  @override
  State<VendorSettings> createState() => _VendorSettingsState();
}

class _VendorSettingsState extends State<VendorSettings> {
  RangeValues _currentRangeValues = RangeValues(2, 5);
  String profileImage =
      'https://plus.unsplash.com/premium_photo-1661583625964-a83448edc0b3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8YnV5JTIwaG91c2UlMjBvbiUyMHBob25lfGVufDB8fDB8fHww';
  File? _selectedProfileImage;
  final ImagePicker _imagePicker = ImagePicker();

  VendorData vendorData = VendorData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.textColor,
            fontFamily: AppConstants.fontFamilyNunito,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(child: _buildTitlesDisplay()),
    );
  }

  Widget _buildTitlesDisplay() {
    List<Map<String, dynamic>> settingsOptions = [
      {
        'title': 'Profile Settings',
        'action': () async {
          return await showProfileSettings(context);
        },
      },
      {
        'title': 'Change Password',
        'action': () async {
          return showChangePassword();
        },
      },
      {
        'title': 'Shop Information',
        'action': () async {
          return await showShopInformation();
        },
      },
      {
        'title': 'Coupons',
        'action': () async {
          return await showCoupons();
        },
      },
      {'title': 'Payment Methods', 'action': () {}},
      {'title': 'Notifications Settings', 'action': () {}},
      {'title': 'FAQ & Contact Support', 'action': () {}},
      {'title': 'Terms & Conditions', 'action': () {}},
      {'title': 'Privacy Policy', 'action': () {}},
      {'title': 'About Bexiemart', 'action': () {}},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: settingsOptions.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> item = settingsOptions[index];
        String itemTitle = item['title'] ?? "N/A";
        void Function()? onTap = item['action'];
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppConstants.borderColor, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    itemTitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.textColor,
                      fontWeight: AppConstants.fontWeightMedium,
                      fontFamily: AppConstants.fontFamilyNunito,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppConstants.textColor.withAlpha(150),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickProfileImage(
    ImageSource source,
    StateSetter setState,
  ) async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 500,
        maxHeight: 500,
      );
      if (pickedImage != null) {
        setState(() {
          _selectedProfileImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _showImageSourceModal(
    BuildContext context,
    StateSetter setState,
  ) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
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
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                    fontFamily: AppConstants.fontFamilyNunito,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSourceSheetTile(
                  icon: Icons.photo_library_outlined,
                  title: 'Gallery',
                  subtitle: 'Choose from your photo gallery',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _pickProfileImage(ImageSource.gallery, setState);
                  },
                ),
                const SizedBox(height: 12),
                _buildSourceSheetTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Camera',
                  subtitle: 'Capture a new photo instantly',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await _pickProfileImage(ImageSource.camera, setState);
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
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppConstants.borderColor, width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppConstants.primaryColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                        fontFamily: AppConstants.fontFamilyNunito,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.textColor.withAlpha(150),
                        fontFamily: AppConstants.fontFamilyNunito,
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

  Future<dynamic> showProfileSettings(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Profile',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withAlpha(150),
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Stack(
                          children: [
                            ClipOval(
                              child:
                                  _selectedProfileImage != null
                                      ? Image.file(
                                        _selectedProfileImage!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                      : CachedNetworkImage(
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        imageUrl: profileImage,
                                        errorWidget:
                                            (context, url, error) => Container(
                                              width: 100,
                                              height: 100,
                                              color: AppConstants.greyedColor,
                                              child: Icon(
                                                Icons.person,
                                                size: 50,
                                                color: AppConstants.textColor
                                                    .withAlpha(150),
                                              ),
                                            ),
                                        placeholder:
                                            (context, url) => Container(
                                              width: 100,
                                              height: 100,
                                              color: AppConstants.greyedColor,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color:
                                                    AppConstants.primaryColor,
                                              ),
                                            ),
                                      ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppConstants.backgroundColor,
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                  onPressed: () {
                                    _showImageSourceModal(context, setState);
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppConstants.backgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomFormField(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'Phone',
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButtonWidget(
                          buttonTitle: 'Save Changes',
                          isDisabled: false,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showChangePassword() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomFormField(
                        labelText: 'Old Password',
                        hintText: 'Enter your current password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your new password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButtonWidget(
                          buttonTitle: 'Update Password',
                          isDisabled: false,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showShopInformation() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: DottedBorder(
                          options: const RectDottedBorderOptions(),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 40,
                                  color: AppConstants.textColor.withAlpha(150),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Upload Logo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppConstants.textColor.withAlpha(
                                      150,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomFormField(
                        labelText: 'Name of Shop',
                        hintText: 'Enter your shop name',
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'Shop Description',
                        hintText: 'Enter a description of your shop',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'Location',
                        hintText: 'Enter your shop location',
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      CustomFormField(
                        labelText: 'WhatsApp Number',
                        hintText: 'Enter your WhatsApp number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Set your delivery coverage',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Maximum radius',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withAlpha(150),
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            '2 km',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textColor.withAlpha(150),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _currentRangeValues.end,
                              min: 2,
                              max: 5,
                              activeColor: AppConstants.primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  _currentRangeValues = RangeValues(
                                    _currentRangeValues.start,
                                    value,
                                  );
                                });
                              },
                            ),
                          ),
                          Text(
                            '5 km',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textColor.withAlpha(150),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          '${_currentRangeValues.end.toInt()} km',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButtonWidget(
                          buttonTitle: 'Save',
                          isDisabled: false,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showCoupons() async {
    List<Map<String, dynamic>> coupons = vendorData.coupons;
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            padding: const EdgeInsets.all(24),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Coupons',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                        fontFamily: AppConstants.fontFamilyNunito,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButtonWidget(
                        buttonTitle: 'Create New Coupon',
                        isDisabled: false,
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.push('/vendor-settings/add-coupon');
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (coupons.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You haven't created any coupons yet.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppConstants.textColor.withAlpha(150),
                                  fontFamily: AppConstants.fontFamilyNunito,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Use them to drive more sales!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppConstants.textColor.withAlpha(150),
                                  fontFamily: AppConstants.fontFamilyNunito,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: coupons.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> coupon = coupons[index];
                            String couponTitle = coupon['couponTitle'] ?? "N/A";
                            String couponValidity =
                                coupon['validPeriod'] ?? "N/A";
                            dynamic couponValue =
                                coupon['couponValue'] ?? 'N/A';
                            String couponType = coupon['couponType'] ?? 'N/A';
                            String couponDesc =
                                coupon['couponDescription'] ?? 'N/A';

                            // Format date
                            String formattedDate = couponValidity;
                            try {
                              DateTime date = DateTime.parse(couponValidity);
                              formattedDate =
                                  '${date.month}.${date.day}.${date.year.toString().substring(2)}';
                            } catch (e) {
                              // Keep original if parsing fails
                            }

                            // Determine icon based on coupon title
                            IconData couponIcon = Icons.shopping_bag;
                            if (couponTitle.toLowerCase().contains('gift')) {
                              couponIcon = Icons.card_giftcard;
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppConstants.backgroundColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppConstants.borderColor,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            couponIcon,
                                            size: 20,
                                            color: AppConstants.primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            couponTitle,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppConstants.textColor,
                                              fontFamily:
                                                  AppConstants.fontFamilyNunito,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Valid Until $formattedDate',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppConstants.textColor
                                              .withAlpha(150),
                                          fontFamily:
                                              AppConstants.fontFamilyNunito,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '$couponValue${couponType == 'percentage' ? "%" : ''} $couponDesc',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppConstants.textColor.withAlpha(
                                        150,
                                      ),
                                      fontFamily: AppConstants.fontFamilyNunito,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: AppConstants.textColor,
                                            fontFamily:
                                                AppConstants.fontFamilyNunito,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: AppConstants.primaryColor,
                                            fontFamily:
                                                AppConstants.fontFamilyNunito,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showPaymentMethods() {}
  void showNotifications() {}
  void showFAQ() {}
  void showTerms() {}
  void showPrivacy() {}
  void showAbout() {}
}
