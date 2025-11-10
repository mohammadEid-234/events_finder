import 'package:finder/core/logging/logger.dart';
import 'package:finder/features/auth/model/country_code.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

bool isValidEmail(String email) {
  // Trim spaces
  email = email.trim();

  // Basic regex: something@something.domain
  final regex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  return regex.hasMatch(email);
}

String? validatePhoneByCountry(String? input, CountryCode country) {
  try{

    if (input == null || input.trim().isEmpty) {
      return 'Phone is required';
    }
    if(hasSpecial(input)){
      return 'Phone must contain digits only';
    }

    return PhoneNumber.parse(input,callerCountry: country.iso2).isValid(type: PhoneNumberType.mobile) ? null : "Invalid Phone number";
  }catch(e){
    Logger.log("error validating phone :$e");
    return "Error validating phone";
  }

}
bool hasLower (String password)=> RegExp(r'[a-z]').hasMatch(password);
bool  hasUpper (String password)=> RegExp(r'[A-Z]').hasMatch(password);
bool  hasDigit (String password)=> RegExp(r'\d').hasMatch(password);
bool  hasSpecial (String password)=> RegExp(r'[!@#\$%^+&*(),.?":{}|<>]').hasMatch(password);
bool  validLength (String password)=> password.length >= 8 && password.length <= 20;
String? isPasswordValid(String password){
  if(!hasLower(password) || !hasUpper(password) || !hasDigit(password) || !hasSpecial(password) || !validLength(password)){
    return "Please enter a strong password";
  }
  return null;
}