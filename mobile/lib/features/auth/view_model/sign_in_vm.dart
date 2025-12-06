// dart
import 'package:finder/core/validation/user_input_validation.dart';
import 'package:finder/features/auth/model/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class SignInVM extends ChangeNotifier {
  SignInVM();

  final AuthRepository _repo = AuthRepository();
  String _phoneOrEmail = '';
  String _password = '';
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  // Getters
  String get phoneOrEmail => _phoneOrEmail;
  String get password => _password;
  bool get obscure => _obscure;
  bool get loading => _loading;
  String? get error => _error;


  void setPhoneOrEmail (String v) {
    if (v == _phoneOrEmail) return;
    _phoneOrEmail = v;
    _error = null;
    notifyListeners();
  }

  void setPassword(String v) {
    if (v == _password) return;
    _password = v;
    _error = null;
    notifyListeners();
  }

  void toggleObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  Future<void> submit() async {
    _loading = true;
    _error = null;
    notifyListeners();

    final identifier = _phoneOrEmail.trim();
    if (identifier.isEmpty) {
      _error = 'Please enter email or phone number';
      _loading = false;
      notifyListeners();
      return;
    }

    try {
      if (isValidEmail(identifier)) {
        await _repo.signIn(email: identifier, password: _password);
      } else if (PhoneNumber.parse(_phoneOrEmail).isValid(type: PhoneNumberType.mobile)) {
        await _repo.signIn(phone: identifier, password: _password);
      } else {
        _error = 'Enter a valid email or phone number';
        return;
      }
      // Handle success (e.g., navigation) from the caller.
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _repo.signInWithGoogle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithFacebook() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      await _repo.signInWithFacebook();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}