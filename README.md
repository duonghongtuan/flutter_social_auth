<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
## 0.0.4
Flutter package for login with social accounts like google, facebook, apple

## Getting started
Follow the instructions:
google_sign_in [here](https://pub.dev/packages/google_sign_in).  
flutter_facebook_auth [here](https://pub.dev/packages/flutter_facebook_auth).  
sign_in_with_apple [here](https://pub.dev/packages/sign_in_with_apple).  
## Example
```dart
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
```
