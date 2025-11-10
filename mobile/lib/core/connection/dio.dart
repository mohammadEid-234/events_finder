import 'package:dio/dio.dart';
import 'package:finder/core/logging/logger.dart';
import 'package:finder/features/auth/model/auth_interceptors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseURL = "http://192.168.1.12:3000/";

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseURL,
    validateStatus: (status)=> true,
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ),
);

void initDio(){
  dio.interceptors.add(AuthInterceptor(dio: dio));


}
