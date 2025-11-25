import 'dart:io';

import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/form_field.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/vendor/vendor_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
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

  File? _selectedStoreLogo;

  String terms =
      'This is Bexiemart, an e-commerce app that is here to make your online shopping very easy and affordable';

  VendorData vendorData = VendorData();
  bool acceptOrderUpdates = true;
  bool acceptPromotions = true;
  bool acceptNewProductAlerts = true;
  bool acceptWalletActivities = true;
  List<Map<String, dynamic>> _coupons = [];
  List<Map<String, String>> paymentCards = [
    {
      'brand': 'Mastercard',
      'cardHolder': 'Amanda Morgan',
      'cardNumber': '512345678901879',
      'expiry': '12/24',
    },
  ];
  List<Map<String, String>> mobileMoneyAccounts = [
    {
      'provider': 'Mobile Money',
      'accountName': 'Amanda Morgan',
      'accountNumber': '02412341244',
    },
  ];

  Future<dynamic> pickStoreLogo(
    StateSetter setState,
    ImageSource source,
  ) async {
    try {
      final pickedImage = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxHeight: 500,
        maxWidth: 500,
      );

      if (pickedImage != null) {
        setState(() {
          _selectedStoreLogo = File(pickedImage.path);
        });
      }
    } catch (e) {
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppConstants.errorColor,
            content: Text(
              'Image Selection Failed',
              style: TextStyle(color: AppConstants.backgroundColor),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _coupons =
        vendorData.coupons
            .map((coupon) => Map<String, dynamic>.from(coupon))
            .toList();
  }

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
      body: SafeArea(
        child: Column(children: [Expanded(child: _buildTitlesDisplay())]),
      ),
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
      {
        'title': 'Payment Methods',
        'action': () async {
          await showPaymentMethods();
        },
      },
      {
        'title': 'Notifications Settings',
        'action': () async {
          await showNotifications();
        },
      },
      {
        'title': 'Terms & Conditions',
        'action': () async {
          return await showTerms();
        },
      },
      {
        'title': 'Privacy Policy',
        'action': () async {
          return await showPrivacy();
        },
      },
      {
        'title': 'About Bexiemart',
        'action': () async {
          return await showAbout();
        },
      },
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

  Future<void> _showShopImageSourceModal(
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
                    await pickStoreLogo(setState, ImageSource.gallery);
                  },
                ),
                const SizedBox(height: 12),
                _buildSourceSheetTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Camera',
                  subtitle: 'Capture a new photo instantly',
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await pickStoreLogo(setState, ImageSource.camera);
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
    return showAdaptiveDialog(
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
    return showAdaptiveDialog(
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
    return showAdaptiveDialog(
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      InkWell(
                        onTap: () async {
                          return await _showShopImageSourceModal(
                            context,
                            setState,
                          );
                        },
                        child:
                            _selectedStoreLogo == null
                                ? DottedBorder(
                                  options: RectDottedBorderOptions(),
                                  child: Container(
                                    width: 73,
                                    height: 73,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cloud_upload_outlined,
                                          size: 40,
                                          color: AppConstants.textColor
                                              .withAlpha(150),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Upload Logo',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppConstants.textColor
                                                .withAlpha(150),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : ClipOval(
                                  child: Image.file(
                                    _selectedStoreLogo!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
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
    final coupons = _coupons;
    return showAdaptiveDialog(
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
                              formattedDate = couponValidity;
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
                                      Text(
                                        'Coupon',
                                        style: TextStyle(
                                          color: AppConstants.primaryColor,
                                          fontFamily:
                                              AppConstants.fontFamilyRaleway,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
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
                                  SizedBox(height: 5),

                                  DottedDashedLine(
                                    dashColor: AppConstants.primaryColor,
                                    height: 5,
                                    width: double.infinity,
                                    axis: Axis.horizontal,
                                  ),
                                  SizedBox(height: 18),
                                  Row(
                                    children: [
                                      Icon(
                                        couponIcon,
                                        size: 20,
                                        color: AppConstants.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        overflow: TextOverflow.ellipsis,
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
                                        onPressed: () async {
                                          final updatedCoupon =
                                              await _openCouponEditor(
                                                coupon: coupon,
                                              );
                                          if (updatedCoupon != null) {
                                            setState(() {
                                              _coupons[index] =
                                                  Map<String, dynamic>.from(
                                                    updatedCoupon,
                                                  );
                                              vendorData.coupons = List<
                                                Map<String, dynamic>
                                              >.from(_coupons);
                                            });
                                            this.setState(() {});
                                          }
                                        },
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

  Future<Map<String, dynamic>?> _openCouponEditor({
    Map<String, dynamic>? coupon,
  }) async {
    return Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => CouponEditorScreen(initialCoupon: coupon),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> showPaymentMethods() async {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                decoration: BoxDecoration(
                  color: AppConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppConstants.textColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textColor,
                            fontFamily: AppConstants.fontFamilyNunito,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Methods',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textColor,
                              fontFamily: AppConstants.fontFamilyNunito,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage your saved cards and mobile money accounts.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConstants.textColor.withAlpha(150),
                              fontFamily: AppConstants.fontFamilyNunito,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...paymentCards.map(
                      (card) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPaymentCardTile(
                          card: card,
                          onEdit: () async {
                            final updatedCard = await _showCardForm(
                              existing: card,
                            );
                            if (updatedCard != null) {
                              setState(() {
                                final index = paymentCards.indexOf(card);
                                paymentCards[index] = updatedCard;
                              });
                              this.setState(() {});
                              await _showPaymentSuccess(
                                'Your card has been updated successfully',
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    _buildAddButton(
                      title: 'Add Card',
                      icon: Icons.add,
                      onTap: () async {
                        final newCard = await _showCardForm();

                        if (newCard != null) {
                          setState(() {
                            paymentCards.add(newCard);
                          });
                          this.setState(() {});
                          await _showPaymentSuccess(
                            'Your card has been added successfully',
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Mobile Money',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textColor,
                        fontFamily: AppConstants.fontFamilyNunito,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...mobileMoneyAccounts.map(
                      (account) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildMobileMoneyTile(
                          account: account,
                          actionLabel: 'Edit',
                          onAction: () async {
                            final updatedAccount = await _showMobileMoneyForm(
                              existing: account,
                            );
                            if (updatedAccount != null) {
                              setState(() {
                                final index = mobileMoneyAccounts.indexOf(
                                  account,
                                );
                                mobileMoneyAccounts[index] = updatedAccount;
                              });
                              this.setState(() {});
                              await _showPaymentSuccess(
                                'Your Momo has been updated successfully',
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    _buildMobileMoneyTile(
                      account: {
                        'provider': 'Mobile Money',
                        'accountName': 'Add new account',
                        'accountNumber': '',
                      },
                      actionLabel: 'Link',
                      onAction: () async {
                        final newAccount = await _showMobileMoneyForm();
                        if (newAccount != null) {
                          setState(() {
                            mobileMoneyAccounts.add(newAccount);
                          });
                          this.setState(() {});
                          await _showPaymentSuccess(
                            'Your Momo has been linked successfully',
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPaymentCardTile({
    required Map<String, String> card,
    required VoidCallback onEdit,
  }) {
    final holder = card['cardHolder'] ?? 'Card Holder';
    final expiry = card['expiry'] ?? '';
    final masked = _maskCardNumber(card['cardNumber'] ?? '');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E77F5), Color(0xFF2461E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                height: 32,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      child: _buildMasterCardCircle(
                        color: const Color(0xFFFFA94A),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      child: _buildMasterCardCircle(
                        color: const Color(0xFFFF5F6D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card['brand'] ?? 'Card',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      holder,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            masked,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holder.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CARD HOLDER',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expiry,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'VALID THRU',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasterCardCircle({required Color color}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildAddButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: AppConstants.borderColor),
      ),
      icon: Icon(icon, color: AppConstants.primaryColor),
      label: Text(
        title,
        style: TextStyle(
          color: AppConstants.textColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamilyNunito,
        ),
      ),
    );
  }

  Widget _buildMobileMoneyTile({
    required Map<String, String> account,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    final name = account['accountName'] ?? '';
    final number = account['accountNumber'] ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppConstants.primaryColor.withOpacity(0.08),
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account['provider'] ?? 'Mobile Money',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                    fontFamily: AppConstants.fontFamilyNunito,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppConstants.textColor.withAlpha(160),
                  ),
                ),
                if (number.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _maskMobileNumber(number),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppConstants.textColor.withAlpha(150),
                    ),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.primaryColor,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String>?> _showCardForm({
    Map<String, String>? existing,
  }) async {
    final cardNumberController = TextEditingController(
      text: existing?['cardNumber'] ?? '',
    );
    final holderController = TextEditingController(
      text: existing?['cardHolder'] ?? '',
    );
    final expiryController = TextEditingController(
      text: existing?['expiry'] ?? '',
    );
    final cvvController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppConstants.borderColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  existing == null ? 'Add Card' : 'Edit Card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                    fontFamily: AppConstants.fontFamilyNunito,
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  labelText: 'Card Holder',
                  hintText: 'Jennifer Johnson',
                  controller: holderController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  keyboardType: TextInputType.number,
                  controller: cardNumberController,
                  validator:
                      (value) =>
                          value == null || value.length < 8
                              ? 'Invalid number'
                              : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomFormField(
                        labelText: 'Date',
                        hintText: 'MM/YY',
                        controller: expiryController,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomFormField(
                        labelText: 'CVV',
                        hintText: '123',
                        isPassword: true,
                        controller: cvvController,
                        validator:
                            (value) =>
                                value == null || value.length < 3
                                    ? 'Invalid'
                                    : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    buttonTitle: 'Save Changes',
                    isDisabled: false,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop({
                          'brand': 'Mastercard',
                          'cardHolder': holderController.text.trim(),
                          'cardNumber': cardNumberController.text.trim(),
                          'expiry': expiryController.text.trim(),
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, String>?> _showMobileMoneyForm({
    Map<String, String>? existing,
  }) async {
    final nameController = TextEditingController(
      text: existing?['accountName'] ?? '',
    );
    final numberController = TextEditingController(
      text: existing?['accountNumber'] ?? '',
    );
    final formKey = GlobalKey<FormState>();

    return showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppConstants.borderColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  existing == null
                      ? 'Add Mobile Money Account'
                      : 'Edit Mobile Money Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                    fontFamily: AppConstants.fontFamilyNunito,
                  ),
                ),
                const SizedBox(height: 20),
                CustomFormField(
                  labelText: 'Account Name',
                  hintText: 'Jennifer Johnson',
                  controller: nameController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  labelText: 'Mobile Money Number',
                  hintText: '024 123 1234',
                  controller: numberController,
                  keyboardType: TextInputType.phone,
                  validator:
                      (value) =>
                          value == null || value.length < 8
                              ? 'Invalid number'
                              : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    buttonTitle: existing == null ? 'Link' : 'Save Changes',
                    isDisabled: false,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop({
                          'provider': 'Mobile Money',
                          'accountName': nameController.text.trim(),
                          'accountNumber': numberController.text.trim(),
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showPaymentSuccess(String message) async {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            decoration: BoxDecoration(
              color: AppConstants.backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppConstants.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Done!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.textColor.withAlpha(150),
                    fontFamily: AppConstants.fontFamilyNunito,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _maskCardNumber(String number) {
    if (number.length <= 4) return number;
    final last4 = number.substring(number.length - 4);
    return '**** **** **** $last4';
  }

  String _maskMobileNumber(String number) {
    if (number.length <= 4) return number;
    final last4 = number.substring(number.length - 4);
    return '${'*' * (number.length - 4)}$last4';
  }

  Future<dynamic> showNotifications() async {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                decoration: BoxDecoration(
                  color: AppConstants.backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppConstants.textColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Notification Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textColor,
                            fontFamily: AppConstants.fontFamilyNunito,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Choose what updates you would like to receive.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withAlpha(150),
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildNotificationItem(
                      title: 'Order Updates',
                      subtitle: 'Track confirmations, shipping and delivery.',
                      value: acceptOrderUpdates,
                      onChanged: (value) {
                        setState(() => acceptOrderUpdates = value);
                      },
                    ),
                    _buildNotificationItem(
                      title: 'Promotions',
                      subtitle: 'Stay informed about special discounts.',
                      value: acceptPromotions,
                      onChanged: (value) {
                        setState(() => acceptPromotions = value);
                      },
                    ),
                    _buildNotificationItem(
                      title: 'New Product Alerts',
                      subtitle: 'Know when new arrivals hit the store.',
                      value: acceptNewProductAlerts,
                      onChanged: (value) {
                        setState(() => acceptNewProductAlerts = value);
                      },
                    ),
                    _buildNotificationItem(
                      title: 'Wallet Activities',
                      subtitle: 'Receive wallet credit and debit notices.',
                      value: acceptWalletActivities,
                      onChanged: (value) {
                        setState(() => acceptWalletActivities = value);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.borderColor, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textColor,
                    fontFamily: AppConstants.fontFamilyNunito,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppConstants.textColor.withAlpha(160),
                    fontFamily: AppConstants.fontFamilyNunito,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppConstants.primaryColor,
            inactiveTrackColor: AppConstants.borderColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> showTerms() async {
    return _buildInfoDialog(
      title: 'Terms and Conditions',
      description:
          'If you need help or have any questions, feel free to contact us by email.',
      bodyText: terms,
    );
  }

  Future<void> showPrivacy() async {
    return _buildInfoDialog(
      title: 'Privacy Policy',
      description:
          'If you need help or have any questions, feel free to contact us by email.',
      bodyText:
          'We respect your privacy and only use your information to improve your shopping experience. $terms',
    );
  }

  Future<void> showAbout() {
    return _buildInfoDialog(
      title: 'About Bexiemart',
      description: 'A good shopping platform',
      customContent: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              AppConstants.appLogo,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'About Bexiemart',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textColor,
              fontFamily: AppConstants.fontFamilyNunito,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A good shopping platform',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withAlpha(150),
              fontFamily: AppConstants.fontFamilyNunito,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'If you need help or have any questions, feel free to contact us by email.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor.withAlpha(150),
              fontFamily: AppConstants.fontFamilyNunito,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'hello@mydomain.com',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppConstants.primaryColor,
              fontFamily: AppConstants.fontFamilyNunito,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _buildInfoDialog({
    required String title,
    required String description,
    String? bodyText,
    Widget? customContent,
  }) {
    return showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: BoxDecoration(
              color: AppConstants.backgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: AppConstants.textColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textColor,
                        fontFamily: AppConstants.fontFamilyNunito,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppConstants.textColor.withAlpha(150),
                          fontFamily: AppConstants.fontFamilyNunito,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (customContent != null)
                  customContent
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      bodyText ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppConstants.textColor.withAlpha(200),
                        fontFamily: AppConstants.fontFamilyNunito,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'hello@mydomain.com',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryColor,
                      fontFamily: AppConstants.fontFamilyNunito,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CouponEditorScreen extends StatefulWidget {
  const CouponEditorScreen({super.key, this.initialCoupon});

  final Map<String, dynamic>? initialCoupon;

  @override
  State<CouponEditorScreen> createState() => _CouponEditorScreenState();
}

class _CouponEditorScreenState extends State<CouponEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _codeController;
  late TextEditingController _validUntilController;
  late TextEditingController _usageLimitController;
  late TextEditingController _descriptionController;
  String _selectedType = 'percentage';
  bool _firstPurchaseOnly = false;
  late double _couponValue;
  final _formKey = GlobalKey<FormState>();
  final List<String> _couponTypes = ['percentage', 'amount'];

  @override
  void initState() {
    super.initState();
    final data = widget.initialCoupon ?? {};
    _selectedType = (data['couponType'] ?? 'percentage').toString();
    _couponValue =
        (data['couponValue'] is num)
            ? (data['couponValue'] as num).toDouble()
            : 0;
    _firstPurchaseOnly = data['firstPurchaseOnly'] == true;
    _titleController = TextEditingController(text: data['couponTitle'] ?? '');
    _codeController = TextEditingController(text: data['couponCode'] ?? '');
    _validUntilController = TextEditingController(
      text: data['validPeriod'] ?? '',
    );
    _usageLimitController = TextEditingController(
      text: (data['usageLimit'] ?? '5').toString(),
    );
    _descriptionController = TextEditingController(
      text: _buildDescriptionSeed(
        _couponValue,
        _selectedType,
        data['couponDescription'] ?? '',
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    _validUntilController.dispose();
    _usageLimitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppConstants.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppConstants.textColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.initialCoupon == null ? 'Create Coupon' : 'Edit Coupon',
          style: TextStyle(
            color: AppConstants.textColor,
            fontFamily: AppConstants.fontFamilyNunito,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                CustomFormField(
                  labelText: 'Coupon Title',
                  hintText: 'First Purchase',
                  controller: _titleController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  labelText: 'Coupon Code',
                  hintText: 'FIRST5',
                  controller: _codeController,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppConstants.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppConstants.borderColor),
                    ),
                  ),
                  value: _selectedType,
                  items:
                      _couponTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type[0].toUpperCase() + type.substring(1),
                                style: TextStyle(
                                  fontFamily: AppConstants.fontFamilyNunito,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomFormField(
                        labelText: 'Valid Until',
                        hintText: '5.16.20',
                        controller: _validUntilController,
                        keyboardType: TextInputType.datetime,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomFormField(
                        labelText: 'Usage Limit',
                        hintText: '5',
                        controller: _usageLimitController,
                        keyboardType: TextInputType.number,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomFormField(
                  labelText: 'Discount Summary',
                  hintText: '5% off of your next order',
                  controller: _descriptionController,
                  maxLines: 2,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'First Purchase Only',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textColor,
                            fontFamily: AppConstants.fontFamilyNunito,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Limit to first time customers',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppConstants.textColor.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: _firstPurchaseOnly,
                      activeColor: AppConstants.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          _firstPurchaseOnly = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    buttonTitle: 'Save Changes',
                    isDisabled: false,
                    onPressed: _handleSave,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final usageLimit = int.tryParse(_usageLimitController.text.trim()) ?? 0;
    final combined = _descriptionController.text.trim();
    final parsedValue = _extractValueFromSummary(combined) ?? _couponValue;
    final summaryText = _extractSummaryText(combined);

    Navigator.of(context).pop({
      'couponTitle': _titleController.text.trim(),
      'couponCode': _codeController.text.trim(),
      'couponType': _selectedType,
      'couponValue': parsedValue,
      'validPeriod': _validUntilController.text.trim(),
      'usageLimit': usageLimit,
      'couponDescription': summaryText,
      'firstPurchaseOnly': _firstPurchaseOnly,
    });
  }

  String _buildDescriptionSeed(double value, String type, String description) {
    if (value == 0) {
      return description;
    }
    final formattedValue =
        value % 1 == 0 ? value.toInt().toString() : value.toString();
    final symbol = type == 'percentage' ? '%' : '';
    final trimmedDesc = description.trim();
    return '$formattedValue$symbol'
        '${trimmedDesc.isNotEmpty ? ' $trimmedDesc' : ''}';
  }

  double? _extractValueFromSummary(String text) {
    final match = RegExp(r'\d+(\.\d+)?').firstMatch(text);
    if (match == null) return null;
    return double.tryParse(match.group(0)!);
  }

  String _extractSummaryText(String text) {
    final match = RegExp(r'\d+(\.\d+)?\s*%?').firstMatch(text);
    if (match == null) {
      return text;
    }
    return text.substring(match.end).trim();
  }
}
