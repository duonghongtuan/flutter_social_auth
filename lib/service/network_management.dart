// ignore_for_file: body_might_complete_normally_catch_error, constant_identifier_names, unused_element, non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../flutter_social_auth.dart';

const int STATUS_EMAIL_VERIFY_NOT_EXISTED = -1;
const int STATUS_EMAIL_VERIFY_ERROR = -2;

class NetworkManagement {
  Future<bool> sendEmailVerifyCode({required String domain, required String email, required String appName}) async {
    String url = _urlSendEmailVerifyCode(email, domain, appName);
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

  Future<VerifyCodeStatus> verifyCode({required String email, required String code, required String domain}) async {
    String url = _urlVerifyCode(email, code, domain);
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

  String _urlVerifyCode(String email, String code, String domain) {
    final url = _Constants.urlVerifyCode(email, code);
    return "$domain$url";
  }

  String _urlSendEmailVerifyCode(String email, String domain, String appName) {
    String url = _Constants.urlSendEmailVerifyCode(email, appName);
    return "$domain$url";
  }
}

class _Constants {
  static String verify_code = "/api/auth?type=verify-code";
  static String urlVerifyCode(String email, String code) {
    return "${_Constants.verify_code}&email=$email&code=$code";
  }

  static String get send_email => "/api/auth?type=send-email";
  static String urlSendEmailVerifyCode(String email, String appName) {
    return "${_Constants.send_email}&email=$email&appName=$appName";
  }
}
