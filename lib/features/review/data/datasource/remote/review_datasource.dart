import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/review/data/model/review_model.dart';
import 'package:ecommerce_app/features/review/domain/entity/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewDatasource {
  final ApiClient _apiClient;
  ReviewDatasource(this._apiClient);

  Future<List<Review>> getAllReviews(int productId) async {
    try {
      String endpoint = ApiEndpoints().getReviews;
      print('[ReviewDatasource] Fetching reviews for productId: $productId, endpoint: $endpoint');
      final res = await _apiClient.dio.get('$endpoint$productId');
      print('[ReviewDatasource] Response status: \\${res.statusCode}, data: \\${res.data}');
      if (res.statusCode == 200 || res.statusCode == 201) {
        final List json = res.data;
        List<Review> allDatas = json
            .map((d) => ReviewModel.fromJson(d))
            .toList();
        print('[ReviewDatasource] Parsed reviews: $allDatas');
        return allDatas;
      }
      print('[ReviewDatasource] Non-200/201 response');
      return [];
    } catch (e) {
      print('[ReviewDatasource] Error in getAllReviews: $e');
      return [];
    }
  }

  Future<bool> addReview(int productId, ReviewModel data) async {
    try {
      print("[ReviewDatasource] under add review datasource");
      String endpoint = ApiEndpoints().createReviews;
      print('[ReviewDatasource] Posting review to: $endpoint$productId, data: ${data.toJson()}');
      final res = await _apiClient.dio.post(
        '$endpoint$productId',
        data: data.toJson(),
      );

      print("[ReviewDatasource] the response for adding the review is $res");

      if (res.statusCode == 200 || res.statusCode == 201) {
        print('[ReviewDatasource] Review added successfully');
        return true;
      }
      print('[ReviewDatasource] Failed to add review, status: \\${res.statusCode}');
      return false;
    } catch (e) {
      print('[ReviewDatasource] Error in addReview: $e');
      return false;
    }
  }
}
