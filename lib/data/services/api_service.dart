import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../constants/api_constants.dart';
import '../models/product.dart';


class ApiService {
  final Dio _dio=GetIt.I.get<Dio>();
  Future<List<Product>> getAllProducts() async {
    try {
      print("Fetching products from API...");
      final response = await _dio.get('/products');
      print(response.data);
      final List<dynamic> data = response.data;
      return data.map((product) => Product.fromJson(product)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      print(response.data);
      final List<dynamic> data = response.data;
      return data.map((e) => e.toString()).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products by category: $e');
    }
  }
}
