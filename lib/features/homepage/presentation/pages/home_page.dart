import 'package:ecommerce_app/core/bloc/auth_status_bloc.dart';
import 'package:ecommerce_app/core/bloc/auth_status_event.dart';
import 'package:ecommerce_app/core/constants/theme/appcolor_pallets.dart';
import 'package:ecommerce_app/core/constants/widgets/app_dialogs.dart';
import 'package:ecommerce_app/core/constants/widgets/app_loading.dart';
import 'package:ecommerce_app/core/constants/widgets/custon_icon_component.dart';
import 'package:ecommerce_app/core/constants/widgets/productcart_widget.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallproductsbycategoryid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getllproducts_usecase.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/category_bloc/category_event.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/category_bloc/category_state.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/product_bloc/product_event.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/product_bloc/product_state.dart';
import 'package:ecommerce_app/features/homepage/presentation/widgets/category_widget.dart';
import 'package:ecommerce_app/features/homepage/presentation/widgets/search_widget.dart';
import 'package:ecommerce_app/features/homepage/presentation/widgets/search_suggestions_widget.dart';
import 'package:ecommerce_app/features/homepage/presentation/widgets/sticky_brand_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late SpeechToText _speechToText;
  bool _isListening = false;

  final int page = 0;
  final int pageSize = 10;

  String keyword = '';
  int? selectedCategoryId; // Track selected category for combined search
  List<Product> searchSuggestions = []; // Store search suggestions separately

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
    
    context.read<CategoryBloc>().add(GetAllCategoriesEvent());
    context.read<ProductBloc>().add(
      ProductGetAllEvent(ProductGetArguments(page, pageSize)),
    );
    _searchController.addListener(_onSearchChanged);
  }

  void _getByCategoryId(int id) {
    setState(() {
      selectedCategoryId = id;
    });

    // Show all products from this category
    context.read<ProductBloc>().add(
      ProductGetAllByCategoryEvent(
        GetAllProductsByCategoryIdArgs(id, page, pageSize),
      ),
    );
  }

  void _showAllProducts() {
    setState(() {
      selectedCategoryId = null;
      keyword = '';
      _searchController.clear();
      searchSuggestions = [];
    });

    context.read<ProductBloc>().add(
      ProductGetAllEvent(ProductGetArguments(page, pageSize)),
    );
  }

  void _onSearchChanged() {
    setState(() {
      keyword = _searchController.text;
    });

    // Use real-time search with debouncing for suggestions only
    if (keyword.isEmpty) {
      setState(() {
        searchSuggestions = [];
      });
    } else {
      // Search for suggestions (will update searchSuggestions list)
      context.read<ProductBloc>().add(ProductRealTimeSearchEvent(keyword));
    }
  }

  Future<void> _startVoiceSearch() async {
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
      return;
    }

    // Request microphone permission
    final status = await permission.Permission.microphone.request();

    if (status.isDenied) {
      // Permission denied
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice search'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      if (mounted) {
        final confirm = await AppDialogs.showConfirmationDialog(
          context: context,
          title: 'Microphone Permission',
          message: 'Microphone permission is permanently denied. Open app settings to enable it?',
          confirmText: 'Open Settings',
          cancelText: 'Cancel',
          icon: Icons.mic_off,
        );
        if (confirm == true) {
          permission.openAppSettings();
        }
      }
      return;
    }

    // Permission granted, start listening
    try {
      bool available = await _speechToText.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          setState(() => _isListening = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $error'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (result) {
            if (mounted) {
              setState(() {
                if (result.recognizedWords.isNotEmpty) {
                  _searchController.text = result.recognizedWords;
                  keyword = result.recognizedWords;
                }
              });
            }

            // Trigger search when speech recognition is finalized
            if (result.finalResult && result.recognizedWords.isNotEmpty) {
              context.read<ProductBloc>().add(
                ProductRealTimeSearchEvent(result.recognizedWords),
              );
              if (mounted) {
                setState(() => _isListening = false);
              }
            }
          },
          localeId: 'en_US',
        );
      } else {
        print('Speech recognition not available');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Speech recognition is not available on this device'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Exception starting voice search: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting voice search: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      setState(() => _isListening = false);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appBar(),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductLoaded && keyword.isNotEmpty) {
            // Update search suggestions without affecting main product grid
            setState(() {
              searchSuggestions = (state.data as List).cast<Product>();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: CustomScrollView(
            slivers: [
              _headerSection(),
              _categorySection(),
              _productTitleSection(),
              _productGridSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SECTIONS ----------------

  SliverToBoxAdapter _headerSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        "Hello",
                        style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Welcome to Laza",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: customIcon(
                    Image.asset("assets/images/logout.png", width: 30),
                    () async {
                      final confirm = await AppDialogs.showConfirmationDialog(
                        context: context,
                        title: 'Logout',
                        message:
                            'Are you sure you want to logout from your account?',
                        confirmText: 'Yes, Logout',
                        cancelText: 'Cancel',
                        icon: Icons.logout_rounded,
                        isDangerous: true,
                      );

                      if (confirm == true) {
                        AppLoading.show(context, message: 'Logging out...');
                        context.read<AuthStatusBloc>().add(LoggedOut());

                        await Future.delayed(const Duration(milliseconds: 500));

                        AppLoading.hide();
                        Get.offAllNamed('/signin');
                      }
                    },
                  ),
                ),
              ],
            ),
            SearchWidget(
              searchController: _searchController,
              onMicClick: _startVoiceSearch,
            ),
            // Search Suggestions (doesn't affect product grid)
            if (keyword.isNotEmpty && searchSuggestions.isNotEmpty)
              SearchSuggestionsWidget(
                products: searchSuggestions,
                onProductSelected: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _searchController.clear();
                    keyword = '';
                    searchSuggestions = [];
                  });
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  SliverPersistentHeader _categorySection() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyBrandHeader(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _categoryHeader(),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    return SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        itemCount: state.categories.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            // ALL option
                            return GestureDetector(
                              onTap: _showAllProducts,
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedCategoryId == null
                                      ? AppcolorPallets.primaryColor
                                      : AppcolorPallets.boxColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'ALL',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: selectedCategoryId == null
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            final category = state.categories[index - 1];
                            return GestureDetector(
                              onTap: () {
                                _getByCategoryId(category.id);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedCategoryId == category.id
                                      ? AppcolorPallets.primaryColor
                                      : AppcolorPallets.boxColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CategoryWidget(categoryModel: category),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                  if (state is CategoryFailure) {
                    return Text(state.message);
                  }
                  // Always show shimmer when not loaded
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: _categoryShimmer(),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryShimmer() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _productTitleSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("New Arrival", style: TextStyle(fontSize: 20)),
            GestureDetector(
              onTap: () {
                Get.toNamed('/all-products');
              },
              child: const Text(
                "View All",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productGridSection() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          final products = state.data as List;
          if (products.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'No products found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.5,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return ProductcartWidget(productModel: products[index]);
              }, childCount: products.length),
            ),
          );
        }

        if (state is ProductFailure) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.failureMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.red[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Always show shimmer when loading
        return _productGridShimmer();
      },
    );
  }

  Widget _productGridShimmer() {
    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
  // ----------------  CATEGORY HEADER ----------------

  Widget _categoryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Choose Brand", style: TextStyle(fontSize: 20)),
          GestureDetector(
            onTap: () async {
              final selectedCategoryId = await Get.toNamed('/all-categories');
              if (selectedCategoryId != null && selectedCategoryId is int) {
                _getByCategoryId(selectedCategoryId);
              }
            },
            child: const Text("View All", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
