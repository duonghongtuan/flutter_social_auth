import 'package:flutter/material.dart';
import 'package:flutter_social_auth/flutter_social_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthView(
        hideLoginWith: true,
        onLogin: (userAuthInfo) {
          if (userAuthInfo != null) {
            print(userAuthInfo);
          }
        },
        appName: 'appName',
        domain: 'https://domain',
        onSendEmailVerifyCode: (result, email) {
          if (result) {
            print(email);
          }
        },
        onVerifyCode: (verifyCodeStatus) {
          print(verifyCodeStatus.name);
        },
      ),
    );
  }
}
