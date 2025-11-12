import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/food_data.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerFood extends StatefulWidget {
  const CustomerFood({super.key});

  @override
  State<CustomerFood> createState() => _CustomerFoodState();
}

class _CustomerFoodState extends State<CustomerFood> {
  int _currentSliderPage = 0;
  ProductsData productsData = ProductsData();

  List<Map<String, dynamic>> products = [];

  TextEditingController searchFieldController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];

  final CarouselSliderController _controller = CarouselSliderController();

  FoodData foodData = FoodData();

  String ownerCurrency = 'dollars';

  Future<List<Map<String, dynamic>>> handleSearchFieldChange() async {
    final String searchQuery = searchFieldController.text;
    List<Map<String, dynamic>> searchFieldResult = [];

    final searchedProduct =
        products
            .where(
              (product) =>
                  product['productName'].toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  product['productCategory'].toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
            )
            .toList();
    searchFieldResult = searchedProduct;
    return searchFieldResult;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildSearchTextField(),
                    const SizedBox(height: 16),
                    _buildBanner(),
                    const SizedBox(height: 24),
                    _buildFeaturedRestaurants(),
                    const SizedBox(height: 24),
                    _buildCategories(),
                    const SizedBox(height: 24),
                    _buildExploreFoods(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: searchFieldController,
          onChanged: (value) async {
            final results = await handleSearchFieldChange();
            if (searchFieldController.text.isNotEmpty) {
              setState(() {
                searchResults = results;
              });
            } else {
              searchResults = [];
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppConstants.greyedColor.withOpacity(0.3),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppConstants.primaryColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            prefixIcon: Icon(Icons.search, color: AppConstants.primaryColor),
            hintText: "Search for food, restaurants...",
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontFamily: AppConstants.fontFamilyRaleway,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CarouselSlider(
                carouselController: _controller,
                items:
                    productsData.advertData.map((e) {
                      return Container(
                        width: double.infinity,
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          errorWidget: (context, url, error) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.error, color: Colors.red[300]),
                            );
                          },
                          imageUrl: e['advertImage'],
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentSliderPage = index;
                    });
                  },
                  height: 200,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              productsData.advertData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentSliderPage == index ? 32 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color:
                      _currentSliderPage == index
                          ? AppConstants.primaryColor
                          : Colors.grey[400],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedRestaurants() {
    List<Map<String, dynamic>> restaurants = foodData.restaurants;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Restaurants',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: AppConstants.fontFamilyRaleway,
                  color: AppConstants.textColor,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
                    fontFamily: AppConstants.fontFamilyRaleway,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> restaurant = restaurants[index];
                String restaurantImage = restaurant['restaurantLogo'] ?? "";
                String restaurantName = restaurant['restaurantName'] ?? "";

                return InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppConstants.primaryColor.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: restaurantImage,
                              placeholder:
                                  (context, url) => CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppConstants.primaryColor,
                                    ),
                                  ),
                              errorWidget: (context, url, error) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.restaurant,
                                    color: Colors.grey[400],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            restaurantName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppConstants.fontFamilyRaleway,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFamily: AppConstants.fontFamilyRaleway,
                  color: AppConstants.textColor,
                  fontSize: 20,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppConstants.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildCategoryItem(Icons.restaurant_menu, 'Popular Cuisine'),
                  const SizedBox(width: 12),
                  _buildCategoryItem(Icons.local_dining, 'Local Cuisine'),
                  const SizedBox(width: 12),
                  _buildCategoryItem(Icons.fastfood, 'Fast Foods'),
                  const SizedBox(width: 12),
                  _buildCategoryItem(Icons.cake, 'Deserts'),
                  const SizedBox(width: 12),
                  _buildCategoryItem(Icons.local_drink, 'Drinks'),
                  const SizedBox(width: 12),
                  _buildCategoryItem(Icons.dinner_dining, 'Dinner'),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String title) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppConstants.primaryColor, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppConstants.fontFamilyRaleway,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreFoods() {
    List<Map<String, dynamic>> foods = foodData.foodItems;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Foods',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontFamily: AppConstants.fontFamilyRaleway,
              color: AppConstants.textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foods.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              Map<String, dynamic> food = foods[index];

              String foodName = food['productName'] ?? 'N/A';
              String foodDesc = food['productDescription'] ?? '';
              double foodPrice = food['productPrice'] ?? 0;
              String foodImage = food['productImage'][0] ?? "";
              int discount = food['productDiscount'] ?? 0;
              bool isDiscounted =
                  food['productDiscount'] != null &&
                  food['productDiscount'] > 0;

              double discountAmount = (discount / 100) * foodPrice;
              double newAmount = foodPrice - discountAmount;

              return InkWell(
                onTap:
                    () =>
                        context.push('/product-details', extra: {'item': food}),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 140,
                              child: CachedNetworkImage(
                                imageUrl: foodImage,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey[400],
                                    ),
                                  );
                                },
                                placeholder:
                                    (context, url) => Container(
                                      color: Colors.grey[100],
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppConstants.primaryColor,
                                              ),
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          if (isDiscounted)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.errorColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$discount% OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foodName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppConstants.fontFamilyRaleway,
                                fontWeight: FontWeight.w700,
                                color: AppConstants.textColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              foodDesc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppConstants.fontFamilyRaleway,
                                color: Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${ownerCurrency == 'dollars' ? '\$' : 'GHS'} ${isDiscounted ? newAmount.toStringAsFixed(2) : foodPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontFamily: AppConstants.fontFamilyRaleway,
                                    fontWeight: FontWeight.w800,
                                    color: AppConstants.primaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                                if (isDiscounted) ...[
                                  const SizedBox(width: 6),
                                  Text(
                                    '${ownerCurrency == 'dollars' ? '\$' : 'GHS'} ${foodPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.red[500],
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
