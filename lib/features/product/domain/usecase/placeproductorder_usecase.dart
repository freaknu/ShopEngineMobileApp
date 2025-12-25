import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/product/domain/entity/order_product.dart';
import 'package:ecommerce_app/features/product/domain/entity/order_product_response.dart';
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart';

class PlaceproductorderUsecase
    extends Usecase<OrderProductResponse, PlaceOrderData> {
  final ProductRepository productRepository;
  PlaceproductorderUsecase(this.productRepository);
  @override
  Future<OrderProductResponse> call(PlaceOrderData params) {
    return productRepository.placeOrder(params.orderProduct);
  }
}

class PlaceOrderData {
  final OrderProduct orderProduct;
  PlaceOrderData(this.orderProduct);
}
