import 'package:bexie_mart/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllItemsDisplayComponent extends StatefulWidget {
  AllItemsDisplayComponent({
    super.key,
    required this.items,

    this.ownerCurrency = "dollars",
  });

  final List<Map<String, dynamic>> items;

  String ownerCurrency = 'dollars';

  @override
  State<AllItemsDisplayComponent> createState() =>
      _AllItemsDisplayComponentState();
}

class _AllItemsDisplayComponentState extends State<AllItemsDisplayComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.items.length,
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 1.0,
          crossAxisSpacing: 0.0,
          crossAxisCount: 2,
          mainAxisExtent: 280.0,
        ),
        itemBuilder: (context, index) {
          Map<String, dynamic> item = widget.items[index];
          String itemImg = item['productImage'][0] ?? "";
          String itemName = item['productName'] ?? "";
          String itemDesc = item['productDescription'] ?? '';
          double itemPrice =
              item['productPrice'] is double
                  ? item['productPrice']
                  : double.tryParse(item['productPrice']);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.greyedColor,
                      blurRadius: 1.5,
                      spreadRadius: 1.5,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                width: 140,
                height: 181,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: itemImg,
                    fit: BoxFit.cover,
                    errorWidget:
                        (context, url, error) => Icon(Icons.broken_image),
                    placeholder:
                        (context, url) =>
                            Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              Text(
                itemName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: AppConstants.fontFamilyNunito,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              Text(
                itemDesc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: AppConstants.fontFamilyNunito,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Text(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: AppConstants.fontFamilyNunito,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                    "${widget.ownerCurrency == 'dollars' ? "\$" : "GHS"} $itemPrice",
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
