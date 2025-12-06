import 'dart:convert';

import 'package:finder/core/logging/logger.dart';
import 'package:finder/features/auth/model/auth_repo.dart';
import 'package:finder/features/auth/model/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
enum SignUpMethod{
  email,phone
}
class SignUpVM extends ChangeNotifier{

  String email="";
  String phoneNumber="";
  String password="";
  String confirmPassword="";
  String fullName="";
  String countryCode="";
  bool loadingCountries=true;
  late CountryCode selectedCountryCode ;
  List<CountryCode> countryCodes = [];
  SignUpMethod selectedSignupMethod = SignUpMethod.email;
  AuthRepository authRepository = AuthRepository();




  void setSignupMethod(SignUpMethod method){
    selectedSignupMethod=method;
    notifyListeners();
  }
  void readCountryCodes()async{
    try{
      final fileRead = jsonDecode(await rootBundle.loadString("assets/data/calling_codes.json"));
      Logger.log("fileRead result : ${fileRead}");
      countryCodes = fileRead.map<CountryCode>((json)=> CountryCode.fromJson(json)).toList();
      selectedCountryCode = countryCodes.firstWhere((countryCode)=> countryCode.iso2.name == "PS");
    }catch(e){
      Logger.log(e);
    }


  }

  bool submittingForm=false,signUpSuccess=false;
  void setSignUpSuccess(bool value){
    signUpSuccess=value;
    notifyListeners();
  }
  void setSubmitting(bool value){
    submittingForm=value;
    notifyListeners();
  }
  Future<void> submitForm()async{
    try{
      setSubmitting(true);
      String? fullPhoneNumber;
      if(phoneNumber.isNotEmpty){
        fullPhoneNumber = PhoneNumber.parse(phoneNumber,callerCountry: selectedCountryCode.iso2).international;
      }
       await authRepository.signUp(fullName: fullName, password: password,
          phone: fullPhoneNumber,email: email
      );
       //if no exception is thrown consider it success
      setSignUpSuccess(true);
      setSubmitting(false);


    }catch(e){
      debugPrint("Error submitting form: $e");
      setSignUpSuccess(false);
      setSubmitting(false);
    }


  }
  void onEmailChanged(String value){
    email=value;
    notifyListeners();
  }

  void setSelectedCountryCode(CountryCode value){
    selectedCountryCode=value;
    notifyListeners();
  }

  void onCountryCodeChanged(CountryCode? value){
    if(value == null) return;
    setSelectedCountryCode(value);

  }
  void onPhoneChanged(String value){
    phoneNumber=value;

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