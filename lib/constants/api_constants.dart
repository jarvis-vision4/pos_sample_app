class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://fakestoreapi.com';
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/products/categories';
  static const String customers = '$baseUrl/users';

  static String productsByCategory(String category) =>
      '$baseUrl/products/category/$category';

  static String productById(int id) => '$baseUrl/products/$id';

  static String customerById(int id) => '$baseUrl/users/$id';
}
