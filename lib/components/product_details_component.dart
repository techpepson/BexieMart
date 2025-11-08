import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:bexie_mart/components/elevated_button_widget.dart';
import 'package:bexie_mart/constants/app_constants.dart';
import 'package:bexie_mart/services/app_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductDetailsComponent extends StatefulWidget {
  const ProductDetailsComponent({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  State<ProductDetailsComponent> createState() =>
      ProductDetailsComponentState();
}

class ProductDetailsComponentState extends State<ProductDetailsComponent> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentSliderPage = 0;
  bool isFavorite = false;

  String ownerCurrency = 'dollars';
  AppServices appServices = AppServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color:
                        isFavorite
                            ? AppConstants.primaryColor.withAlpha(25)
                            : Colors.grey.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isFavorite
                              ? AppConstants.primaryColor.withAlpha(100)
                              : Colors.grey.withAlpha(100),
                      width: 1.5,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color:
                          isFavorite
                              ? AppConstants.primaryColor
                              : Colors.grey[600],
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButtonWidget(
                    buttonTitle: 'Add to Cart',
                    onPressed: () {},
                    isDisabled: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButtonWidget(
                    buttonTitle: 'Buy Now',
                    onPressed: () {},
                    isDisabled: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Product Details',
          style: TextStyle(
            color: AppConstants.textColor,
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
              maxWidth: constraints.maxWidth,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagesDisplay(),
                      const SizedBox(height: 24),
                      _buildItemDetails(),
                      const SizedBox(height: 24),
                      _buildDeliveryOptions(),
                      const SizedBox(height: 24),
                      _buildReviews(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagesDisplay() {
    List<String> productImages = widget.item['productImage'];
    return Column(
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
                color: Colors.black.withAlpha(20),
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
                  productImages.map((e) {
                    return Container(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        errorWidget: (context, url, error) {
                          return Container(
                            color: Colors.grey.withAlpha(50),
                            child: Icon(
                              Icons.error,
                              color: Colors.red[300],
                              size: 40,
                            ),
                          );
                        },
                        imageUrl: e,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: Colors.grey.withAlpha(30),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppConstants.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                      ),
                    );
                  }).toList(),
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentSliderPage = index;
                  });
                },
                height: 350,
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
            productImages.length,
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
    );
  }

  Widget _buildItemDetails() {
    bool isDiscounted =
        widget.item['productDiscount'] != null &&
        widget.item['productDiscount'] > 0;

    double itemPrice =
        widget.item['productPrice'] is double
            ? widget.item['productPrice']
            : double.tryParse(widget.item['productPrice'].toString()) ?? 0.0;
    int discountRate = widget.item['productDiscount'] ?? 0;
    double discountAmount = (discountRate / 100) * itemPrice;
    double newAmount = itemPrice - discountAmount;
    String discountExpiry = widget.item['productDiscountEndDate'] ?? "";
    DateTime? discountExpiryDate;
    if (discountExpiry.isNotEmpty) {
      discountExpiryDate = appServices.parseStringToDate(discountExpiry);
    }

    String itemDesc = widget.item['productDescription'] ?? '';
    String itemSize = widget.item['productSize'] ?? 'medium';
    String itemColor = widget.item['productColor'] ?? '';
    String sellerName = widget.item['productSeller'] ?? '';
    int stockQuantity = widget.item['productQuantity'] ?? 0;

    String productSize = '';

    switch (itemSize.toLowerCase()) {
      case 'small':
        productSize = 'S';
        break;
      case 'large':
        productSize = 'L';
        break;
      case 'medium':
        productSize = 'M';
        break;
      case 'extralarge':
        productSize = 'XL';
        break;
      default:
        productSize = 'M';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.item['productName'] ?? 'Product Name',
                  style: TextStyle(
                    fontFamily: AppConstants.fontFamilyRaleway,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppConstants.textColor,
                  ),
                ),
              ),
              if (isDiscounted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.errorColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$discountRate%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        'OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:
                      stockQuantity > 0
                          ? Colors.green.withAlpha(25)
                          : Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      stockQuantity > 0 ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: stockQuantity > 0 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$stockQuantity in Stock',
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyRaleway,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: stockQuantity > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.share, color: AppConstants.primaryColor),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${ownerCurrency == 'dollars' ? '\$' : 'GHS'} ${isDiscounted ? newAmount.toStringAsFixed(2) : itemPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: AppConstants.fontFamilyRaleway,
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                  color: AppConstants.primaryColor,
                ),
              ),
              if (isDiscounted) ...[
                const SizedBox(width: 12),
                Text(
                  '${ownerCurrency == 'dollars' ? '\$' : 'GHS'} ${itemPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: AppConstants.fontFamilyRaleway,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.grey[600],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          if (isDiscounted && discountExpiryDate != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, size: 14, color: AppConstants.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    'Offer ends: ${discountExpiryDate.toString().split(' ')[0]}',
                    style: TextStyle(
                      fontFamily: AppConstants.fontFamilyRaleway,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            itemDesc,
            style: TextStyle(
              fontFamily: AppConstants.fontFamilyRaleway,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppConstants.textColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (itemColor.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withAlpha(100)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getColorFromString(itemColor),
                          border: Border.all(
                            color: Colors.grey.withAlpha(150),
                            width: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        itemColor,
                        style: TextStyle(
                          fontFamily: AppConstants.fontFamilyRaleway,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppConstants.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.primaryColor.withAlpha(100),
                  ),
                ),
                child: Text(
                  'Size: $productSize',
                  style: TextStyle(
                    fontFamily: AppConstants.fontFamilyRaleway,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          if (sellerName.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.store, color: AppConstants.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Sold by: $sellerName',
                    style: TextStyle(
                      fontFamily: AppConstants.fontFamilyRaleway,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppConstants.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    final colorMap = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'black': Colors.black,
      'white': Colors.white,
      'grey': Colors.grey,
      'brown': Colors.brown,
    };
    return colorMap[colorName.toLowerCase()] ?? Colors.grey;
  }

  Widget _buildDeliveryOptions() {
    List<Map<String, dynamic>> deliveryOptions =
        widget.item['deliveryOptions'] ?? [];

    if (deliveryOptions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Options',
          style: TextStyle(
            fontFamily: AppConstants.fontFamilyRaleway,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppConstants.textColor,
          ),
        ),
        const SizedBox(height: 12),
        ...deliveryOptions.map((option) {
          String deliveryType = option['deliveryType'] ?? "";
          int daysToDelivery = option['daysToDelivery'] ?? 1;
          double deliveryFee = option['deliveryFee'] ?? 0.0;

          List splitDeliveryType = deliveryType.split("");
          String firstDigitOfType =
              splitDeliveryType.isNotEmpty
                  ? splitDeliveryType[0].toString().toUpperCase()
                  : "";

          String capitalizedDeliveryType =
              splitDeliveryType.isNotEmpty
                  ? firstDigitOfType + splitDeliveryType.sublist(1).join('')
                  : deliveryType;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withAlpha(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: AppConstants.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              capitalizedDeliveryType,
                              style: TextStyle(
                                fontFamily: AppConstants.fontFamilyRaleway,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppConstants.textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$daysToDelivery ${daysToDelivery == 1 ? 'day' : 'days'} delivery',
                              style: TextStyle(
                                fontFamily: AppConstants.fontFamilyRaleway,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${ownerCurrency == 'dollars' ? '\$' : 'GHS'} ${deliveryFee.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: AppConstants.fontFamilyRaleway,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildReviews() {
    List<Map<String, dynamic>> productReviews =
        widget.item['productReviewers'] ?? [];

    double averageRating = 0.0;
    if (productReviews.isNotEmpty) {
      final totalRatings = productReviews.fold<double>(
        0.0,
        (sum, reviewer) => sum + (reviewer['reviewerRating'] ?? 0.0),
      );
      averageRating = totalRatings / productReviews.length;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ratings & Reviews',
              style: TextStyle(
                fontFamily: AppConstants.fontFamilyRaleway,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppConstants.textColor,
              ),
            ),
            if (productReviews.isNotEmpty)
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                        fontFamily: AppConstants.fontFamilyRaleway,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (productReviews.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.star_border,
                  size: 48,
                  color: Colors.grey.withAlpha(150),
                ),
                const SizedBox(height: 12),
                Text(
                  'No reviews yet',
                  style: TextStyle(
                    fontFamily: AppConstants.fontFamilyRaleway,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyRaleway,
                        fontWeight: FontWeight.w800,
                        fontSize: 36,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedRatingStars(
                      onChanged: (double rating) {},
                      initialRating: averageRating,
                      minRating: 0.0,
                      maxRating: 5.0,
                      filledColor: Colors.amber,
                      emptyColor: Colors.grey.withAlpha(100),
                      filledIcon: Icons.star,
                      halfFilledIcon: Icons.star_half,
                      emptyIcon: Icons.star_border,
                      displayRatingValue: false,
                      interactiveTooltips: false,
                      customFilledIcon: Icons.star,
                      customHalfFilledIcon: Icons.star_half,
                      customEmptyIcon: Icons.star_border,
                      starSize: 24.0,
                      animationDuration: const Duration(milliseconds: 300),
                      animationCurve: Curves.easeInOut,
                      readOnly: true,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${productReviews.length} ${productReviews.length == 1 ? 'review' : 'reviews'}',
                      style: TextStyle(
                        fontFamily: AppConstants.fontFamilyRaleway,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...productReviews.take(3).map((review) {
            String profileImage = review['reviewerProfileImage'] ?? "";
            String reviewerName = review['reviewerName'] ?? "";
            String reviewerNotes = review['reviewerNotes'] ?? "";
            double reviewerRating = review['reviewerRating'] ?? 0.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withAlpha(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      width: 50,
                      height: 50,
                      imageUrl: profileImage,
                      errorWidget:
                          (context, url, error) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(50),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person, color: Colors.grey[400]),
                          ),
                      placeholder:
                          (context, url) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConstants.primaryColor,
                              ),
                            ),
                          ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reviewerName,
                          style: TextStyle(
                            fontFamily: AppConstants.fontFamilyRaleway,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppConstants.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedRatingStars(
                          initialRating: reviewerRating,
                          minRating: 0.0,
                          maxRating: 5.0,
                          filledColor: Colors.amber,
                          emptyColor: Colors.grey.withAlpha(100),
                          filledIcon: Icons.star,
                          halfFilledIcon: Icons.star_half,
                          emptyIcon: Icons.star_border,
                          onChanged: (double rating) {},
                          displayRatingValue: false,
                          interactiveTooltips: false,
                          customFilledIcon: Icons.star,
                          customHalfFilledIcon: Icons.star_half,
                          customEmptyIcon: Icons.star_border,
                          starSize: 16.0,
                          animationDuration: const Duration(milliseconds: 300),
                          animationCurve: Curves.easeInOut,
                          readOnly: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          reviewerNotes,
                          style: TextStyle(
                            fontFamily: AppConstants.fontFamilyRaleway,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppConstants.textColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ],
    );
  }
}
