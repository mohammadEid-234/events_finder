import 'package:finder/features/auth/model/auth_repo.dart';
import 'package:flutter/material.dart';

class HomePageVM extends ChangeNotifier {
  //view model for home page
  AuthRepository authRepository = AuthRepository();

  Future<void> signOut() async {
    //sign out logic
    authRepository.signOut();
  }
}