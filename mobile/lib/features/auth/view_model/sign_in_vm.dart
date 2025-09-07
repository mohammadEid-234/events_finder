import 'package:finder/features/auth/model/auth_repo.dart';
import 'package:flutter/material.dart';

class SignInVM extends ChangeNotifier {
  SignInVM();

  final AuthRepository _repo = AuthRepository();

  String _email = '';
  String _password = '';
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  // Getters
  String get email => _email;
  String get password => _password;
  bool get obscure => _obscure;
  bool get loading => _loading;
  String? get error => _error;

  // Mutations
  void setEmail(String v) {
    if (v == _email) return;
    _email = v;
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
    try {
      await _repo.signIn(email: _email.trim(), password: _password);
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
