import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/homepage/data/model/category_model.dart';

class CategoryApiService {
  final ApiClient _apiClient;
  CategoryApiService(this._apiClient);

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final endpoint = ApiEndpoints().getAllCategories;
      final res = await _apiClient.dio.get(endpoint);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final List data = res.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
