import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/cart/data/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDatasource {
  final ApiClient _apiClient;
  CartDatasource(this._apiClient);

  Future<CartModel?> getAllCarts() async {
    try {
      print("under the get all carts");
      String endpoint = ApiEndpoints().getCartByuserId;
      final pref = await SharedPreferences.getInstance();
      int? userId = pref.getInt('user_id');
      final res = await _apiClient.dio.get('$endpoint$userId');
      print("the carts are $res");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return CartModel.fromJson(res.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteFromCart(int productId) async {
    try {
      final pref = await SharedPreferences.getInstance();
      int? userId = pref.getInt('user_id');
      String endpoint = ApiEndpoints().deleteFromCart;
      final res = await _apiClient.dio.post('$endpoint$userId/$productId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
