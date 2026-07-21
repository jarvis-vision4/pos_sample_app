import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pos_sample_app/constants/api_constants.dart';

Future<void> setUpLocator() async {
  GetIt getIt = GetIt.I;
  Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  getIt.registerSingleton<Dio>(dio);
}
