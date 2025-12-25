import 'package:ecommerce_app/features/homepage/presentation/bloc/product_bloc/product_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:ecommerce_app/features/homepage/domain/usecases/getllproducts_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallproductsbycategoryid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getproductbyproductid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/searchproduct_usecase.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/product_bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetllproductsUsecase getAllProducts;
  final GetallproductsbycategoryidUsecase getAllProductsByCategoryId;
  final GetproductbyproductidUsecase getProductByProductId;
  final SearchproductUsecase searchProductUsecase;

  Timer? _searchDebounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  ProductBloc({
    required this.getAllProducts,
    required this.getAllProductsByCategoryId,
    required this.getProductByProductId,
    required this.searchProductUsecase,
  }) : super(ProductInitial()) {
    on<ProductGetAllEvent>(_onGetAllProducts);
    on<ProductGetAllByCategoryEvent>(_onGetAllProductsByCategory);
    on<ProductGetByProductIdEvent>(_onGetProductById);
    on<ProductSearchEvent>(_onSearchProduct);
    on<ProductRealTimeSearchEvent>(_onRealTimeSearchProduct);
  }

  Future<void> _onGetAllProducts(
    ProductGetAllEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading(loadingMessage: 'Loading products...'));
    try {
      final result = await getAllProducts(event.args);
      print("the res ar bloc $result");
      emit(
        ProductLoaded(
          data: result,
          successMessage: 'Products loaded successfully',
        ),
      );
    } catch (e) {
      emit(ProductFailure(failureMessage: e.toString()));
    }
  }

  Future<void> _onGetAllProductsByCategory(
    ProductGetAllByCategoryEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading(loadingMessage: 'Loading category products...'));
    try {
      final result = await getAllProductsByCategoryId(event.args);
      emit(
        ProductLoaded(data: result, successMessage: 'Category products loaded'),
      );
    } catch (e) {
      emit(ProductFailure(failureMessage: e.toString()));
    }
  }

  Future<void> _onGetProductById(
    ProductGetByProductIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading(loadingMessage: 'Loading product...'));
    try {
      final result = await getProductByProductId(event.id);
      emit(ProductLoaded(data: result, successMessage: 'Product loaded'));
    } catch (e) {
      emit(ProductFailure(failureMessage: e.toString()));
    }
  }

  Future<void> _onSearchProduct(
    ProductSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading(loadingMessage: 'Searching products...'));
    try {
      final result = await searchProductUsecase(event.keyword);
      emit(ProductLoaded(data: result, successMessage: 'Search completed'));
    } catch (e) {
      emit(ProductFailure(failureMessage: e.toString()));
    }
  }

  /// Real-time search with debouncing to prevent excessive API calls while typing
  Future<void> _onRealTimeSearchProduct(
    ProductRealTimeSearchEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Cancel previous debounce timer
    _searchDebounceTimer?.cancel();

    // If search is empty, reload all products
    if (event.keyword.isEmpty) {
      try {
        final result = await getAllProducts(ProductGetArguments(0, 10));
        emit(
          ProductLoaded(
            data: result,
            successMessage: 'Products loaded successfully',
          ),
        );
      } catch (e) {
        emit(ProductFailure(failureMessage: e.toString()));
      }
      return;
    }

    // Use Completer to handle debounced search properly
    final completer = Completer<void>();
    
    // Start debounce timer - only search after user stops typing for 500ms
    _searchDebounceTimer = Timer(_debounceDuration, () async {
      if (!emit.isDone) {
        try {
          final result = await searchProductUsecase(event.keyword);
          if (!emit.isDone) {
            emit(ProductLoaded(data: result, successMessage: 'Search results found'));
          }
        } catch (e) {
          if (!emit.isDone) {
            emit(ProductFailure(failureMessage: e.toString()));
          }
        }
      }
      completer.complete();
    });

    // Wait for the debounced search to complete
    await completer.future;
  }

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    return super.close();
  }
}
