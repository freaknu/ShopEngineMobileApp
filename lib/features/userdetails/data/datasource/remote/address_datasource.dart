import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/userdetails/data/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressDatasource {
  final ApiClient _apiClient;
  AddressDatasource(this._apiClient);
  Future<List<AddressModel>> getAllAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt('user_id');
      if (userId == null) return [];

      final String endpoint = ApiEndpoints().getAlladdress;
      final res = await _apiClient.dio.get('$endpoint$userId');

      if (res.statusCode == 200 || res.statusCode == 201) {
        final responseData = res.data;

        // Case 1: API returns List directly
        if (responseData is List) {
          return responseData
              .map((json) => AddressModel.fromJson(json))
              .toList();
        }

        // Case 2: API returns { data: [...] }
        if (responseData is Map<String, dynamic> &&
            responseData['data'] is List) {
          return (responseData['data'] as List)
              .map((json) => AddressModel.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      // Log error properly in debug mode
      debugPrint('getAllAddress error: $e');
      return [];
    }
  }

  Future<bool> createAddress(AddressModel address) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      address.userId = userId ?? -1;

      String endpoint = ApiEndpoints().createAddress;
      final res = await _apiClient.dio.post(endpoint, data: address.toJson());
      print("the response for create address is $res");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatedAddress(AddressModel address) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      address.userId = userId ?? -1;

      String endpoint = ApiEndpoints().updateAddress;
      final res = await _apiClient.dio.post(endpoint, data: address.toJson());
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAddress(int addressId) async {
    try {
      String endpoint = ApiEndpoints().deleteAddress;
      final res = await _apiClient.dio.delete('$endpoint$addressId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
