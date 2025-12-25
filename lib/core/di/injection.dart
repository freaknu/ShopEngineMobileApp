import 'package:ecommerce_app/features/cart/data/datasource/remote/cart_datasource.dart';
import 'package:ecommerce_app/features/cart/data/repository/cartrepository_impl.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repository.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/deletecart_usecase.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/getallcarts_usecase.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/homepage/data/datasource/remote/category_api_service.dart';
import 'package:ecommerce_app/features/homepage/data/datasource/remote/product_api_service.dart';
import 'package:ecommerce_app/features/homepage/data/repository/category_repository_impl.dart';
import 'package:ecommerce_app/features/homepage/data/repository/product_repository_impl.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/category_repository.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/product_repository.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallcategories_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallproductsbycategoryid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getllproducts_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getproductbyproductid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/searchproduct_usecase.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce_app/features/notification/data/datasource/notification_datasource.dart';
import 'package:ecommerce_app/features/notification/data/repository/notification_repository_impl.dart';
import 'package:ecommerce_app/features/notification/domain/repository/notification_repository.dart';
import 'package:ecommerce_app/features/notification/domain/usecase/get_all_notifications_usecase.dart';
import 'package:ecommerce_app/features/notification/domain/usecase/mark_notification_as_read_usecase.dart';
import 'package:ecommerce_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:ecommerce_app/features/order/data/datasource/remote/orderremote_datasource.dart';
import 'package:ecommerce_app/features/order/data/repository/orderrepository_impl.dart';
import 'package:ecommerce_app/features/order/domain/repository/order_repository.dart';
import 'package:ecommerce_app/features/order/domain/usecase/cancelorder_usecase.dart';
import 'package:ecommerce_app/features/order/domain/usecase/getallorders_usecase.dart';
import 'package:ecommerce_app/features/order/domain/usecase/orderplace_usecase.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:ecommerce_app/features/product/data/datasource/remote/product_api_service.dart'
    hide ProductApiService;
import 'package:ecommerce_app/features/product/data/datasource/remote/product_api_service.dart'
    as pd;
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart'
    hide ProductRepository;
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart'
    as pd
    show ProductRepository;
import 'package:ecommerce_app/features/product/domain/usecase/addtocart_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/getallcouponsbyproductid_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/getproductbyid_usecase.dart';
import 'package:ecommerce_app/features/product/domain/usecase/placeproductorder_usecase.dart';
import 'package:ecommerce_app/features/product/presentation/bloc/product_bloc.dart'
    as pd
    show ProductBloc;
import 'package:ecommerce_app/features/review/data/datasource/remote/review_datasource.dart';
import 'package:ecommerce_app/features/review/data/repository/reviewrepository_impl.dart';
import 'package:ecommerce_app/features/review/domain/repository/review_repository.dart';
import 'package:ecommerce_app/features/review/domain/usecases/createreview_usecase.dart';
import 'package:ecommerce_app/features/review/domain/usecases/getallreviews_usecase.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_bloc.dart';
import 'package:ecommerce_app/features/userdetails/data/datasource/remote/address_datasource.dart';
import 'package:ecommerce_app/features/userdetails/data/repository/addressrepository_impl.dart';
import 'package:ecommerce_app/features/userdetails/domain/repository/address_repository.dart';
import 'package:ecommerce_app/features/userdetails/domain/usecases/createaddress_usecase.dart';
import 'package:ecommerce_app/features/userdetails/domain/usecases/deleteaddress_usecase.dart';
import 'package:ecommerce_app/features/userdetails/domain/usecases/getalladdress_usecase.dart';
import 'package:ecommerce_app/features/userdetails/domain/usecases/updateaddress_usecase.dart';
import 'package:ecommerce_app/features/userdetails/presentation/bloc/address_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:ecommerce_app/features/auth/data/datasource/remote/auth_api_service.dart';
import 'package:ecommerce_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:ecommerce_app/features/auth/domain/repository/auth_repository.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/login_account_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/create_account_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/send_verification_code_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:ecommerce_app/core/bloc/auth_status_bloc.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/product/data/repository/product_repository_impl.dart'
    as pd;
