import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/product/data/model/cartproduct_model.dart';
import 'package:ecommerce_app/features/product/data/model/discount_model.dart';
import 'package:ecommerce_app/features/product/data/model/inventory_model.dart';
import 'package:ecommerce_app/features/product/data/model/orderproduct_model.dart';
import 'package:ecommerce_app/features/product/data/model/orderproductresponse_model.dart';
import 'package:ecommerce_app/features/product/data/model/product_model.dart';
import 'package:ecommerce_app/features/product/domain/entity/discount.dart';
import 'package:ecommerce_app/features/product/domain/entity/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductApiService {
  final ApiClient _apiClient;

  ProductApiService(this._apiClient);

  Future<Product> getProductByProductId(int id) async {
    try {
      String endpoint = ApiEndpoints().getByProductId;
      final res = await _apiClient.dio.get('$endpoint/$id');
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("the response for product is $res");
        return ProductModel.fromJson(res.data);
      }

      return Product(
        id: -1,
        productName: "",
        productDescription: "",
        productPrice: -1,
        productsImages: [],
        categoryName: "",
        categoryId: -1,
        sizes: [],
      );
    } catch (e) {
      return Product(
        id: -1,
        productName: "",
        productDescription: "",
        productPrice: -1,
        productsImages: [],
        categoryName: "",
        categoryId: -1,
        sizes: [],
      );
    }
  }

  Future<InventoryModel> getInventoryByProductId(int productId) async {
    try {
      String endpoint = ApiEndpoints().getProductInventory;
      final res = await _apiClient.dio.get('$endpoint$productId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("the response for inventory is $res");
        return InventoryModel.fromJson(res.data);
      }

      return InventoryModel(
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        DateTime.now(),
        DateTime.now(),
      );
    } catch (e) {
      return InventoryModel(
        -1,
        -1,
        -1,
        -1,
        -1,
        -1,
        DateTime.now(),
        DateTime.now(),
      );
    }
  }

  Future<CartproductModel?> addToCart(CartproductModel cart) async {
    try {
      String endpoint = ApiEndpoints().createCart;
      final pref = await SharedPreferences.getInstance();
      int? userId = pref.getInt('user_id');

      final res = await _apiClient.dio.post('$endpoint$userId', data: cart);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("product added to cart $res");
        return CartproductModel.fromJson(res.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<OrderproductresponseModel?> orderProduct(
    OrderproductModel orderproduct,
  ) async {
    try {
      final pref = await SharedPreferences.getInstance();
      int? userId = pref.getInt('user_id');
      orderproduct.userId = userId!;
      String endpoint = ApiEndpoints().placeOrderEndpoint;
      final res = await _apiClient.dio.post(
        endpoint,
        data: orderproduct.toJson(),
      );
      print("the order request is ${orderproduct.toJson()}");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return OrderproductresponseModel.fromJson(res.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Discount>> getAllDiscounts(int productId) async {
    try {
      String endpoint = ApiEndpoints().getDiscountByProductId;
      final res = await _apiClient.dio.get('$endpoint$productId');
      print("the response for discount is $res");
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = res.data;
        if (data is List) {
          return data.map((e) => DiscountModel.fromJson(e)).toList();
        } else if (data is Map<String, dynamic>) {
          return [DiscountModel.fromJson(data)];
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
