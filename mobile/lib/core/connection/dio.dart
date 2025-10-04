import 'package:dio/dio.dart';
import 'package:finder/core/logging/logger.dart';

const baseURL = "http://localhost:3000/";

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseURL,
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  ),
);
void intercept(){
  final intercept = Interceptor();
  //intercept.onResponse(response, handler)
}
