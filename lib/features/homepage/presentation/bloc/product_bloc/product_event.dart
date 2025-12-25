import 'package:ecommerce_app/features/homepage/domain/usecases/getallproductsbycategoryid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getllproducts_usecase.dart';

abstract class ProductEvent {}

class ProductGetAllEvent extends ProductEvent {
  final ProductGetArguments args;
  ProductGetAllEvent(this.args);
}

class ProductGetAllByCategoryEvent extends ProductEvent {
  final GetAllProductsByCategoryIdArgs args;
  ProductGetAllByCategoryEvent(this.args);
}

class ProductGetByProductIdEvent extends ProductEvent {
  final int id;
  ProductGetByProductIdEvent(this.id);
}

class ProductSearchEvent extends ProductEvent {
  final String keyword;
  ProductSearchEvent(this.keyword);
}

class ProductRealTimeSearchEvent extends ProductEvent {
  final String keyword;
  ProductRealTimeSearchEvent(this.keyword);
}
