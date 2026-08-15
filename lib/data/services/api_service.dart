import 'package:dio/dio.dart';
import '../../locator/locator.dart';
import '../models/customer.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio = getIt.get<Dio>();

  Future<List<Product>> getAllProducts() async {
    final response = await _dio.get('/products');
    final data = response.data as List<dynamic>;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<String>> getCategories() async {
    final response = await _dio.get('/products/categories');
    final data = response.data as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _dio.get('/products/category/$category');
    final data = response.data as List<dynamic>;
    return data.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Customer>> getAllCustomers() async {
    final response = await _dio.get('/users');
    final data = response.data as List<dynamic>;
    return data.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
  }
}
