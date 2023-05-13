import 'package:flutter/foundation.dart';
import 'package:flutter_social_auth/flutter_social_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignIn {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<UserAuthInfo?> signIn(TypeLogin typeLogin) async {
    switch (typeLogin) {
      case TypeLogin.google:
        return await signInWithGoogle(typeLogin);
      case TypeLogin.facebook:
        return await signInWithFacebook(typeLogin);
      case TypeLogin.apple:
        return await signInWithApple(typeLogin);
    }
  }

  Future<UserAuthInfo?> signInWithGoogle(TypeLogin typeLogin) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        return UserAuthInfo(
            id: googleUser.id, typeLogin: typeLogin, email: googleUser.email, photoUrl: googleUser.photoUrl);
      } else {
        return null;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return null;
  }

  Future<UserAuthInfo?> signInWithFacebook(TypeLogin typeLogin) async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult.status == LoginStatus.success) {
      return UserAuthInfo(id: loginResult.accessToken!.userId, typeLogin: typeLogin);
    } else {
      return null;
    }
  }

  String generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserAuthInfo?> signInWithApple(TypeLogin typeLogin) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    if (appleCredential.userIdentifier != null) {
      return UserAuthInfo(id: appleCredential.userIdentifier!, typeLogin: typeLogin,email: appleCredential.email);
    }else{
      return null;
    }
  }
}
