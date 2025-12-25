import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/homepage/data/model/product_model.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallproductsbycategoryid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getllproducts_usecase.dart';
import 'package:flutter/widgets.dart';

class ProductApiService {
  final ApiClient _apiClient;
  ProductApiService(this._apiClient);

  Future<List<ProductModel>> getAllProducts(ProductGetArguments args) async {
    try {
      final endpoint = ApiEndpoints().getAllProducts;

      final res = await _apiClient.dio.get(
        '$endpoint?page=${args.page}&size=${args.pageSize}',
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final List<dynamic> data = res.data as List<dynamic>;

        final products = data
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return products;
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> getAllProductsByCategoryId(
    GetAllProductsByCategoryIdArgs args,
  ) async {
    try {
      final endpoint = ApiEndpoints().getAllProductsByCategoryId;
      final res = await _apiClient.dio.get(
        '$endpoint/${args.categoryId}?page=${args.page}&size=${args.pageSize}',
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final List data = res.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<ProductModel> getByProductId(int id) async {
    try {
      String endpoint = ApiEndpoints().getByProductId;
      final res = await _apiClient.dio.get('$endpoint$id');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ProductModel.fromJson(res.data);
      }

      return ProductModel(
        id: -1,
        productName: "",
        productDescription: "",
        productPrice: -1,
        productsImages: [],
        categoryName: "",
        categoryId: -1,
      );
    } catch (e) {
      return ProductModel(
        id: -1,
        productName: "",
        productDescription: "",
        productPrice: -1,
        productsImages: [],
        categoryName: "",
        categoryId: -1,
      );
    }
  }

  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      String endpoint = ApiEndpoints().searchProduct;
      final res = await _apiClient.dio.get('$endpoint$keyword');
      // debugPrint("the respomse of search is $res");
      if (res.statusCode == 200 || res.statusCode == 201) {
        final List data = res.data;
        // debugPrint("the response of search is $data");
        final resp = data.map((d) => ProductModel.fromJson(d)).toList();
        debugPrint("the response of search is $data");
        return resp;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
