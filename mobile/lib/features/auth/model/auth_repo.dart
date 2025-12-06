import 'package:dio/dio.dart';
import 'package:finder/core/connection/dio.dart';
import 'package:finder/core/connection/token.dart';
import 'package:finder/core/logging/logger.dart';
import 'package:finder/features/auth/model/auth_interceptors.dart';


class AuthRepository {

  TokenManager tokenManager = TokenManager.instance;
  Dio dio = Dio(globalDioOptions);
  Future<Response?> signOut() async {
    try {
      tokenManager.clearTokenPair();
      final tokenPair = await tokenManager.getTokenPair();
      final res = await dio.post("/users/sign-out",options:  Options(headers: {"access_token": tokenPair?.accessToken ?? ""}));
      return res;
    } catch (e) {
      Logger.log("signOut error : $e");
      rethrow;
    }
  }
  Future<Response?> signIn({
    String? email,
    String? phone,
    required String password,
  }) async {
    try {
      assert(email != null || phone != null);
      if ((email == null || email.isEmpty) && (phone == null || phone.isEmpty)) {
        throw Exception('Email or phone is required.');
      }

      final payload = {
        if (email != null && email.isNotEmpty) "email": email,
        if (phone != null && phone.isNotEmpty) "phone_number": phone,
        "password": password,
      };

      final res = await dio.post("/users/sign-in", data: payload);

      Logger.log("response body : ${res.data}");
      Logger.log("response headers : ${res.headers}");

      if (res.statusCode == 200) {
        final accessToken =  res.data["access_token"] ;
        final refreshToken = res.data['refresh_token'];

        if (accessToken != null && refreshToken != null) {
          tokenManager.saveTokenPair(
            (accessToken: accessToken, refreshToken: refreshToken),
          );
        }
        return res;
      } else if (res.statusCode == 401) {
        throw Exception(res.data['message'] ?? 'Unauthorized');
      } else {
        // Throw an exception containing the status code and response body
        throw Exception('signIn failed: status=${res.statusCode}, body=${res.data}');
      }
    } catch (e) {
      Logger.log("signIn error : $e");
      rethrow;
    }
  }

  Future<Response?> uploadImg({required String filePath}) async {
    try {
      final formData = FormData.fromMap({
        "uploaded_image": await MultipartFile.fromFile(filePath),
      });
      final res = await dio.post("/images/profile", data: formData);
      Logger.log("response body : ${res.data}");
      Logger.log("response headers : ${res.headers}");
      if (res.statusCode == 200) {
        return res;
      } else {
        throw Exception('uploadImg failed: status=${res.statusCode}, body=${res.data}');
      }
    } catch (e) {
      Logger.log("uploadImg error : $e");
      rethrow;
    }
  }
  Future<Response?> signUp({
    required String fullName,
    String? email,
    String? phone,
    required String password,
  }) async {
    try{
      assert(email!=null || phone!=null );
      final res = await dio.post("/users/sign-up",data:
      {
        "full_name":fullName,
        if(phone!=null && phone.isNotEmpty)
          "phone_number":phone,
        if(email!=null && email.isNotEmpty)
          "email":email,
        "password":password,
      }
     );
      Logger.log("response body : \\${res.data}");
      Logger.log("response headers : \\${res.headers}");
      if(res.statusCode == 200 || res.statusCode ==201){
        final accessToken =  res.data["access_token"] as String?;
        final refreshToken = res.data['refresh_token'];
        if (accessToken != null && refreshToken != null) {
          tokenManager.saveTokenPair(
              (accessToken: accessToken, refreshToken: refreshToken));
        }else {
          throw Exception('signUp failed: missing access_token or refresh_token in response');
        }
        return res;
      } else {
        throw Exception('signUp failed: status=${res.statusCode}, body=${res.data}');
      }

    } catch(e){
      Logger.log("signUp error :$e ");
      rethrow;
    }

  }

  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> signInWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
