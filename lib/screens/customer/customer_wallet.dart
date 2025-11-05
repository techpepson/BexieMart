import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/components/modal_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/payment_data.dart';
import 'package:flutter/material.dart';

class CustomerWallet extends StatefulWidget {
  const CustomerWallet({super.key});

  @override
  State<CustomerWallet> createState() => _CustomerWalletState();
}

class _CustomerWalletState extends State<CustomerWallet> {
  String ownerCurrency = 'dollars';

  String selectedAction = 'none';

  PaymentData paymentData = PaymentData();

  String defaultPaymentMethod = 'mobile_money';

  double walletBalance = 16754;

  bool isAddingBalance = false;
  bool isWalletTransferring = false;
  bool isWithdrawing = false;
  bool isViewingTransactions = false;

  TextEditingController addBalanceAmountController = TextEditingController();
  TextEditingController walletTransferAmountController =
      TextEditingController();
  TextEditingController withdrawalAmountController = TextEditingController();

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  Future<void> addBalance() async {
    if (isAddingBalance) return;
    setState(() {
      isAddingBalance = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => ModalWidget(
              title: 'Done',
              description: 'You have successfully added balance',
              buttonTitle: 'OK',
              buttonAction: () {
                Navigator.pop(context);
              },
            ),
      );
      setState(() {
        isAddingBalance = false;
      });
    } catch (e) {
      setState(() {
        isAddingBalance = false;
      });
    }
  }

  Future<void> walletTransfer() async {
    if (isWalletTransferring) return;
    setState(() {
      isWalletTransferring = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => ModalWidget(
              title: 'Done',
              description: 'You have successfully transferred money',
              buttonTitle: 'OK',
              buttonAction: () {
                Navigator.pop(context);
              },
            ),
      );
      setState(() {
        isWalletTransferring = false;
      });
    } catch (e) {
      setState(() {
        isWalletTransferring = false;
      });
    }
  }

