/// API endpoint constants for KUIZINE backend
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL — change based on environment
  static const String baseUrl = 'https://api.kuizine.com';
  static const String devBaseUrl = 'http://localhost:3000';

  // ─── Auth ───
  static const String sendOtp = '/api/auth/send-otp';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String updateProfile = '/api/auth/profile';
  static const String refreshToken = '/api/auth/refresh';

  // ─── Products ───
  static const String categories = '/api/categories';
  static const String products = '/api/products';
  static String productDetail(int id) => '/api/products/$id';
  static const String productSearch = '/api/products/search';

  // ─── Orders ───
  static const String orders = '/api/orders';
  static String orderDetail(int id) => '/api/orders/$id';

  // ─── Payments ───
  static const String initiatePayment = '/api/payments/initiate';
  static const String paymentStatus = '/api/payments/status';

  // ─── Delivery ───
  static const String deliveryZones = '/api/delivery-zones';

  // ─── Admin ───
  static const String adminDashboard = '/api/admin/dashboard';
  static const String adminProducts = '/api/admin/products';
  static const String adminOrders = '/api/admin/orders';
}
