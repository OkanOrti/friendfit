// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:friendfit_ready/screens/home.dart';
import 'package:friendfit_ready/services/firebase_auth_methods.dart';
import 'package:friendfit_ready/theme/colors/light_colors.dart';
import 'package:friendfit_ready/utils/showSnackbar.dart';
import 'package:provider/src/provider.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //bool isEmailVerified = false;

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Şifre Sıfırla",
          style: TextStyle(color: AppColors.kFont),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              /*const Center(
                child: Text(
                  'Lütfen e-postanıza gönderilen aktivasyon mailini onaylayınız.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),*/
              //SizedBox(height: 10),
              FormBuilderTextField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  //hintText: '',
                  //filled: true,
                ),
                controller: emailController,
                autovalidateMode: AutovalidateMode.always,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context,
                      errorText: "Lütfen E-posta adresinizi giriniz."),
                  FormBuilderValidators.email(context,
                      errorText: "Lütfen gecerli bir e-posta giriniz")
                ]),
                name: 'email',
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: resetEmail,
                  icon: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Şifre Sıfırla",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementForgotPassword,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }

  Future resetEmail() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showSnackBar(
          context, "Şifenizi sıfırlamak icin e-postanıza bir link gönderildi.");

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      Navigator.of(context).pop();
    }
  }
}
