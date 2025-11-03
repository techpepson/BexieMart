import 'package:bexie_mart/components/empty_favorites.dart';
import 'package:bexie_mart/components/fav_component.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/data/products_data.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  ProductsData products = ProductsData();

  AppServices appServices = AppServices();

  DateTime defaultWatchTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wishlist',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontFamily: AppConstants.fontFamilyRaleway,
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildRecentlyViewedItems(),
                      _buildFavoritesDisplay(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentlyViewedItems() {
    List<Map<String, dynamic>> recentlyWatched = products.recentlyWatched;
    String formattedDate = DateFormat('yyy-MM-dd').format(defaultWatchTime);

    List<Map<String, dynamic>> items = appServices.getItemsOverTime(
      recentlyWatched,
      formattedDate,
    );

    //get the items that have been watched within the current time
    return Column(
      children: [
        SizedBox(
          width: 500,
          child: Row(
            children: [
              Text(
                'Recently Viewed',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: AppConstants.fontFamilyRaleway,
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                ),
              ),
              Spacer(),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  onPressed: () {
                    context.push('/customer-home/recently-viewed');
                  },
                  icon: Icon(Icons.arrow_forward),
                  color: AppConstants.backgroundColor,
                  padding: EdgeInsets.all(0),
                ),
              ),
              SizedBox(width: 18),
            ],
          ),
        ),
        items.isEmpty
            ? Center(child: Text('No Recently Viewed Items'))
            : SizedBox(
              height: 80,
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(width: 15),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item = items[index];
                  String itemImg = item['productImage'][0] ?? "";
                  return Container(
                    width: 50, // must be equal
                    height: 50, // must be equal
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppConstants.primaryColor.withAlpha(40),
                        width: 2,
                      ),
                    ),
                    clipBehavior:
                        Clip.antiAlias, // ensures the image is clipped perfectly
                    child: CachedNetworkImage(
                      imageUrl: itemImg,
                      fit: BoxFit.cover, // fill the circle completely
                      placeholder:
                          (context, url) => Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Icon(Icons.broken_image),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }

  Widget _buildFavoritesDisplay() {
    return products.userFavorite.isNotEmpty ? FavComponent() : EmptyFavorites();
  }

  void showDatePicker() {}
}
