import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
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
  final ProductsData productsData = ProductsData();
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentSliderPage = 0;

  @override
  Widget build(BuildContext context) {
    final totalProducts = productsData.products.length;

    final grouped = groupBy(
      productsData.products,
      (product) => product['productCategory'],
    );

    
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              autoPlayInterval: const Duration(seconds: 5),
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
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: _currentSliderPage == index ? 40 : 10,
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Categories"),
                            TextButton(
                              onPressed: () {},
                              child: Text('See All'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 100,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                            itemCount: grouped.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final clothing = grouped['FASHION_AND_APPAREL'] ?? [];
                              final category = grouped.values.elementAt(index);
                              return Column(
                                children: [
                                  clothing.isNotEmpty
                                      ? Text(clothing.toString())
                                      : Text('Nothing'),
                                ],
                              );
                            },
                          ),
                        ),
                        CustomButtonWidget(
                          buttonTitle: 'buttonTitle',
                          onPressed: () {
                            dev.log(grouped.toString());
                          },
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
    );
  }
}
