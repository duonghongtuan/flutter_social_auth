import 'package:flutter/material.dart';
import 'package:flutter_social_auth/flutter_social_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(
        domain: 'https://flutter',
        appName: "apptesst",
        onLogin: (UserAuthInfo? userAuthInfo) {
          print("debug");
          if (userAuthInfo != null) {
            print(userAuthInfo.email);
          }
        },
        onSendEmailVerifyCode: (result, email) {
          print(email);
        },
        onVerifyCode: (verifyCodeStatus) {
          print(verifyCodeStatus.name);
        },
        logoWidget: const Text('Logo App', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.red),),
      ),
    );
  }
}
