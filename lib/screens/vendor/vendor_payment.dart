import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/payment_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VendorPayment extends StatefulWidget {
  const VendorPayment({super.key});

  @override
  State<VendorPayment> createState() => _VendorPaymentState();
}

class _VendorPaymentState extends State<VendorPayment> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final PaymentData paymentData = PaymentData();

  String? selectedPaymentMethod;
  String ownerCurrency = 'dollars';

  // Sample card data - in real app, this would come from user's saved cards
  Map<String, dynamic>? selectedCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Request Withdrawal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              // Amount Input Field
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount to Withdrawal',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Payment Method Input Field
              GestureDetector(
                onTap: () => _showPaymentMethodModal(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedPaymentMethod != null
                              ? _formatPaymentMethod(selectedPaymentMethod!)
                              : 'Choose Withdrawal Method',
                          style: TextStyle(
                            color:
                                selectedPaymentMethod != null
                                    ? Colors.black87
                                    : Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Phone Number Input Field (for mobile money)
              if (selectedPaymentMethod == 'mobile_money')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              const SizedBox(height: 40),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Submit Withdrawal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPaymentMethod(String method) {
    if (method == 'debit_card') {
      return selectedCard != null
          ? '${selectedCard!['cardType'] ?? 'Card'} •••• ${selectedCard!['lastFour'] ?? ''}'
          : 'Debit Card';
    } else if (method == 'mobile_money') {
      return 'Mobile Money';
    }
    return method;
  }

  void _showPaymentMethodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment Methods',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // Debit Card Option
                      _buildCardOption(
                        cardType: 'Mastercard',
                        cardNumber: '**** **** **** 1579',
                        cardholderName: 'AMANDA MORGAN',
                        expiryDate: '12/22',
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'debit_card';
                            selectedCard = {
                              'cardType': 'Mastercard',
                              'lastFour': '1579',
                              'cardholderName': 'AMANDA MORGAN',
                              'expiryDate': '12/22',
                            };
                          });
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 16),
                      // Mobile Money Option
                      _buildMobileMoneyOption(
                        onTap: () {
                          setState(() {
                            selectedPaymentMethod = 'mobile_money';
                            selectedCard = null;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildCardOption({
    required String cardType,
    required String cardNumber,
    required String cardholderName,
    required String expiryDate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selectedPaymentMethod == 'debit_card'
                    ? Colors.blue
                    : Colors.grey[300]!,
            width: selectedPaymentMethod == 'debit_card' ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Mastercard Logo (overlapping circles)
                SizedBox(
                  width: 50,
                  height: 30,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.orange[700],
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, size: 20),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              cardNumber,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cardholderName,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              expiryDate,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMoneyOption({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selectedPaymentMethod == 'mobile_money'
                    ? Colors.blue
                    : Colors.grey[300]!,
            width: selectedPaymentMethod == 'mobile_money' ? 2 : 1,
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.phone_android, color: Colors.black87),
            SizedBox(width: 12),
            Text(
              'Mobile Money',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    if (selectedPaymentMethod == 'mobile_money' &&
        phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    // Handle submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Withdrawal request submitted successfully'),
      ),
    );

    // Navigate back after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    amountController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
