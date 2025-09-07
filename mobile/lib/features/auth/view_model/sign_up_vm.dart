import 'package:flutter/material.dart';

class SignUpVM extends ChangeNotifier{
  String email="";
  String phoneNumber="";
  String password="";
  String confirmPassword="";
  String fullName="";

  void onEmailChanged(String value){
    email=value;
    notifyListeners();
  }
  void onPasswordChanged(String value){
    password=value;
    notifyListeners();
  }
  void onConfirmPasswordChanged(String value){
    confirmPassword=value;
    notifyListeners();
  }
  void onFullName(String value){
    fullName=value;
    notifyListeners();
  }
}