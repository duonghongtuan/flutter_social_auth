// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';

import '../flutter_social_auth.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, this.onPress, this.backgroundColor = Colors.white, required this.typeLogin, this.textColor = Colors.black});
  final TypeLogin typeLogin;
  final Color backgroundColor;
  final Color textColor;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
            onTap: onPress,
            child: Container(
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey)
                ),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),   
                alignment: Alignment.center,
                child: SizedBox(
                    width: Platform.isIOS ? 190 : 200,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Image.asset(
                                'assets/icons/${typeLogin.name}.png',
                                width: 24,
                                package: 'flutter_social_auth',
                            ),
                            const SizedBox(width: 12),
                            Text('Log in with ${typeLogin.name}', style: TextStyle(color: textColor,fontSize: 15, fontWeight: FontWeight.w500))
                        ],
                    ),
                ),
            ),
        );
  }
}