class ApiEndpoints {
  // authentication endpoints ->

  final String login = "api/auth/login";
  final String createAccount = "api/auth/create-user";
  final String verifyOtp = "api/auth/verifyOtp/";
  final String sendVerifyOtp = "api/auth/sendVerificationCode/";
  final String changePassword =
      "api/auth/changePassword/";
  final String refreshToken = "api/auth/getByRefreshToken/{token}";

  //product endpoinst ->
  final String getAllProducts = "api/product/getallProducts";
  final String getAllProductsByCategoryId =
      "api/product/getallProductsByCategory/";
  final String getByProductId = "api/product/getProductById/";
  final String searchProduct = "api/product/searchByKeyword/";

  //category endpoints ->
  final String getAllCategories = "api/product/getallCategory";

  //discount endpoint ->
  final String getDiscountByProductId = 'api/product/findByProductId/';

  //cart endpoint ->
  final String getCartByuserId = 'api/order/getCartByUserId/';
  final String deleteFromCart = 'api/order/deleteFromCart/';
  final String createCart = '/api/order/createCart/';

  //order endpoint ->
  final String placeOrderEndpoint = 'api/order/placeOrder';
  final String cancelOrder = 'api/order/cancelOrder/';
  final String getOrderByUserId = 'api/order/getAllOrders/';

  //address endpoint ->
  final String createAddress = 'api/order/createAddress';
  final String updateAddress = 'api/order/updateAddress';
  final String getAlladdress = 'api/order/getAll/';
  final String deleteAddress = 'api/order/deleteAddress/';

  //inventory endpoint ->
  final String getProductInventory = 'api/inventory/getByProductId/';

  //getreview ->
  final String getReviews = 'api/product/getAllReviews/';
  final String createReviews ='api/product/createReview/';

  //notifications - >
  final String getAllNotifications = 'api/notification/getAllNotifications/';
}
