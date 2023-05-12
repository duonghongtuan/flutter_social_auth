library flutter_social_auth;

import 'package:flutter/material.dart';

import 'views/login_button_view.dart';

enum TypeLogin { google, facebook, apple }

extension TypeLoginEx on TypeLogin {}

class LoginView extends StatefulWidget {
  const LoginView({super.key, this.listTypeLogin});
  final List<TypeLogin>? listTypeLogin;
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailAdressController = TextEditingController();
  late List<TypeLogin> listTypeLogin;

  @override
  void initState() {
    super.initState();
    if (widget.listTypeLogin == null) {
      listTypeLogin = [TypeLogin.google, TypeLogin.facebook, TypeLogin.apple];
    } else {
      listTypeLogin = widget.listTypeLogin!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Login in to your',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
              ),
              const Text(
                'account',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 36),
                child: Text(
                  'Welcome to our Page',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ),
              for (TypeLogin typeLogin in listTypeLogin) LoginButton(typeLogin: typeLogin),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
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
              const Padding(
                padding:  EdgeInsets.symmetric(vertical: 16),
                child:  Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              TextField(
                controller: emailAdressController,
                decoration: InputDecoration(hintText: 'yourname@gmail.com',filled: true,fillColor: Colors.white,border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                ),
              ),
              const Spacer(),
              makeButtonVerify()

            ]),
          ),
      ),
    );
  }

  InkWell makeButtonVerify() {
    return InkWell(
          onTap: (){

          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              height: 57,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey)
                ),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),   
                alignment: Alignment.center,
                child: const Text('Verity',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),)
            ),
          ),
        );
  }
}
