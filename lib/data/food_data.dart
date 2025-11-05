import 'package:bexie_mart/constants/products_constants.dart';

class FoodData {
  List<Map<String, dynamic>> foodItems = [
    {
      'productId': 1,
      'productName': 'Rice and Stew',
      'productImage': [
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
      ],
      'productPrice': 100.0,
      'productDescription': 'This is a rice and stew',
      'productCategory': ProductsCategories.FOOD.name,
      'foodCategory': FoodCategories.FAST_FOOD.name,
      'uploadDate': '2025-09-25',
      'productSeller': 'John Doe',
      'productDiscount': 20,
      'productLikes': 100,
      'productQuantity': 20,
      'deliveryAvailable': true,
      'deliveryType': 'fast',
      'deliveryDuration': '15-30 minutes',
      'deliveryFare': 300,
      'productRating': 2.5,
      'productReviewers': [
        {
          'reviewerName': 'Veronika',
          'reviewerNotes':
              'I loved this food from the first time I got into contact with it.The seller is so friendly and calm ',
        },
      ],
    },
    {
      'productId': 1,
      'productName': 'Jollof Rice',
      'productImage': [
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
      ],
      'productPrice': 100.0,
      'productDescription': 'This is a Jollof rice',
      'productCategory': ProductsCategories.FOOD,
      'foodCategory': FoodCategories.SNACKS.name,
      'uploadDate': '2025-09-25',
      'productSeller': 'John Doe',
      'productDiscount': 20,
      'productLikes': 100,
      'productQuantity': 20,
      'deliveryAvailable': true,
      'deliveryType': 'fast',
      'deliveryDuration': '15-30 minutes',
      'deliveryFare': 300,
      'productRating': 2.5,
      'productReviewers': [
        {
          'reviewerName': 'Veronika',
          'reviewerNotes':
              'I loved this food from the first time I got into contact with it.The seller is so friendly and calm ',
        },
      ],
    },
    {
      'productId': 1,
      'productName': 'Ampesi',
      'productImage': [
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
      ],
      'productPrice': 100.0,
      'productDescription': 'This is a Ampesi',
      'productCategory': 'food',
      'foodCategory': FoodCategories.DINNER.name,
      'uploadDate': '2025-09-25',
      'productSeller': 'John Doe',
      'productDiscount': 20,
      'productLikes': 100,
      'productQuantity': 20,
      'deliveryAvailable': true,
      'deliveryType': 'fast',
      'deliveryDuration': '15-30 minutes',
      'deliveryFare': 300,
      'productRating': 2.5,
      'productReviewers': [
        {
          'reviewerName': 'Veronika',
          'reviewerNotes':
              'I loved this food from the first time I got into contact with it.The seller is so friendly and calm ',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> restaurants = [
    {
      'restaurantId': 1,
      'restaurantName': 'KFC',
      'restaurantDescription':
          'KFC is a popular restaurant that serves good food.',
      'restaurantLogo':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
    },
    {
      'restaurantId': 2,
      'restaurantName': 'KFC',
      'restaurantDescription':
          'KFC is a popular restaurant that serves good food.',
      'restaurantLogo':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
    },
    {
      'restaurantId': 3,
      'restaurantName': 'KFC',
      'restaurantDescription':
          'KFC is a popular restaurant that serves good food.',
      'restaurantLogo':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
    },
    {
      'restaurantId': 4,
      'restaurantName': 'KFC',
      'restaurantDescription':
          'KFC is a popular restaurant that serves good food.',
      'restaurantLogo':
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
    },
  ];
}
