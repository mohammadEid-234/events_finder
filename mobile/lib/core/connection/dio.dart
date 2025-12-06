import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finder/features/auth/model/auth_interceptors.dart';
import 'package:flutter/foundation.dart';

//change baseURL to localhost for testing on emulator
String get baseURL {
  if (kIsWeb) return 'http://localhost:3000/';
  try {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000/'; // Android emulator
    if (Platform.isIOS) return 'http://localhost:3000/';   // iOS simulator
  } catch (_) {}
  return 'http://127.0.0.1:3000/'; // fallback
}
final globalDioOptions = BaseOptions(
  baseUrl: baseURL,
  validateStatus: (status)=> true,
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
);

