import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:developer' as dev;

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  TextEditingController searchFieldController = TextEditingController();
  final ProductsData productsData = ProductsData();
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentSliderPage = 0;

  //search data
  List<Map<String, dynamic>> searchResults = [];
  final String ownerCurrency = 'dollars';

  List<dynamic> searchHistory = [];
  List<Map<String, dynamic>> filteredValues = [];

  final AppServices appServices = AppServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupBy(
      productsData.products,
      (product) => product['productCategory'],
    );

    final products = productsData.products;

    final topProducts = appServices.getTopProducts(products);
    final List topProductsList = topProducts['sortedProducts'];

    final entries = grouped.entries.toList();

    final List productsLessThanSevenDays = appServices.getLatestItems(products);

    final List discountedProducts = appServices.getDiscountedItems(products);

    final List mostPopularProducts = appServices.getMostPopularItems(products);

    final List<Map<String, dynamic>> userFavorite = productsData.userFavorite;

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
                    product['productCategory']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()),
              )
              .toList();
      searchFieldResult = searchedProduct;
      return searchFieldResult;
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    //display search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
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
                            dev.log(
                              name: 'Search Result',
                              searchResults.toString(),
                            );
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppConstants.greyedColor.withAlpha(100),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            prefixIcon: Icon(Icons.search),
                            hintText: "Search",
                            hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 160, 157, 157),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),

                        //display advert
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: CarouselSlider(
                                  carouselController: _controller,
                                  items:
                                      productsData.advertData.map((e) {
                                        return CachedNetworkImage(
                                          errorWidget: (context, url, error) {
                                            return Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            );
                                          },
                                          imageUrl: e['advertImage'],
                                          fit: BoxFit.cover,
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
                                    autoPlayInterval: const Duration(
                                      seconds: 5,
                                    ),
                                    autoPlayAnimationDuration: const Duration(
                                      milliseconds: 800,
                                    ),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  productsData.advertData.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    width:
                                        _currentSliderPage == index ? 40 : 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color:
                                          _currentSliderPage == index
                                              ? AppConstants.primaryColor
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        searchResults.isNotEmpty
                            ? _buildSearchItemsDisplay()
                            : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Categories",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.copyWith(
                                          color: AppConstants.textColor,
                                          fontFamily:
                                              AppConstants.fontFamilyRaleway,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 25,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'See All',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            color: AppConstants.textColor,
                                            fontFamily:
                                                AppConstants.fontFamilyRaleway,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 255,
                                    child: ListView.builder(
                                      itemCount: entries.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final entry = entries[index];
                                        final String categoryKey =
                                            entry.key as String;
                                        final List<Map<String, dynamic>>
                                        productsInCategory =
                                            (entry.value as List)
                                                .cast<Map<String, dynamic>>();

                                        // First images from the first 4 products in this category
                                        final List<String> thumbs =
                                            productsInCategory
                                                .take(4)
                                                .map(
                                                  (p) =>
                                                      (p['productImage']
                                                                  as List)
                                                              .first
                                                          as String,
                                                )
                                                .toList();

                                        return Card(
                                          elevation: 0.5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // 2x2 thumbnail grid (up to 4)
                                                SizedBox(
                                                  width: 199.56,
                                                  height: 200,
                                                  child: GridView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          mainAxisSpacing: 6,
                                                          crossAxisSpacing: 6,
                                                        ),
                                                    itemCount: thumbs.length,
                                                    itemBuilder: (context, i) {
                                                      final url = thumbs[i];
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: CachedNetworkImage(
                                                          width: 90.71,
                                                          height: 75,
                                                          imageUrl: url,
                                                          fit: BoxFit.cover,

                                                          errorWidget:
                                                              (
                                                                c,
                                                                u,
                                                                e,
                                                              ) => const Icon(
                                                                Icons
                                                                    .broken_image,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                // Bottom: Category name + count
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      categoryKey.replaceAll(
                                                        '_',
                                                        ' ',
                                                      ), // from ENUM_NAME to readable
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(width: 30),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black12,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              20,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        '${productsInCategory.length}',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                        //top items section (top items are items with the highest ratings)
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Top Products',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.copyWith(
                                      color: AppConstants.textColor,
                                      fontFamily:
                                          AppConstants.fontFamilyRaleway,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'See All',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: AppConstants.textColor,
                                        fontFamily:
                                            AppConstants.fontFamilyRaleway,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  itemCount: topProductsList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final product = topProductsList[index];
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: AppConstants.backgroundColor,
                                          width: 8,
                                        ),
                                        color: AppConstants.backgroundColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(right: 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                        child: CachedNetworkImage(
                                          width: 70,
                                          height: 70,
                                          imageUrl:
                                              product['productImage'].first ??
                                              '',

                                          fit: BoxFit.fill,
                                          errorWidget:
                                              (c, u, e) => const Icon(
                                                Icons.broken_image,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        //latest products
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'New Items',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.copyWith(
                                      color: AppConstants.textColor,
                                      fontFamily:
                                          AppConstants.fontFamilyRaleway,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'See All',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        color: AppConstants.textColor,
                                        fontFamily:
                                            AppConstants.fontFamilyRaleway,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 230,
                                child: ListView.builder(
                                  itemCount: productsLessThanSevenDays.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final product =
                                        productsLessThanSevenDays[index];
                                    return Container(
                                      width: 140,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        // border: Border.all(
                                        //   color: AppConstants.backgroundColor,
                                        //   width: 8,
                                        // ),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: CachedNetworkImage(
                                              width: 140,
                                              height: 140,
                                              imageUrl:
                                                  product['productImage']
                                                      .first ??
                                                  '',

                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (c, u, e) => const Icon(
                                                    Icons.broken_image,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            product['productName'].toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontFamily:
                                                  AppConstants.fontFamilyNunito,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            product['productDescription']
                                                .toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontFamily:
                                                  AppConstants.fontFamilyNunito,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '${ownerCurrency == 'dollars' ? '\$' : 'GHS'}${product['productPrice'].toString()}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontFamily:
                                                  AppConstants.fontFamilyNunito,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        //flash sale
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Flash Sale',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontFamily: AppConstants.fontFamilyNunito,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 250,
                                child: GridView.builder(
                                  itemCount: discountedProducts.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 0.0,
                                        mainAxisSpacing: 19.0,
                                        childAspectRatio: 1.0,
                                      ),
                                  itemBuilder: (context, index) {
                                    final product = discountedProducts[index];
                                    return Container(
                                      width: 109,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3.0,
                                          color: Colors.white,
                                        ),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: CachedNetworkImage(
                                              width: 109,
                                              height: 115,
                                              imageUrl:
                                                  product['productImage']
                                                      .first ??
                                                  '',

                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (c, u, e) => const Icon(
                                                    Icons.broken_image,
                                                  ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 10,
                                            child: Container(
                                              width: 70,
                                              height: 30,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '-${product['productDiscount']}%',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        fontFamily:
                                                            AppConstants
                                                                .fontFamilyNunito,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                        color:
                                                            AppConstants
                                                                .backgroundColor,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        //most popular items
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Most Popular',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontFamily:
                                          AppConstants.fontFamilyRaleway,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'See All',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontFamily:
                                            AppConstants.fontFamilyNunito,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  itemCount: mostPopularProducts.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final product = mostPopularProducts[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: CachedNetworkImage(
                                              width: 115,
                                              height: 115,
                                              imageUrl:
                                                  product['productImage']
                                                      .first ??
                                                  '',

                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (c, u, e) => const Icon(
                                                    Icons.broken_image,
                                                  ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                product['productLikes']
                                                    .toString(),
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium?.copyWith(
                                                  fontFamily:
                                                      AppConstants
                                                          .fontFamilyRaleway,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20,
                                                  color: AppConstants.textColor,
                                                ),
                                              ),
                                              Icon(
                                                Icons.favorite,
                                                color:
                                                    AppConstants.primaryColor,
                                              ),
                                              SizedBox(width: 30),
                                              Text(
                                                productsLessThanSevenDays
                                                        .contains(product)
                                                    ? "New"
                                                    : discountedProducts
                                                        .contains(product)
                                                    ? "Flash"
                                                    : mostPopularProducts
                                                        .contains(product)
                                                    ? "Hot"
                                                    : "Regular",
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium?.copyWith(
                                                  fontFamily:
                                                      AppConstants
                                                          .fontFamilyRaleway,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: AppConstants.textColor,
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
                            ),
                          ],
                        ),

                        //user favorites
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Just For You',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontFamily:
                                          AppConstants.fontFamilyRaleway,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.star,
                                    color: AppConstants.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 240,
                                child: GridView.builder(
                                  itemCount: userFavorite.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 0.0,
                                        mainAxisSpacing: 0.0,
                                        childAspectRatio: 1.0,
                                      ),
                                  itemBuilder: (context, index) {
                                    final product = userFavorite[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin: const EdgeInsets.only(right: 12),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: CachedNetworkImage(
                                              width: 100,
                                              height: 100,
                                              imageUrl:
                                                  product['productImage']
                                                      .first ??
                                                  '',

                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (c, u, e) => const Icon(
                                                    Icons.broken_image,
                                                  ),
                                            ),
                                          ),
                                          Text(
                                            product['productName'].toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontFamily:
                                                  AppConstants.fontFamilyNunito,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            product['productDescription']
                                                .toString(),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontFamily:
                                                  AppConstants.fontFamilyNunito,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '${ownerCurrency == 'dollars' ? '\$' : 'GHS'}${product['productPrice'].toString()}',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              fontFamily:
                                                  AppConstants.fontFamilyNunito,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchItemsDisplay() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search Results',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: AppConstants.fontFamilyNunito,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 550,
              child: GridView.builder(
                physics: PageScrollPhysics(),
                itemCount: searchResults.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio:
                      0.79, //child aspect ratio controls heigh and width in grid view
                ),
                itemBuilder: (context, index) {
                  final product = searchResults[index];
                  return Container(
                    width: 155,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3.0, color: Colors.white),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            width: 155,
                            height: 171,
                            imageUrl: product['productImage'].first ?? '',

                            fit: BoxFit.cover,
                            errorWidget:
                                (c, u, e) => const Icon(Icons.broken_image),
                          ),
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          product['productName'],
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontFamily: AppConstants.fontFamilyNunito,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          product['productDescription'],
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontFamily: AppConstants.fontFamilyNunito,
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          '${ownerCurrency == 'dollars' ? '\$' : 'GHS'}${product['productPrice'].toString()}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontFamily: AppConstants.fontFamilyNunito,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
