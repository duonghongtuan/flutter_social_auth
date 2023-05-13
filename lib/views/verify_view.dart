import 'package:flutter/material.dart';
import 'package:flutter_social_auth/flutter_social_auth.dart';
import 'package:flutter_social_auth/service/network_management.dart';
import '../service/email_validator.dart';

class VerifyView extends StatefulWidget {
  const VerifyView(
      {super.key,
      required this.email,
      required this.socialAuthStyle,
      required this.onVerifyCode,
      required this.domain, this.logoWidget});
  final String email;
  final String domain;
  final SocialAuthStyle socialAuthStyle;
  final OnVerifyCode onVerifyCode;
  final Widget? logoWidget;
  @override
  State<VerifyView> createState() => _VerifyViewState();
}

class _VerifyViewState extends State<VerifyView> {
  final _formCodeKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  bool _sendCodeLoading = false;
  NetworkManagement networkManagement = NetworkManagement();

  _onSendCode(){
    networkManagement.verifyCode(email: widget.email, code: codeController.text, domain: widget.domain).then((value){
      widget.onVerifyCode(value);
      setState(() {
        _sendCodeLoading = false;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.logoWidget ??  const SizedBox(),
          const Text(
            'Enter your',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
          ),
          const Text(
            'Verification code',
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 56),
            child: Text(
              'Please check your inbox for the verification code sent to ${widget.email}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          Form(
            key: _formCodeKey,
            child: TextFormField(
              autofocus: true,
              controller: codeController,
              decoration: InputDecoration(
                hintText: 'Enter your code here',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (String? value) {
                if (value == null || value.trim() == '') {
                  return "Please enter your code!";
                }
                if (value.length < 6 || !validateCode(value)) {
                  return "Invalid code!";
                }
                return null;
              },
            ),
          ),
          const Spacer(),
          makeButtonVerify()
        ],
      ),
    );
  }

  InkWell makeButtonVerify() {
    return InkWell(
      onTap: () {
        if (_formCodeKey.currentState!.validate()) {
          setState(() {
            _sendCodeLoading = true;
          });
          _onSendCode();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
            height: 57,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey)),
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: _sendCodeLoading
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator())
                : const Text(
                    'Verify',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                  )),
      ),
    );
  }
}
