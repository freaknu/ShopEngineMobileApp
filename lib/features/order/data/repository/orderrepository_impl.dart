import 'package:ecommerce_app/features/order/data/datasource/remote/orderremote_datasource.dart';
import 'package:ecommerce_app/features/order/data/model/ordercreate_model.dart';
import 'package:ecommerce_app/features/order/domain/entity/order_create.dart';
import 'package:ecommerce_app/features/order/domain/entity/order_response.dart';
import 'package:ecommerce_app/features/order/domain/repository/order_repository.dart';

class OrderrepositoryImpl implements OrderRepository {
  final OrderremoteDatasource datasource;
  OrderrepositoryImpl(this.datasource);
  @override
  Future<bool> cancelOrder(int orderId) {
    return datasource.cancelOrder(orderId);
  }

  @override
  Future<List<OrderResponse>> getAllOrders() {
    return datasource.getAllOrders();
  }

  @override
  Future<bool> placeOrder(OrderCreate data) {
    return datasource.placeOrder(
      OrdercreateModel(
        productId: data.productId,
        categoryId: data.categoryId,
        purchaseQuantity: data.purchaseQuantity,
        discount: data.discount == 0.0 ? 0.1 : data.discount,
        addressId: data.addressId,
      ),
    );
  }
}
