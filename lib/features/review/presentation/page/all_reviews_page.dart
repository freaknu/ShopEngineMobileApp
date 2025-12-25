import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/appbar_widget.dart';
import 'package:ecommerce_app/features/product/presentation/widgets/review_widget.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_bloc.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_event.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AllReviewsPage extends StatefulWidget {
  const AllReviewsPage({super.key});

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  late int productId;
  late String productName;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    productId = args['product_id'] as int;
    productName = args['product_name'] as String? ?? 'Product Reviews';
    
    // Fetch reviews for this product
    context.read<ReviewBloc>().add(ReviewGetAllEvent(productId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(productName, context),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoadingState) {
            return _buildShimmerLoading();
          }

          if (state is ReviewSuccessState) {
            if (state.allReviews.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppcolorPallets.primaryColor.withOpacity(0.1),
                              AppcolorPallets.primaryColor.withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.rate_review_outlined,
                          size: 64,
                          color: AppcolorPallets.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No Reviews Yet",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppcolorPallets.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Be the first to share your thoughts about this product",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppcolorPallets.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Sort reviews by created date (newest first)
            final sortedReviews = List.from(state.allReviews);
            sortedReviews.sort((a, b) {
              // createdAt is already a DateTime, no need to parse
              DateTime dateA = a.createdAt ?? DateTime.now();
              DateTime dateB = b.createdAt ?? DateTime.now();
              return dateB.compareTo(dateA); // Newest first
            });

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ReviewBloc>().add(ReviewGetAllEvent(productId));
              },
              color: AppcolorPallets.primaryColor,
              backgroundColor: Colors.white,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: sortedReviews.length,
                separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    color: Colors.grey.shade200,
                    thickness: 1,
                  ),
                ),
                itemBuilder: (context, index) {
                  return ReviewWidget(review: sortedReviews[index]);
                },
              ),
            );
          }

          if (state is ReviewFailureState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.1),
                            Colors.red.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Failed to Load Reviews",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppcolorPallets.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Something went wrong while loading reviews",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppcolorPallets.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<ReviewBloc>().add(ReviewGetAllEvent(productId));
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Try Again"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppcolorPallets.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 10,
                        width: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
