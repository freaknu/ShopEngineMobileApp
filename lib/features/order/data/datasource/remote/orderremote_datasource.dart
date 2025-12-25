import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/order/data/model/ordercreate_model.dart';
import 'package:ecommerce_app/features/order/data/model/orderresponse_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderremoteDatasource {
  final ApiClient _apiClient;
  OrderremoteDatasource(this._apiClient);

  Future<List<OrderresponseModel>> getAllOrders() async {
    try {
      String endpoint = ApiEndpoints().getOrderByUserId;
      final pref = await SharedPreferences.getInstance();
      int? user_id = pref.getInt('user_id');
      final res = await _apiClient.dio.get('$endpoint$user_id');
      List json = res.data;
      List<OrderresponseModel> allOrders = json
          .map((d) => OrderresponseModel.fromJson(d))
          .toList();
      return allOrders;
    } catch (e) {
      debugPrint("error in getting all the orders ${e.toString()}");
      return [];
    }
  }

  Future<bool> placeOrder(OrdercreateModel order) async {
    final pref = await SharedPreferences.getInstance();
    int? user_id = pref.getInt('user_id');
    order.userId = user_id;
    try {
      String endpoint = ApiEndpoints().placeOrderEndpoint;
      final orderJson = order.toJson();

      // Print complete URL and JSON data
      debugPrint("========== PLACE ORDER REQUEST ==========");
      debugPrint("Complete URL: ${_apiClient.dio.options.baseUrl}$endpoint");
      debugPrint("JSON Data: $orderJson");
      debugPrint("=========================================");

      final res = await _apiClient.dio.post(endpoint, data: orderJson);

      debugPrint("========== PLACE ORDER RESPONSE ==========");
      debugPrint("Status Code: ${res.statusCode}");
      debugPrint("Response Data: ${res.data}");
      debugPrint("==========================================");

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("========== PLACE ORDER ERROR ==========");
      debugPrint("Error: ${e.toString()}");
      debugPrint("=======================================");
      return false;
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    try {
      String endpoint = ApiEndpoints().cancelOrder;
      final res = await _apiClient.dio.post('$endpoint$orderId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("error while cancel the order ${e.toString()}");
      return false;
    }
  }
}
