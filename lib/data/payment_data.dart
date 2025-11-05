class PaymentData {
  List<Map<String, dynamic>> paymentMethods = [
    {'methodName': 'debit_card'},
    {'methodName': 'mobile_money'},
  ];

  List<Map<String, dynamic>> transactions = [
    {
      'transactionId': 'qrst',
      'transactionAmount': 100.00,
      'transactionDate': '2025-10-04',
      'transactionNote': 'Withdrawal to MTTN',
      'transactionStatus': 'success',
    },
    {
      'transactionId': 'mnop',
      'transactionAmount': 100.00,
      'transactionDate': '2025-10-04',
      'transactionNote': 'Withdrawal to MTTN',
      'transactionStatus': 'success',
    },
    {
      'transactionId': 'ijkl',
      'transactionAmount': 100.00,
      'transactionDate': '2025-10-04',
      'transactionNote': 'Withdrawal to MTTN',
      'transactionStatus': 'success',
    },
    {
      'transactionId': 'efgh',
      'transactionAmount': 100.00,
      'transactionDate': '2025-10-04',
      'transactionNote': 'Withdrawal to MTTN',
      'transactionStatus': 'success',
    },
    {
      'transactionId': 'abcdef',
      'transactionAmount': 100.00,
      'transactionDate': '2025-10-04',
      'transactionNote': 'Withdrawal to MTTN',
      'transactionStatus': 'success',
    },
  ];
}
