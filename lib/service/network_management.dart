// ignore_for_file: body_might_complete_normally_catch_error, constant_identifier_names, unused_element, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../flutter_social_auth.dart';

const int STATUS_EMAIL_VERIFY_NOT_EXISTED = -1;
const int STATUS_EMAIL_VERIFY_ERROR = -2;

class NetworkManagement {
  Future<bool> sendEmailVerifyCode(String url) async {
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ).catchError((e) {
        if (kDebugMode) {
          print("verifyCode failed: $e \n $url");
        }
      });
      if (res.statusCode == 200) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('error email code $e');
      }
    }
    return false;
  }

  Future<VerifyCodeStatus> verifyCode(String url) async {
    VerifyCodeStatus status = VerifyCodeStatus.error;
    try {
      final res = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ).catchError((e) {
        if (kDebugMode) {
          print("verifyCode failed: $e \n $url");
        }
      });
      // print("XXXX ${res?.statusCode} - ${res.body}");
      if (res.statusCode == 200) {
        // print("verifyCode body ${res.body}");
        status = VerifyCodeStatus.notExitst;
        try {
          status = int.parse(res.body) == 1 ? VerifyCodeStatus.done : VerifyCodeStatus.expired;
        } catch (e) {
          if (kDebugMode) {
            print("parse error: $e");
          }
        }
        return status;
      }
    } catch (e) {
      if (kDebugMode) {
        print('verifyCode $e');
      }
    }

    return status;
  }
}
