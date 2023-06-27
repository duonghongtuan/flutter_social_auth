// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api, sort_child_properties_last
library flutter_social_auth;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_social_auth/views/verify_view.dart';

import 'service/email_validator.dart';
import 'service/network_management.dart';
import 'service/sign_in.dart';
import 'views/login_button_view.dart';
import 'views/widget/slide_left_animation.dart';

enum TypeLogin { google, facebook, apple }

enum StatusPageLogin { login, verify, signin }

enum VerifyCodeStatus { done, error, expired, notExitst }

extension TypeLoginEx on TypeLogin {}

class UserAuthInfo {
  String id;
  TypeLogin typeLogin;
  String? email;
  String? name;
  String? photoUrl;
  UserAuthInfo({
    required this.id,
    required this.typeLogin,
    this.email,
    this.name,
    this.photoUrl,
  });
}

class SocialAuthStyle {
  Color? backgroundColor;
  Color textColorButtonLogin;
  Color backgroundColorButtonLogin;
  Color textColorButtonVerify;
  Color backgroundColorButtonVerify;
  SocialAuthStyle({
    this.backgroundColor,
    this.textColorButtonLogin = Colors.black,
    this.backgroundColorButtonLogin = Colors.white,
    this.textColorButtonVerify = Colors.white,
    this.backgroundColorButtonVerify = Colors.black,
  });
}

typedef OnLogin = Function(UserAuthInfo? userAuthInfo);
typedef OnSendEmailVerifyCode = Function(bool result, String email);
typedef OnVerifyCode = Function(VerifyCodeStatus verifyCodeStatus);
typedef MakeUrlSendEmailCode = String Function(String email);
typedef MakeUrlVerifyCode = String Function(String email, String code);

class AuthView extends StatefulWidget {
  AuthView(
      {super.key,
      this.listTypeLogin,
      this.hideLoginWith = false,
      required this.onLogin,
      required this.onSendEmailVerifyCode,
      required this.makeUrlVerifyCode,
      required this.onVerifyCode,
      socialAuthStyle,
      this.logoWidget,
      required this.makeUrlSendEmailCode,
      this.header})
      : socialAuthStyle = socialAuthStyle ?? SocialAuthStyle();
  final List<TypeLogin>? listTypeLogin;
  final bool hideLoginWith;
  final MakeUrlVerifyCode makeUrlVerifyCode;
  final MakeUrlSendEmailCode makeUrlSendEmailCode;
  final OnLogin onLogin;
  final OnSendEmailVerifyCode onSendEmailVerifyCode;
  final OnVerifyCode onVerifyCode;
  final SocialAuthStyle socialAuthStyle;
  final Widget? logoWidget;
  final Widget? header;
  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  TextEditingController emailAdressController = TextEditingController();
  List<TypeLogin> listTypeLogin = [];
  final SignIn signIn = SignIn();
  final _formEmailKey = GlobalKey<FormState>();
  bool _sendEmailLoading = false;
  StatusPageLogin statusPageLogin = StatusPageLogin.login;
  NetworkManagement networkManagement = NetworkManagement();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.listTypeLogin == null) {
      listTypeLogin = [TypeLogin.google, TypeLogin.facebook, TypeLogin.apple];
    } else {
      listTypeLogin = widget.listTypeLogin!;
    }
  }

  _onSendEmail() {
    networkManagement.sendEmailVerifyCode(widget.makeUrlSendEmailCode(emailAdressController.text)).then((result) {
      widget.onSendEmailVerifyCode(result, emailAdressController.text);
      setState(() {
        _sendEmailLoading = false;
      });
      if (result) {
        setState(() {
          statusPageLogin = StatusPageLogin.verify;
        });
      }
    });
  }

  _scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  get _screen {
    switch (statusPageLogin) {
      case StatusPageLogin.login:
        return makeLoginView();
      case StatusPageLogin.verify:
        return SlideLeftAnimation(
            child: VerifyView(
              email: emailAdressController.text,
              socialAuthStyle: widget.socialAuthStyle,
              makeUrlVerifyCode: widget.makeUrlVerifyCode,
              onVerifyCode: widget.onVerifyCode,
              logoWidget: widget.logoWidget,
            ),
            duration: const Duration(milliseconds: 300));
      case StatusPageLogin.signin:
        return const Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen,
    );
  }

  Container makeLoginView() {
    return Container(
      color: widget.socialAuthStyle.backgroundColor,
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Flexible(
          child: ListView(
            controller: _scrollController,
            children: [
              widget.logoWidget ?? const SizedBox(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Log in to your',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'account',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 24, bottom: widget.hideLoginWith ? 10 : 36),
                child: const Text(
                  'Welcome to our App',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ),
              widget.hideLoginWith
                  ? const SizedBox()
                  : Column(
                      children: [
                        for (TypeLogin typeLogin in listTypeLogin)
                          LoginButton(
                            typeLogin: typeLogin,
                            onPress: (typeLogin) async {
                              final userAuthInfo = await signIn.signIn(typeLogin);
                              widget.onLogin(userAuthInfo);
                            },
                            backgroundColor: widget.socialAuthStyle.backgroundColorButtonLogin,
                            textColor: widget.socialAuthStyle.textColorButtonLogin,
                          ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: Text(
                                'or',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ],
                    ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              Form(
                key: _formEmailKey,
                child: TextFormField(
                  controller: emailAdressController,
                  decoration: InputDecoration(
                    hintText: 'yourname@gmail.com',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (String? value) {
                    if (value == null || value == "") {
                      _scrollToEnd();
                      return "Please enter your email!";
                    }
                    value = value.trim();
                    if (!EmailValidator.validate(value)) {
                      _scrollToEnd();
                      return "Please provide a valid email address";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        // const Spacer(),
        makeButtonVerify()
      ]),
    );
  }

  InkWell makeButtonVerify() {
    return InkWell(
      onTap: () {
        if (_formEmailKey.currentState!.validate()) {
          setState(() {
            _sendEmailLoading = true;
          });
          _onSendEmail();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Container(
            height: 57,
            decoration: BoxDecoration(
                color: widget.socialAuthStyle.backgroundColorButtonVerify,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey)),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: _sendEmailLoading
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator())
                : Text(
                    'Verify',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500, color: widget.socialAuthStyle.textColorButtonVerify),
                  )),
      ),
    );
  }
}
