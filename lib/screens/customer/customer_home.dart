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
                          onChanged: (value) {},
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

                        //categories section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Categories"),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('See All'),
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
                                                  (p['productImage'] as List)
                                                          .first
                                                      as String,
                                            )
                                            .toList();

                                    return Card(
                                      elevation: 0.5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // 2x2 thumbnail grid (up to 4)
                                            SizedBox(
                                              width: 192.76,
                                              height: 199,
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
                                                      imageUrl: url,
                                                      fit: BoxFit.cover,

                                                      errorWidget:
                                                          (
                                                            c,
                                                            u,
                                                            e,
                                                          ) => const Icon(
                                                            Icons.broken_image,
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
                                                    fontWeight: FontWeight.w600,
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
                                                    shape: BoxShape.rectangle,
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
                                  Text('Top Products'),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('See All'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                itemCount: topProductsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final product = topProductsList[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          child: CachedNetworkImage(
                                            width: 90,
                                            height: 90,
                                            imageUrl:
                                                product['productImage'].first ??
                                                '',

                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (c, u, e) => const Icon(
                                                  Icons.broken_image,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
}
