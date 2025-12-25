import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/app_dialogs.dart';
import 'package:ecommerce_app/core/constants/widgets/app_loading.dart';
import 'package:ecommerce_app/features/order/domain/entity/order_create.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_event.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_state.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_event.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_state.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/review_widget.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_bloc.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_event.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:ui';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final int productId;
  int selectedImageIndex = 0;
  late final PageController pageController;
  bool isFavorite = false;
  String? selectedSize;
  Timer? _autoScrollTimer;
  bool _userInteracted = false;
  bool _scrollForward = true;
  int? addressId;
  late int categoryId;
  int purchaseQuantity = 1;
  int availableQuantity = 0;
  double discount = 0.0;
  bool _isHandlingSuccess = false;

  @override
  void initState() {
    super.initState();
    productId = Get.arguments as int;
    pageController = PageController(initialPage: 0);
    context.read<ProductBloc>().add(GetProductByIdEvent(productId));
    context.read<ReviewBloc>().add(ReviewGetAllEvent(productId));
    _startAutoScroll();
    _getAddressId();
  }

  void _refreshReviews() {
    context.read<ReviewBloc>().add(ReviewGetAllEvent(productId));
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_userInteracted) return;
      final state = context.read<ProductBloc>().state;
      if (state is ProductLoadedState &&
          state.product.productsImages.length > 1) {
        final imagesLen = state.product.productsImages.length;
        int nextIndex = selectedImageIndex + (_scrollForward ? 1 : -1);
        if (nextIndex >= imagesLen) {
          _scrollForward = false;
          nextIndex = imagesLen - 2;
        } else if (nextIndex < 0) {
          _scrollForward = true;
          nextIndex = 1;
        }
        pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onThumbnailTap(int index) {
    setState(() {
      selectedImageIndex = index;
      _userInteracted = true;
    });
    pageController.jumpToPage(index);
    _autoScrollTimer?.cancel();
  }

  Future<void> _getAddressId() async {
    final pref = await SharedPreferences.getInstance();
    int? id = pref.getInt('default_address_id');

    print("=========the address id is $id =====");
    if (mounted) {
      setState(() {
        addressId = id;
      });
      print("Loaded address ID: $addressId");
    }
  }

  void _placeOrder() async {
    // Reload address ID before placing order to ensure it's up to date
    await _getAddressId();

    print("========== ORDER PLACEMENT DEBUG ==========");
    print("Address ID: $addressId");
    print("Product ID: $productId");
    print("Category ID: $categoryId");
    print("Purchase Quantity: $purchaseQuantity");
    print("Discount: $discount");
    print("===========================================");

    // Check if address is selected
    if (addressId == null) {
      final result = await AppDialogs.showConfirmationDialog(
        context: context,
        title: 'Address Required',
        message: 'Please add a delivery address to continue with your order.',
        confirmText: 'Add Address',
        cancelText: 'Cancel',
        icon: Icons.location_on_rounded,
      );

      if (result == true && mounted) {
        // Navigate to address page and reload address when returning
        await Get.toNamed('/userdetails');
        // Reload address after returning
        await _getAddressId();
      }
      return;
    }

    // Check if size is selected (if sizes are available)
    if (!mounted) return;
    final state = context.read<ProductBloc>().state;
    if (state is ProductLoadedState &&
        state.product.sizes.isNotEmpty &&
        selectedSize == null) {
      await AppDialogs.showErrorDialog(
        context: context,
        title: 'Size Required',
        message: 'Please select a size before placing your order.',
        buttonText: 'OK',
      );
      return;
    }

    // Check if quantity is valid
    if (purchaseQuantity <= 0 || purchaseQuantity > availableQuantity) {
      await AppDialogs.showErrorDialog(
        context: context,
        title: 'Invalid Quantity',
        message: 'Please select a valid quantity (1-$availableQuantity).',
        buttonText: 'OK',
      );
      return;
    }

    // Show confirmation dialog
    final confirm = await AppDialogs.showConfirmationDialog(
      context: context,
      title: 'Confirm Order',
      message:
          'Place order for $purchaseQuantity item(s)? Your payment will be processed.',
      confirmText: 'Place Order',
      cancelText: 'Cancel',
      icon: Icons.shopping_bag_rounded,
    );

    if (confirm == true && mounted) {
      print("place order is called");

      // Final check: ensure addressId is valid before placing order
      if (addressId == null) {
        print("ERROR: addressId is null, cannot place order");
        await AppDialogs.showErrorDialog(
          context: context,
          title: 'Address Required',
          message:
              'Please select a delivery address before placing your order.',
          buttonText: 'OK',
        );
        return;
      }

      print("Creating order with addressId: $addressId");
      context.read<OrderBloc>().add(
        OrderPlaceEvent(
          OrderCreate(
            productId: productId,
            categoryId: categoryId,
            purchaseQuantity: purchaseQuantity,
            addressId: addressId,
            discount: discount,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _isHandlingSuccess = false;
    pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listenWhen: (previous, current) {
        // Only listen to state changes, not rebuilds of the same state
        return previous.runtimeType != current.runtimeType;
      },
      listener: (context, state) async {
        if (state is OrderLoadingState) {
          _isHandlingSuccess = false; // Reset flag when loading starts
          AppLoading.show(context, message: 'Placing your order...');
        } else if (state is OrderPlacedState) {
          if (_isHandlingSuccess) return; // Already handling success, skip
          _isHandlingSuccess = true;
          
          AppLoading.hide();
          if (!mounted) return;
          
          if (state.isSuccess) {
            await AppDialogs.showSuccessDialog(
              context: context,
              title: 'Order Placed Successfully!',
              message:
                  'Your order has been confirmed. Track your order in the Orders section.',
              buttonText: 'Ok',
            );
          }
        } else if (state is OrderFailedState) {
          AppLoading.hide();
          if (!mounted) return;
          
          await AppDialogs.showErrorDialog(
            context: context,
            title: 'Order Failed',
            message: 'Unable to place your order. Please try again.',
            buttonText: 'Try Again',
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppcolorPallets.scaffoldBackground,
              AppcolorPallets.secondaryColor,
              Colors.white,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: customAppBar("Product Details", context),
          body: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductLoadedState) {
                setState(() {
                  categoryId = state.product.categoryId;
                  availableQuantity = state.inventory.availableQuantity;
                  // Calculate discount if there are coupons
                  if (state.coupons != null && state.coupons!.isNotEmpty) {
                    state.coupons!.sort(
                      (a, b) => (b.discountPercentage ?? 0).compareTo(
                        a.discountPercentage ?? 0,
                      ),
                    );
                    discount = state.coupons!.first.discountPercentage ?? 0.0;
                  }
                });
              }
            },
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return _buildShimmerLoading();
                }
                if (state is ProductLoadingFailedState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppcolorPallets.error.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline_rounded,
                            size: 80,
                            color: AppcolorPallets.error,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Oops! Something went wrong",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppcolorPallets.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppcolorPallets.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is ProductLoadedState) {
                  final product = state.product;
                  final images = product.productsImages;
                  final filteredCoupons = state.coupons ?? [];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main Image with favorite button overlay and animation
                        Hero(
                          tag: 'product_$productId',
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutExpo,
                            margin: const EdgeInsets.only(top: 8, bottom: 16),
                            child: Stack(
                              children: [
                                Container(
                                  height: 380,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      AppcolorPallets.cardShadow,
                                      BoxShadow(
                                        color: AppcolorPallets.primaryColor
                                            .withOpacity(0.1),
                                        blurRadius: 40,
                                        offset: const Offset(0, 20),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: images.isNotEmpty
                                        ? PageView.builder(
                                            controller: pageController,
                                            itemCount: images.length,
                                            onPageChanged: (index) {
                                              setState(() {
                                                selectedImageIndex = index;
                                              });
                                            },
                                            itemBuilder: (context, index) =>
                                                _buildMainImage(images[index]),
                                          )
                                        : Image.asset(
                                            "assets/images/dress.png",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                // Favorite button overlay with glassmorphism
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() => isFavorite = !isFavorite);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 10,
                                          sigmaY: 10,
                                        ),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 10,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isFavorite
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            color: isFavorite
                                                ? AppcolorPallets.error
                                                : Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Carousel Dots Indicator
                        if (images.length > 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  images.length,
                                  (i) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    width: selectedImageIndex == i ? 32 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      gradient: selectedImageIndex == i
                                          ? AppcolorPallets.primaryGradient
                                          : null,
                                      color: selectedImageIndex == i
                                          ? null
                                          : AppcolorPallets.thirdColor,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: selectedImageIndex == i
                                          ? [AppcolorPallets.primaryShadow]
                                          : [],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // Thumbnails Row
                        if (images.length > 1)
                          Container(
                            height: 90,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final img = images[index];
                                final isSelected = selectedImageIndex == index;
                                final isNetwork = img.startsWith('http');
                                return GestureDetector(
                                  onTap: () => _onThumbnailTap(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    width: isSelected ? 88 : 80,
                                    height: isSelected ? 88 : 80,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [
                                                AppcolorPallets.primaryColor
                                                    .withOpacity(0.3),
                                                AppcolorPallets.primaryLight
                                                    .withOpacity(0.3),
                                              ],
                                            )
                                          : null,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppcolorPallets.primaryColor
                                            : AppcolorPallets.thirdColor,
                                        width: isSelected ? 3 : 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: isSelected
                                          ? [AppcolorPallets.primaryShadow]
                                          : [AppcolorPallets.softShadow],
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(17),
                                      child: isNetwork
                                          ? FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/images/dress.png',
                                              image: img,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(img, fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        // Glassmorphism Product Info Card
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutExpo,
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.9),
                                    Colors.white.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [AppcolorPallets.cardShadow],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Title
                                  Text(
                                    product.productName,
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppcolorPallets.textPrimary,
                                      letterSpacing: -0.5,
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  // Total Reviews Count
                                  BlocBuilder<ReviewBloc, ReviewState>(
                                    builder: (context, reviewState) {
                                      int reviewCount = 0;
                                      if (reviewState is ReviewSuccessState) {
                                        reviewCount = reviewState.allReviews.length;
                                      }
                                      return Text(
                                        '$reviewCount ${reviewCount == 1 ? 'Review' : 'Reviews'}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppcolorPallets.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  // Rating + Stock
                                  Row(
                                    children: [
                                      BlocBuilder<ReviewBloc, ReviewState>(
                                        builder: (context, reviewState) {
                                          double averageRating = 0.0;
                                          int reviewCount = 0;
                                          
                                          if (reviewState is ReviewSuccessState) {
                                            reviewCount = reviewState.allReviews.length;
                                            if (reviewCount > 0) {
                                              double totalRating = 0;
                                              for (var review in reviewState.allReviews) {
                                                totalRating += review.rating;
                                              }
                                              averageRating = totalRating / reviewCount;
                                            }
                                          }
                                          
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.amber.withOpacity(0.2),
                                                  Colors.orange.withOpacity(0.2),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  size: 20,
                                                  color: Colors.amber.shade700,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  averageRating > 0 
                                                    ? averageRating.toStringAsFixed(1)
                                                    : "0.0",
                                                  style: TextStyle(
                                                    color:
                                                        AppcolorPallets.textPrimary,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  " ($reviewCount)",
                                                  style: TextStyle(
                                                    color: AppcolorPallets
                                                        .textSecondary,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: availableQuantity > 0
                                                ? [
                                                    AppcolorPallets.success
                                                        .withOpacity(0.2),
                                                    AppcolorPallets.success
                                                        .withOpacity(0.1),
                                                  ]
                                                : [
                                                    AppcolorPallets.error
                                                        .withOpacity(0.2),
                                                    AppcolorPallets.error
                                                        .withOpacity(0.1),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: availableQuantity > 0
                                                ? AppcolorPallets.success
                                                    .withOpacity(0.3)
                                                : AppcolorPallets.error
                                                    .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              availableQuantity > 0
                                                  ? Icons.check_circle_rounded
                                                  : Icons.cancel_rounded,
                                              color: availableQuantity > 0
                                                  ? AppcolorPallets.success
                                                  : AppcolorPallets.error,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              availableQuantity > 0
                                                  ? "In Stock"
                                                  : "Out of Stock",
                                              style: TextStyle(
                                                color: availableQuantity > 0
                                                    ? AppcolorPallets.success
                                                    : AppcolorPallets.error,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Price
                                  Builder(
                                    builder: (context) {
                                      double originalPrice =
                                          product.productPrice;
                                      double? discount;
                                      double? discountedPrice;
                                      // Find the best coupon (highest discount)
                                      if (filteredCoupons.isNotEmpty) {
                                        filteredCoupons.sort(
                                          (a, b) => (b.discountPercentage ?? 0)
                                              .compareTo(
                                                a.discountPercentage ?? 0,
                                              ),
                                        );
                                        discount = filteredCoupons
                                            .first
                                            .discountPercentage;
                                        if (discount != null && discount > 0) {
                                          discountedPrice =
                                              originalPrice *
                                              (1 - discount / 100);
                                        }
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              if (discountedPrice != null &&
                                                  discountedPrice <
                                                      originalPrice) ...[
                                                Text(
                                                  '₹${originalPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: AppcolorPallets
                                                        .textLight,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    gradient: AppcolorPallets
                                                        .primaryGradient,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    '${discount!.toInt()}% OFF',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '₹${(discountedPrice ?? originalPrice).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w900,
                                              color:
                                                  AppcolorPallets.primaryColor,
                                              letterSpacing: -0.5,
                                              height: 1.1,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Inclusive of all taxes",
                                            style: TextStyle(
                                              color:
                                                  AppcolorPallets.textSecondary,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Trust Badges
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.8),
                                    Colors.white.withOpacity(0.5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                                boxShadow: [AppcolorPallets.softShadow],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _miniTrustBadge(
                                    Icons.local_shipping_rounded,
                                    "Free Ship",
                                    AppcolorPallets.success,
                                  ),
                                  _miniTrustBadge(
                                    Icons.swap_horiz_rounded,
                                    "Easy Return",
                                    AppcolorPallets.info,
                                  ),
                                  _miniTrustBadge(
                                    Icons.verified_user_rounded,
                                    "Original",
                                    AppcolorPallets.primaryColor,
                                  ),
                                  _miniTrustBadge(
                                    Icons.shield_rounded,
                                    "Secure",
                                    AppcolorPallets.warning,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Add Review Button
                        // TextButton(onPressed: ()=>Get.toNamed('/review',arguments: {
                        //   'product_id' : productId
                        // }), child: Text("add review")),
                        // Sizes Section
                        if (product.sizes.isNotEmpty) ...[
                          const Text(
                            "Select Size",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            children: product.sizes.map<Widget>((size) {
                              return ChoiceChip(
                                label: Text(
                                  size,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                selected: selectedSize == size,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedSize = selected ? size : null;
                                  });
                                },
                                selectedColor: AppcolorPallets.primaryColor
                                    .withOpacity(0.18),
                                backgroundColor: Colors.grey.shade100,
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                        // Divider
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1.1,
                          ),
                        ),
                        // Description
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.productDescription,
                          style: TextStyle(
                            fontSize: 15.5,
                            height: 1.7,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Category Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                AppcolorPallets.primaryColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppcolorPallets.primaryColor.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                              AppcolorPallets.softShadow,
                            ],
                            border: Border.all(
                              color: AppcolorPallets.primaryColor.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppcolorPallets.primaryColor.withOpacity(0.2),
                                      AppcolorPallets.primaryColor.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  color: AppcolorPallets.primaryColor,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Category",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppcolorPallets.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.categoryName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppcolorPallets.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Reviews Section
                        BlocConsumer<ReviewBloc, ReviewState>(
                          listenWhen: (previous, current) {
                            // Only listen when state type changes
                            return previous.runtimeType != current.runtimeType;
                          },
                          listener: (context, state) {
                            // When a review is created, refresh the reviews list
                            if (state is ReviewCreatedState) {
                              _refreshReviews();
                            }
                          },
                          builder: (context, state) {
                            if (state is ReviewLoadingState) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: CircularProgressIndicator(
                                    color: AppcolorPallets.primaryColor,
                                  ),
                                ),
                              );
                            }
                            if (state is ReviewSuccessState) {
                              // Show reviews header with Add Review button
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Reviews",
                                        style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          await Get.toNamed(
                                            '/review',
                                            arguments: {'product_id': productId},
                                          );
                                          // Refresh reviews when returning from review page
                                          _refreshReviews();
                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                        ),
                                        label: const Text(
                                          "Add Review",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppcolorPallets.primaryColor,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Show reviews list if available
                                  if (state.allReviews.isNotEmpty)
                                    Builder(
                                      builder: (context) {
                                        final sortedReviews = List.from(state.allReviews);
                                        sortedReviews.sort((a, b) {
                                          DateTime dateA = a.createdAt ?? DateTime.now();
                                          DateTime dateB = b.createdAt ?? DateTime.now();
                                          return dateB.compareTo(dateA);
                                        });
                                        
                                        final recentReviews = sortedReviews.take(5).toList();
                                        final hasMoreReviews = state.allReviews.length > 5;
                                        
                                        return Column(
                                          children: [
                                            ...recentReviews
                                                .map((r) => ReviewWidget(review: r))
                                                .toList(),
                                            
                                            if (hasMoreReviews)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 16),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      '/all-reviews',
                                                      arguments: {
                                                        'product_id': productId,
                                                        'product_name': 'Product Reviews',
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 14,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppcolorPallets.primaryColor
                                                              .withOpacity(0.1),
                                                          AppcolorPallets.primaryColor
                                                              .withOpacity(0.05),
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(
                                                        color: AppcolorPallets.primaryColor
                                                            .withOpacity(0.3),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Show All Reviews",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: AppcolorPallets.primaryColor,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Icon(
                                                          Icons.arrow_forward_rounded,
                                                          size: 18,
                                                          color:
                                                              AppcolorPallets.primaryColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    )
                                  else
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 32),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.rate_review_outlined,
                                              size: 48,
                                              color: AppcolorPallets.primaryColor.withOpacity(0.3),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              "No reviews yet",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: AppcolorPallets.textSecondary,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "Be the first to review this product",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppcolorPallets.textLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            }
                            if (state is ReviewFailureState) {
                              return const SizedBox();
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
          bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState is! ProductLoadedState) {
                return const SizedBox();
              }

              // Check if product is out of stock
              if (availableQuantity <= 0) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppcolorPallets.error.withOpacity(0.8),
                            AppcolorPallets.error.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.remove_shopping_cart_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Out of Stock",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Quantity Selector
                      Container(
                        decoration: BoxDecoration(
                          color: AppcolorPallets.boxColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppcolorPallets.thirdColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded),
                              onPressed: purchaseQuantity > 1
                                  ? () {
                                      setState(() {
                                        purchaseQuantity--;
                                      });
                                    }
                                  : null,
                              color: AppcolorPallets.primaryColor,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                '$purchaseQuantity',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppcolorPallets.textPrimary,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded),
                              onPressed: purchaseQuantity < availableQuantity
                                  ? () {
                                      setState(() {
                                        purchaseQuantity++;
                                      });
                                    }
                                  : null,
                              color: AppcolorPallets.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Buy Now Button
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppcolorPallets.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [AppcolorPallets.primaryShadow],
                          ),
                          child: ElevatedButton(
                            onPressed: _placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.shopping_bag_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  "Buy Now",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _miniTrustBadge(IconData icon, String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppcolorPallets.textPrimary,
          ),
        ),
      ],
    ),
  );
}

Widget _buildMainImage(String img) {
  final isNetwork = img.startsWith('http');
  return Stack(
    fit: StackFit.expand,
    children: [
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isNetwork
            ? Image.network(
                img,
                key: ValueKey(img),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppcolorPallets.boxColor,
                  child: Icon(
                    Icons.broken_image_rounded,
                    size: 80,
                    color: AppcolorPallets.textLight,
                  ),
                ),
              )
            : Image.asset(img, key: ValueKey(img), fit: BoxFit.cover),
      ),
      // Subtle gradient overlay for depth
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.02),
              Colors.black.withOpacity(0.05),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildShimmerLoading() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 340,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (_) => Container(
                  width: 16,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(height: 28, width: double.infinity, color: Colors.white),
          const SizedBox(height: 16),
          Container(height: 36, width: 180, color: Colors.white),
          const SizedBox(height: 24),
          Container(height: 90, width: double.infinity, color: Colors.white),
          const SizedBox(height: 24),
          Container(height: 140, width: double.infinity, color: Colors.white),
          const SizedBox(height: 80),
        ],
      ),
    ),
  );
}
