import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/user_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CustomerEarn extends StatefulWidget {
  const CustomerEarn({super.key});

  @override
  State<CustomerEarn> createState() => _CustomerEarnState();
}

class _CustomerEarnState extends State<CustomerEarn> {
  //track if the user is an affiliate or not
  bool isAffiliate = false;

  String ownerCurrency = 'dollars';

  String referralLink =
      '1013ec9e271f623c7fd7f5fd1d103b8b20d7c6b9ae0072395e02d57bee848b021110d0bfa965b91e5e2329681f999d62018b7f065b8213dc764c16c089eba37e';

  AppServices appServices = AppServices();

  bool isBecomingAffiliate = false;

  UserData userData = UserData();

  Future<void> becomeAffiliate() async {
    try {
      setState(() {
        isBecomingAffiliate = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 3));

      // Show confirmation modal
      if (context.mounted) {
        await showDialog(
          context: context,
          builder:
              (context) => ModalWidget(
                title: 'Thank You!',
                description:
                    'Your request to become an affiliate was successful.',
                buttonTitle: "Ok",
                buttonAction: () {
                  Navigator.of(context).pop();
                },
              ),
        );
      }

      // Update state to reflect affiliate status
      setState(() {
        isAffiliate = true;
        isBecomingAffiliate = false;
      });
    } catch (e) {
      setState(() {
        isBecomingAffiliate = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong. Please try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      isBecomingAffiliate = false;
    });

    setState(() {
      isAffiliate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    _buildDescriptionTexts(),
                    SizedBox(height: 16),
                    isAffiliate
                        ? _buildAffiliateLinks()
                        : _buildAffiliateButton(),
                    SizedBox(height: 20),
                    _buildFinanceFields(),
                    _buildHowToEarnSection(),
                    SizedBox(height: 28),
                    _buildFAQSection(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescriptionTexts() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Earn With BexieMart',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppConstants.textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: AppConstants.textColor,
          ),
          'Invite people to BexieMart and earn when they shop or sell. Use your referral link to invite users. Earn commissions when they buy or sell.',
        ),
      ],
    );
  }

  Widget _buildAffiliateButton() {
    return SizedBox(
      width: 330,
      height: 54,
      child: CustomButtonWidget(
        buttonTitle: 'Become an affiliate',
        isLoading: isBecomingAffiliate,
        onPressed: () async {
          return await becomeAffiliate();
        },
        isDisabled: false,
      ),
    );
  }

  Widget _buildAffiliateLinks() {
    return Container(
      width: 355,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        border: BoxBorder.all(
          color: AppConstants.textColor.withAlpha(60),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Row(
            children: [
              Text(
                'Your Referral Link',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: AppConstants.fontFamilyNunito,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              SizedBox(width: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(9),
                  ),
                ),
                onPressed: () async {
                  await appServices.copyLink(referralLink, context);
                },
                child: Row(
                  children: [
                    Icon(Icons.link, color: AppConstants.textColor),
                    SizedBox(width: 8),
                    Text(
                      'Copy Link',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 14),
              TextButton(
                onPressed: () async {
                  await appServices.shareItem(
                    referralLink,
                    'Become An Affiliate on the BexieMart App',
                    'Affiliation on BexieMart',
                    context,
                  );
                },
                child: Text(
                  'Share',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinanceFields() {
    Map<String, dynamic> affiliateData = userData.affiliateRecords;
    double totalEarning = affiliateData['totalEarning'];
    double pendingCommission = affiliateData['pendingCommission'];
    double withdrawalBalance = affiliateData['withdrawalBalance'];
    int referralsMade = affiliateData['referralsMade'];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 180,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 158,
                  height: 68,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: 1.5,
                      color: AppConstants.greyedColor,
                    ),
                    borderRadius: BorderRadius.circular(9),
                    color: AppConstants.primaryColor.withAlpha(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        '${ownerCurrency == 'dollars' ? '\$' : "GHS"} $totalEarning',
                      ),
                      Text(
                        'Total Earning',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                Container(
                  width: 158,
                  height: 68,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: 1.5,
                      color: AppConstants.greyedColor,
                    ),
                    borderRadius: BorderRadius.circular(9),
                    color: AppConstants.primaryColor.withAlpha(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        '${ownerCurrency == 'dollars' ? '\$' : "GHS"} $pendingCommission',
                      ),
                      Text(
                        'Pending Commission',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 21),
            Row(
              children: [
                Container(
                  width: 158,
                  height: 68,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: 1.5,
                      color: AppConstants.greyedColor,
                    ),
                    borderRadius: BorderRadius.circular(9),
                    color: AppConstants.primaryColor.withAlpha(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        '${ownerCurrency == 'dollars' ? '\$' : "GHS"} $withdrawalBalance',
                      ),
                      Text(
                        'Withdrawal Balance',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                Container(
                  width: 158,
                  height: 68,
                  decoration: BoxDecoration(
                    border: BoxBorder.all(
                      width: 1.5,
                      color: AppConstants.greyedColor,
                    ),
                    borderRadius: BorderRadius.circular(9),
                    color: AppConstants.primaryColor.withAlpha(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          color: AppConstants.textColor,
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        '$referralsMade',
                      ),
                      Text(
                        'Referrals Made',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontFamily: AppConstants.fontFamilyNunito,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowToEarnSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How You Earn',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 21,
          ),
        ),
        SizedBox(height: 12),
        _buildHowToEarnItem(
          "When They Buy",
          "Earn % on every purchase made by your invited users.",
        ),
        SizedBox(height: 12),
        _buildHowToEarnItem(
          "When They Sell",
          "Earn % from every sale by vendors you refer",
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    final faq = userData.faq;
    return faq.isEmpty
        ? Center(
          child: Text(
            'No Frequently Asked Questions Available Now.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: AppConstants.fontFamilyNunito,
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FAQ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: AppConstants.fontFamilyRaleway,
                fontWeight: FontWeight.w700,
                fontSize: 21,
              ),
            ),
            SizedBox(
              height: 400,
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemCount: faq.length,
                itemBuilder: (context, index) {
                  final item = faq[index];
                  String title = item['question'] ?? "";
                  String answer = item['answer'] ?? "";
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppConstants.primaryColor.withAlpha(
                          40,
                        ), // light blue border
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor:
                            Colors.transparent, // removes default line
                        splashColor: AppConstants.primaryColor.withAlpha(30),
                      ),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontFamily: AppConstants.fontFamilyNunito,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppConstants.textColor,
                          ),
                        ),
                        iconColor: AppConstants.primaryColor,
                        collapsedIconColor: AppConstants.primaryColor.withAlpha(
                          170,
                        ),
                        childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              answer,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                fontFamily: AppConstants.fontFamilyNunito,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
    ;
  }

  Widget _buildHowToEarnItem(String title, String description) {
    return Column(
      spacing: 2.0,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shopify_outlined),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: AppConstants.fontFamilyNunito,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontFamily: AppConstants.fontFamilyNunito,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
