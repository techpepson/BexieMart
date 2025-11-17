import 'package:bexie_mart/constants/products_constants.dart';

class VendorData {
  List<Map<String, dynamic>> vendorProducts = [
    {
      'productId': 1,
      'productColor': 'Red',
      "isAvailable": true,
      'shop': {
        'shopName': 'Jean Collections',
        'shopOwnerImage':
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
        'shopDescription': 'I have a shop that sells best clothings.',
      },
      'deliveryOptions': [
        {
          'optionId': 1,
          'deliveryType': 'standard',
          'unitOfDelivery': 'days',
          'daysToDelivery': 5,
          'deliveryFee': 0.0,
        },
        {
          'optionId': 2,
          'deliveryType': 'express',
          'unitOfDelivery': 'days',
          'daysToDelivery': 1,
          'deliveryFee': 12.0,
        },
      ],
      'productSize': 'large',
      'productName': 'Shoe',
      'productImage': [
        'https://plus.unsplash.com/premium_photo-1670509045675-af9f249b1bbe?w=500&auto=format&fit=crop&q=60',
      ],
      'productPrice': 100.00,
      'productDescription': 'This is a shoe',
      'productCategory': ProductsCategories.FASHION_AND_APPAREL.name,
      'uploadDate': '2025-09-25',
      'productSeller': 'John Doe',
      'productDiscount': 20,
      'productDiscountEndDate': '2025-11-08',
      'productLikes': 100,
      'productQuantity': 20,
      'deliveryAvailable': true,
      'deliveryType': 'fast',
      'deliveryDuration': '15-30 minutes',
      'deliveryFare': 300,
      'productStock': 20,
      'productRating': 2.5,
      'productReviewers': [
        {
          'reviewerName': 'Veronika',
          'reviewerRating': 4.5,
          'reviewerProfileImage':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
          'reviewerNotes':
              'I loved this product from the first time I got into contact with it.The seller is so friendly and calm ',
        },
      ],
      'discounts': [
        {
          'discountRate': 5,
          'discountDescription': '5% discount on your next order.',
          'discountTitle': 'First Purchase',
          'discountEndDate': '2025-10-15',
          'discountType': 'percentage',
        },
      ],
    },
    {
      'productId': 9,
      "isAvailable": true,
      'productName': 'Shoe',
      'productColor': 'Red',
      'deliveryOptions': [
        {
          'optionId': 1,
          'deliveryType': 'standard',
          'unitOfDelivery': 'days',
          'daysToDelivery': 5,
          'deliveryFee': 0.0,
        },
        {
          'optionId': 2,
          'deliveryType': 'express',
          'unitOfDelivery': 'days',
          'daysToDelivery': 1,
          'deliveryFee': 12.0,
        },
      ],
      'productSize': 'medium',
      'productImage': [
        'https://plus.unsplash.com/premium_photo-1670509045675-af9f249b1bbe?w=500&auto=format&fit=crop&q=60',
      ],
      'productPrice': 100.00,
      'productDescription': 'This is a shoe',
      'productCategory': ProductsCategories.FASHION_AND_APPAREL.name,
      'uploadDate': '2025-09-25',
      'productSeller': 'John Doe',
      'productDiscount': 20,
      'productStock': 20,
      'productDiscountEndDate': '2025-11-08',
      'productLikes': 100,
      'productQuantity': 20,
      'deliveryAvailable': true,
      'deliveryType': 'fast',
      'deliveryDuration': '15-30 minutes',
      'deliveryFare': 300,
      'productRating': 3.0,
      'productReviewers': [
        {
          'reviewerName': 'Veronika',
          'reviewerRating': 4.5,
          'reviewerProfileImage':
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
          'reviewerNotes':
              'I loved this product from the first time I got into contact with it.The seller is so friendly and calm ',
        },
      ],
      'discounts': [
        {
          'discountRate': 5,
          'discountDescription': '5% discount on your next order.',
          'discountTitle': 'First Purchase',
          'discountEndDate': '2025-10-15',
          'discountType': 'percentage',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> vendorOrders = [
    {
      'orderNumber': '#123456',
      'orderStatus': 'pending',
      'orderDate': '2025-11-12',
      'orderPaymentMethod': 'mobileMoney',
      'orderTotalAmount': 17.00,
      'orderCustomerName': 'Bexie Mart',
      'orderCustomerPhone': '+233123456987',
      'orderCustomerEmail': 'bexiemart@gmail.com',
      'orderRecipientAddress': 'Accra Mall',
      'orderProducts': [
        {
          'productId': 9,
          'productName': 'Shoe',
          'productColor': 'Red',
          'deliveryOptions': [
            {
              'optionId': 1,
              'deliveryType': 'standard',
              'unitOfDelivery': 'days',
              'daysToDelivery': 5,
              'deliveryFee': 0.0,
            },
            {
              'optionId': 2,
              'deliveryType': 'express',
              'unitOfDelivery': 'days',
              'daysToDelivery': 1,
              'deliveryFee': 12.0,
            },
          ],
          'productSize': 'medium',
          'productImage': [
            'https://plus.unsplash.com/premium_photo-1670509045675-af9f249b1bbe?w=500&auto=format&fit=crop&q=60',
          ],
          'productPrice': 100.00,
          'productDescription': 'This is a shoe',
          'productCategory': ProductsCategories.FASHION_AND_APPAREL.name,
          'uploadDate': '2025-09-25',
          'productSeller': 'John Doe',
          'productDiscount': 20,
          'productStock': 20,
          'productDiscountEndDate': '2025-11-08',
          'productLikes': 100,
          'productQuantity': 20,
          'deliveryAvailable': true,
          'deliveryType': 'fast',
          'deliveryDuration': '15-30 minutes',
          'deliveryFare': 300,
          'productRating': 3.0,
          'productReviewers': [
            {
              'reviewerName': 'Veronika',
              'reviewerRating': 4.5,
              'reviewerProfileImage':
                  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
              'reviewerNotes':
                  'I loved this product from the first time I got into contact with it.The seller is so friendly and calm ',
            },
          ],
          'discounts': [
            {
              'discountRate': 5,
              'discountDescription': '5% discount on your next order.',
              'discountTitle': 'First Purchase',
              'discountEndDate': '2025-10-15',
              'discountType': 'percentage',
            },
          ],
        },
      ],
    },
    {
      'orderNumber': '#123456',
      'orderStatus': 'delivered',
      'orderDate': '2025-11-12',
      'orderPaymentMethod': 'mobileMoney',
      'orderTotalAmount': 17.00,
      'orderCustomerName': 'Bexie Mart',
      'orderCustomerPhone': '+233123456987',
      'orderCustomerEmail': 'bexiemart@gmail.com',
      'orderRecipientAddress': 'Accra Mall',
      'orderProducts': [
        {
          'productId': 9,
          'productName': 'Shoe',
          'productColor': 'Red',
          'deliveryOptions': [
            {
              'optionId': 1,
              'deliveryType': 'standard',
              'unitOfDelivery': 'days',
              'daysToDelivery': 5,
              'deliveryFee': 0.0,
            },
            {
              'optionId': 2,
              'deliveryType': 'express',
              'unitOfDelivery': 'days',
              'daysToDelivery': 1,
              'deliveryFee': 12.0,
            },
          ],
          'productSize': 'medium',
          'productImage': [
            'https://plus.unsplash.com/premium_photo-1670509045675-af9f249b1bbe?w=500&auto=format&fit=crop&q=60',
          ],
          'productPrice': 100.00,
          'productDescription': 'This is a shoe',
          'productCategory': ProductsCategories.FASHION_AND_APPAREL.name,
          'uploadDate': '2025-09-25',
          'productSeller': 'John Doe',
          'productDiscount': 20,
          'productStock': 20,
          'productDiscountEndDate': '2025-11-08',
          'productLikes': 100,
          'productQuantity': 20,
          'deliveryAvailable': true,
          'deliveryType': 'fast',
          'deliveryDuration': '15-30 minutes',
          'deliveryFare': 300,
          'productRating': 3.0,
          'productReviewers': [
            {
              'reviewerName': 'Veronika',
              'reviewerRating': 4.5,
              'reviewerProfileImage':
                  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
              'reviewerNotes':
                  'I loved this product from the first time I got into contact with it.The seller is so friendly and calm ',
            },
          ],
          'discounts': [
            {
              'discountRate': 5,
              'discountDescription': '5% discount on your next order.',
              'discountTitle': 'First Purchase',
              'discountEndDate': '2025-10-15',
              'discountType': 'percentage',
            },
          ],
        },
      ],
    },
  ];

  List<Map<String, dynamic>> vendorEarnings = [
    {
      'earningAmount': 255.00,
      'dateOfEarning': '2025-11-15',
      'sourceOfEarning': 'orders',
    },
    {
      'earningAmount': 255.00,
      'dateOfEarning': '2025-11-15',
      'sourceOfEarning': 'orders',
    },
    {
      'earningAmount': 255.00,
      'dateOfEarning': '2025-11-15',
      'sourceOfEarning': 'orders',
    },
  ];

  List<Map<String, dynamic>> vendorLogs = [
    {
      'logTitle': "Order #123456 created",
      'logDescription': 'An order was created on this date',
      'logDate': '2025-11-12',
    },
    {
      'logTitle': "Order #123456 created",
      'logDescription': 'An order was created on this date',
      'logDate': '2025-11-12',
    },
    {
      'logTitle': "Order #123456 created",
      'logDescription': 'An order was created on this date',
      'logDate': '2025-11-12',
    },
  ];
}
