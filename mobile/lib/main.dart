// dart
import 'package:finder/core/connection/token.dart';
import 'package:finder/core/style.dart';
import 'package:finder/features/auth/view/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:finder/features/home/view/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  Future<bool> _isSignedIn() async {

    final token = await TokenManager.instance.getTokenPair();
    debugPrint("token : $token");
    return token != null ;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: mainColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: mainColor,
          ),
        ),
      ),
      home: FutureBuilder<bool>(
        future: _isSignedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data == true ? const HomePage() : const SignInScreen();
        },
      ),
    );
  }
}
