import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_sample_app/constants/api_constants.dart';
import 'package:pos_sample_app/data/services/api_service.dart';
import 'package:pos_sample_app/data/services/database_service.dart';

GetIt getIt = GetIt.I;

Future<void> setUpLocator() async {
  getIt.registerSingleton<Dio>(
    Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    ),
  );
  getIt.registerSingleton<DatabaseService>(DatabaseService());
  getIt.registerSingleton<ApiService>(ApiService());
}
