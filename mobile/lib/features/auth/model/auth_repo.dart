class AuthRepository {
  Future<void> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }
    // TODO: real auth call
  }

  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> signInWithFacebook() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
