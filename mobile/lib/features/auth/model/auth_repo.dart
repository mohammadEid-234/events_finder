import 'package:dio/dio.dart';
import 'package:finder/core/connection/connection.dart';
import 'package:finder/core/connection/dio.dart';
import 'package:finder/core/logging/logger.dart';

class AuthRepository {
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
    required String confirmPassword,

  }) async {
    try{
      assert(email!=null || phone!=null );
      final res = await dio.post("/users",data: {
        "full_name":fullName,
        if(phone!=null)
          "phone_number":phone,
        if(email!=null)
          "email":email,
        "password":password,
        "confirm_password":confirmPassword
      });

      return res;

    } catch(e){
      Logger.log("");
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
