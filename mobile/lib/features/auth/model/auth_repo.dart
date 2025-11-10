import 'package:dio/dio.dart';
import 'package:finder/core/connection/dio.dart';
import 'package:finder/core/connection/token.dart';
import 'package:finder/core/logging/logger.dart';


class AuthRepository {
  TokenManager tokenManager = TokenManager.instance;
  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }
    // TODO: real auth call
  }

  Future<Response?> signUp({
    required String fullName,
    String? email,
    String? phone,
    required String password,
  }) async {
    try{
      assert(email!=null || phone!=null );
      final res = await dio.post("/users",data:
      {
        "full_name":fullName,
        if(phone!=null && phone.isNotEmpty)
          "phone_number":phone,
        if(email!=null && email.isNotEmpty)
          "email":email,
        "password":password,
      }
     );
      Logger.log("response body : ${res.data}");
      Logger.log("response headers : ${res.headers}");
      if(res.statusCode == 200){
        final accessToken =  res.data["access_token"] as String;
        final refreshToken = res.headers.map["refresh_token"] as String;
        tokenManager.saveTokenPair(
            (accessToken: accessToken, refreshToken: refreshToken));
      }
      return res;

    } catch(e){
      Logger.log("signUp error :$e ");
      return null;
    }

  }

  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> signInWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
