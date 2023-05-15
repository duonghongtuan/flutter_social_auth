import 'package:flutter/material.dart';
import 'package:flutter_social_auth/flutter_social_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String _makeSendEmailCode(String email){
    return 'https://flutter/$email';
  }

  String _makeUrlVerifyCode(String email, String code){
    return 'https://flutter/$email/$code';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthView(
        listTypeLogin: const [TypeLogin.google, TypeLogin.apple],
        hideLoginWith: true,
        onLogin: (userAuthInfo) {
          if (userAuthInfo != null) {
            print(userAuthInfo);
          }
        },
        makeUrlSendEmailCode: _makeSendEmailCode,
        makeUrlVerifyCode: _makeUrlVerifyCode,
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