  Future<void> withdrawal() async {
    if (isWithdrawing) return;
    setState(() {
      isWithdrawing = true;
    });
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      showDialog(
        context: context,
        builder:
            (context) => ModalWidget(
              title: 'Done',
              description: 'You have successfully withdrawn money',
              buttonTitle: 'OK',
              buttonAction: () {
                Navigator.pop(context);
              },
            ),
      );
      setState(() {
        isWithdrawing = false;
      });
    } catch (e) {
      setState(() {
        isWithdrawing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'My Wallet',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontFamily: AppConstants.fontFamilyRaleway,
                              color: AppConstants.textColor,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildBalanceDisplay(),
                    const SizedBox(height: 16),
                    _buildButtons(),
                    const SizedBox(height: 16),

                    if (selectedAction == 'addBalance')
                      _buildAddBalanceFields()
                    else if (selectedAction == 'walletTransfer')
                      _buildWalletTransferFields()
                    else if (selectedAction == 'withdrawal')
                      _buildWithdrawalFields()
                    else if (selectedAction == 'viewTransactions')
                      _buildViewTransactions()
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBalanceDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppConstants.primaryColor.withAlpha(20),
        border: Border.all(color: AppConstants.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallet Balance',
            style: TextStyle(
              fontSize: 14,
              color: AppConstants.textColor,
              fontFamily: AppConstants.fontFamilyRaleway,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ownerCurrency == 'dollars' ? '\$' : 'GHS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppConstants.fontFamilyRaleway,
                  color: AppConstants.primaryColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$walletBalance',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  fontFamily: AppConstants.fontFamilyRaleway,
                  color: AppConstants.textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildButtonItem(
                  () => setState(() {
                    selectedAction = 'addBalance';
                  }),
                  Icons.add,
                  'Add Balance',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButtonItem(
                  () => setState(() {
                    selectedAction = 'walletTransfer';
                  }),
                  Icons.transfer_within_a_station,
                  'Wallet Transfer',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildButtonItem(
                  () => setState(() {
                    selectedAction = 'withdrawal';
                  }),
                  Icons.arrow_downward,
                  'Withdrawal',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildButtonItem(
                  () => setState(() {
                    selectedAction = 'viewTransactions';
                  }),
                  Icons.history,
                  'View Transactions',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddBalanceFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: addBalanceAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount',
            hintText:
                ownerCurrency == 'dollars'
                    ? 'Enter amount in USD'
                    : 'Enter amount in GHS',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppConstants.primaryColor,
                width: 1.5,
              ),
            ),
            prefixIcon: Icon(
              Icons.attach_money,
              color: AppConstants.primaryColor,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showPaymentMethods(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: AppConstants.primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Choose Payment Method',
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyRaleway,
                        color: AppConstants.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 24),

        //submit button
        Center(
          child: SizedBox(
            width: 328,
            height: 54,
            child: CustomButtonWidget(
              isLoading: isAddingBalance,
              buttonTitle: 'Confirm Payment',
              onPressed: () => addBalance(),
              isDisabled:
                  addBalanceAmountController.text.isEmpty ||
                  defaultPaymentMethod.isEmpty ||
                  double.parse(addBalanceAmountController.text) <= 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletTransferFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        TextField(
          keyboardType: TextInputType.number,
          controller: walletTransferAmountController,
          decoration: InputDecoration(
            labelText: 'Amount',
            hintText:
                ownerCurrency == 'dollars'
                    ? 'Enter amount in USD'
                    : 'Enter amount in GHS',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppConstants.primaryColor,
                width: 1.5,
              ),
            ),
            prefixIcon: Icon(
              Icons.attach_money,
              color: AppConstants.primaryColor,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SizedBox(
            width: 328,
            height: 54,
            child: CustomButtonWidget(
              isDisabled:
                  walletTransferAmountController.text.isEmpty ||
                  double.parse(walletTransferAmountController.text) <= 0,
              isLoading: isWalletTransferring,
              buttonTitle: 'Send Money',
              onPressed: () => walletTransfer(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWithdrawalFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: withdrawalAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount to Withdraw',
            hintText:
                ownerCurrency == 'dollars'
                    ? 'Enter amount in USD'
                    : 'Enter amount in GHS',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppConstants.primaryColor,
                width: 1.5,
              ),
            ),
            prefixIcon: Icon(
              Icons.attach_money,
              color: AppConstants.primaryColor,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => showPaymentMethods(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withAlpha(40)),
              ),
              child: Row(
                children: [
                  Icon(Icons.outbond, color: AppConstants.primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Choose Withdrawal Method',
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyRaleway,
                        color: AppConstants.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ),

        //submit button
        Center(
          child: SizedBox(
            width: 328,
            height: 54,
            child: CustomButtonWidget(
              isLoading: isWithdrawing,
              buttonTitle: 'Submit Withdrawal',
              onPressed: () => withdrawal(),
              isDisabled:
                  withdrawalAmountController.text.isEmpty ||
                  double.parse(withdrawalAmountController.text) <= 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewTransactions() {
    List<Map<String, dynamic>> transactions = paymentData.transactions;
    return SizedBox(
      height: 420,
      child: ListView.separated(
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          Map<String, dynamic> transaction = transactions[index];
          String transactionId = transaction['transactionId'];
          double transactionAmount = transaction['transactionAmount'];
          String transactionDate = transaction['transactionDate'];
          String transactionNote = transaction['transactionNote'];
          String transactionStatus = transaction['transactionStatus'];

          final bool isSuccess = transactionStatus == 'success';
          final Color statusColor = isSuccess ? Colors.green : Colors.red;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withAlpha(20)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor.withAlpha(20),
                child: Icon(
                  isSuccess ? Icons.arrow_downward : Icons.arrow_upward,
                  color: statusColor,
                ),
              ),
              title: Text(
                '${ownerCurrency == 'dollars' ? '\$' : 'GHS'} $transactionAmount',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: AppConstants.fontFamilyRaleway,
                  color: AppConstants.textColor,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    transactionNote,
                    style: TextStyle(
                      color: AppConstants.textColor.withAlpha(80),
                      fontFamily: AppConstants.fontFamilyRaleway,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ID: $transactionId',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: AppConstants.fontFamilyRaleway,
                    ),
                  ),
                  Text(
                    'Date: $transactionDate',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: AppConstants.fontFamilyRaleway,
                    ),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isSuccess ? 'Successful' : 'Failed',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonItem(void Function()? onTap, IconData icon, String title) {
    final bool isActive =
        (title == 'Add Balance' && selectedAction == 'addBalance') ||
        (title == 'Wallet Transfer' && selectedAction == 'walletTransfer') ||
        (title == 'Withdrawal' && selectedAction == 'withdrawal') ||
        (title == 'View Transactions' && selectedAction == 'viewTransactions');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
              isActive ? AppConstants.primaryColor.withAlpha(20) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
                isActive
                    ? AppConstants.primaryColor
                    : Colors.grey.withAlpha(20),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppConstants.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppConstants.fontFamilyRaleway,
                fontWeight: FontWeight.w700,
                color: AppConstants.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPaymentMethods() {
    final paymentMethods = paymentData.paymentMethods;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Text(
                'Select Payment Method',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamilyRaleway,
                  color: AppConstants.textColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),

              // --- Payment Methods List ---
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paymentMethods.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final method = paymentMethods[index];
                  final methodName = method['methodName'] ?? '';

                  // Format name: e.g., "mobile_money" → "Mobile Money"
                  final formattedName = methodName
                      .split('_')
                      .map(
                        (word) =>
                            word.isNotEmpty
                                ? '${word[0].toUpperCase()}${word.substring(1)}'
                                : '',
                      )
                      .join(' ');

                  final isDebitCard = methodName == 'debit_card';
                  final isSelected = defaultPaymentMethod == methodName;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        defaultPaymentMethod = methodName;
                      });
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            isSelected
                                ? AppConstants.primaryColor.withAlpha(20)
                                : Colors.grey.withAlpha(20),
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppConstants.primaryColor
                                  : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          // --- Icon or Image ---
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              isDebitCard
                                  ? 'assets/images/debit.jpg'
                                  : 'assets/images/momo.jpg',
                              width: 50,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // --- Method Name ---
                          Expanded(
                            child: Text(
                              formattedName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppConstants.fontFamilyRaleway,
                                color: AppConstants.textColor,
                              ),
                            ),
                          ),

                          // --- Check Icon ---
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: AppConstants.primaryColor,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
