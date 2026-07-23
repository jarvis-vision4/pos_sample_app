import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_sample_app/constants/api_constants.dart';
import 'package:pos_sample_app/data/services/api_service.dart';
import 'package:pos_sample_app/data/services/database_service.dart';

GetIt getIt = GetIt.I;
Future<void> setUpLocator() async {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  getIt.registerSingleton<Dio>(dio);
  DatabaseService databaseService=DatabaseService();
  getIt.registerSingleton<DatabaseService>(databaseService);
  ApiService apiService=ApiService();
  getIt.registerSingleton<ApiService>(apiService);
}
