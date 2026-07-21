import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../constants/api_constants.dart';


class ApiService {
  final Dio _dio=GetIt.I.get<Dio>();
}