import '../../features/product/domain/usecase/getinventorybyid_usecase.dart'
    as pd;

final getIt = GetIt.instance;

void setupDI() {
  // ---------------- CORE ----------------
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // ---------------- LOCAL STORAGE ----------------
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => const AuthLocalDataSource(),
  );

  // ---------------- API SERVICES ----------------
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(getIt<ApiClient>()),
  );

  // ---------------- REPOSITORY ----------------
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthApiService>()),
  );

  // ---------------- USE CASES ----------------
  getIt.registerLazySingleton(
    () => LoginAccountUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => CreateAccountUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => ChangePasswordUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(
    () => SendVerificationCodeUsecase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton(() => VerifyOtpUsecase(getIt<AuthRepository>()));

  // ---------------- AUTH STATUS BLOC (GLOBAL) ----------------
  getIt.registerLazySingleton<AuthStatusBloc>(
    () => AuthStatusBloc(getIt<AuthLocalDataSource>()),
  );

  // ---------------- AUTH BLOC ----------------
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      getIt<AuthLocalDataSource>(),
      getIt<AuthStatusBloc>(),
      loginAccountUsecase: getIt(),
      createAccountUsecase: getIt(),
      changePasswordUsecase: getIt(),
      sendVerificationCodeUsecase: getIt(),
      verifyOtpUsecase: getIt(),
    ),
  );

  /// Data sources
  getIt.registerLazySingleton<CategoryApiService>(
    () => CategoryApiService(getIt()),
  );

  getIt.registerLazySingleton<ProductApiService>(
    () => ProductApiService(getIt()),
  );

  /// Repositories
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt()),
  );

  /// Use cases
  getIt.registerLazySingleton(() => GetallcategoriesUsecase(getIt()));
  getIt.registerLazySingleton(() => GetllproductsUsecase(getIt()));
  getIt.registerLazySingleton(() => GetallproductsbycategoryidUsecase(getIt()));
  getIt.registerLazySingleton(() => GetproductbyproductidUsecase(getIt()));
  getIt.registerLazySingleton(() => SearchproductUsecase(getIt()));

  /// Blocs
  getIt.registerFactory(() => CategoryBloc(getAllCategories: getIt()));
  getIt.registerFactory(
    () => ProductBloc(
      getAllProducts: getIt(),
      getAllProductsByCategoryId: getIt(),
      getProductByProductId: getIt(),
      searchProductUsecase: getIt(),
    ),
  );

  /// 🔹 Data Sources
  getIt.registerLazySingleton<pd.ProductApiService>(
    () => pd.ProductApiService(getIt()),
  );

  /// 🔹 Repository
  getIt.registerLazySingleton<pd.ProductRepository>(
    () => pd.ProductRepositoryImpl(getIt()),
  );

  /// 🔹 UseCases
  getIt.registerLazySingleton(() => GetproductbyidUsecase(getIt()));

  getIt.registerLazySingleton(() => pd.GetinventorybyidUsecase(getIt()));

  getIt.registerLazySingleton(() => AddtocartUsecase(getIt()));

  getIt.registerLazySingleton(() => PlaceproductorderUsecase(getIt()));

  getIt.registerLazySingleton(() => GetallcouponsbyproductidUsecase(getIt()));

  /// 🔹 Bloc
  getIt.registerFactory(
    () => pd.ProductBloc(
      getProductByIdUsecase: getIt(),
      getInventoryByIdUsecase: getIt(),
      addtocartUsecase: getIt(),
      placeproductorderUsecase: getIt(),
      getAllCouponsByProductIdUsecase: getIt(),
    ),
  );

  /// ---------------- DATASOURCE ----------------
  getIt.registerLazySingleton<CartDatasource>(
    () => CartDatasource(getIt<ApiClient>()),
  );

  /// ---------------- REPOSITORY ----------------
  getIt.registerLazySingleton<CartRepository>(
    () => CartrepositoryImpl(getIt<CartDatasource>()),
  );

  /// ---------------- USECASES ----------------
  getIt.registerLazySingleton<GetallcartsUsecase>(
    () => GetallcartsUsecase(getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<DeletecartUsecase>(
    () => DeletecartUsecase(getIt<CartRepository>()),
  );

  getIt.registerFactory(
    () => CartBloc(getallcartsUsecase: getIt(), deletecartUsecase: getIt()),
  );

  /// ---------------- ADDRESS DATASOURCE ----------------
  getIt.registerLazySingleton<AddressDatasource>(
    () => AddressDatasource(getIt<ApiClient>()),
  );

  /// ---------------- ADDRESS REPOSITORY ----------------
  getIt.registerLazySingleton<AddressRepository>(
    () => AddressrepositoryImpl(getIt<AddressDatasource>()),
  );

  /// ---------------- ADDRESS USECASES ----------------
  getIt.registerLazySingleton<CreateaddressUsecase>(
    () => CreateaddressUsecase(getIt<AddressRepository>()),
  );

  getIt.registerLazySingleton<DeleteaddressUsecase>(
    () => DeleteaddressUsecase(getIt<AddressRepository>()),
  );

  getIt.registerLazySingleton<GetalladdressUsecase>(
    () => GetalladdressUsecase(getIt<AddressRepository>()),
  );

  getIt.registerLazySingleton<UpdateaddressUsecase>(
    () => UpdateaddressUsecase(getIt<AddressRepository>()),
  );

  /// ---------------- ADDRESS BLOC ----------------
  getIt.registerFactory<AddressBloc>(
    () => AddressBloc(
      createaddressUsecase: getIt<CreateaddressUsecase>(),
      deleteaddressUsecase: getIt<DeleteaddressUsecase>(),
      getalladdressUsecase: getIt<GetalladdressUsecase>(),
      updateaddressUsecase: getIt<UpdateaddressUsecase>(),
    ),
  );

  getIt.registerLazySingleton<ReviewDatasource>(
    () => ReviewDatasource(getIt()),
  );

  // ---------------- REPOSITORY ----------------
  getIt.registerLazySingleton<ReviewRepository>(
    () => ReviewrepositoryImpl(getIt()),
  );

  // ---------------- USECASES ----------------
  getIt.registerLazySingleton<GetallreviewsUsecase>(
    () => GetallreviewsUsecase(getIt()),
  );

  getIt.registerLazySingleton<CreatereviewUsecase>(
    () => CreatereviewUsecase(getIt()),
  );

  // ---------------- BLOC ----------------
  getIt.registerFactory<ReviewBloc>(
    () =>
        ReviewBloc(getallreviewsUsecase: getIt(), createreviewUsecase: getIt()),
  );

  getIt.registerLazySingleton<OrderremoteDatasource>(
    () => OrderremoteDatasource(getIt()),
  );

  /// -----------------------------
  /// Repository
  /// -----------------------------
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderrepositoryImpl(getIt()),
  );

  /// -----------------------------
  /// UseCases
  /// -----------------------------
  getIt.registerLazySingleton(() => GetallordersUsecase(getIt()));
  getIt.registerLazySingleton(() => CancelorderUsecase(getIt()));
  getIt.registerLazySingleton(() => OrderplaceUsecase(getIt()));

  /// -----------------------------
  /// Bloc
  /// -----------------------------
  getIt.registerFactory(() => OrderBloc(getIt(), getIt(), getIt()));

  // =============================
  // Notification Feature
  // =============================
  /// -----------------------------
  /// Data Sources
  /// -----------------------------
  getIt.registerLazySingleton<NotificationDatasource>(
    () => NotificationDatasource(),
  );

  /// -----------------------------
  /// Repository
  /// -----------------------------
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt()),
  );

  /// -----------------------------
  /// UseCases
  /// -----------------------------
  getIt.registerLazySingleton(() => GetAllNotificationsUsecase(getIt()));

  /// -----------------------------
  /// Bloc
  /// -----------------------------
  getIt.registerFactory(
    () => NotificationBloc(
      getAllNotificationsUsecase: getIt(),
    ),
  );
}
