import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/ResetPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:progress_indicator_button/progress_button.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void initState() {
    canSubmit = false;
    super.initState();
  }

  void httpJob(AnimationController controller) async {
    controller.forward();
    await Future.delayed(Duration(seconds: 5), () {});
    controller.reset();
  }

  bool loading = false;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light),
        child: Stack(
          children: [
            Scaffold(
              // ignore: sized_box_for_whitespace
              body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.yellow,
                  child: SingleChildScrollView(
                      child: Container(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 14),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/image/logo.png'),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Masukkan email dan kata sandi Anda untuk menggunakan Blitz',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),

                        //mail
                        Container(
                          padding: EdgeInsets.all(3),
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextFormField(
                            controller: email,
                            onChanged: (vale) {
                              if (vale.length == 0) {
                                setState(() {
                                  canSubmit = false;
                                });
                              } else {
                                setState(() {
                                  canSubmit = true;
                                });
                              }
                            },
                            autocorrect: false,
                            enableSuggestions: false,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                FeatherIcons.mail,
                                color: Color.fromRGBO(0, 186, 242, 1),
                              ),
                              hintText: 'Masukan email anda',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        //password
                        Container(
                          padding: EdgeInsets.all(3),
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kata Sandi',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: katasandi,
                            autocorrect: false,
                            obscureText: _isObscure,
                            enableSuggestions: false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                FeatherIcons.lock,
                                color: Color.fromRGBO(0, 186, 242, 1),
                              ),
                              hintText: 'Masukan kata sandi anda',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                            ),
                          ),
                        ),

                        canSubmit
                            ? Container(
                                margin: EdgeInsets.only(top: 14),
                                height: 45,
                                width: MediaQuery.of(context).size.width - 20,
                                child: ProgressButton(
                                  color: Color.fromRGBO(0, 186, 242, 1),
                                  onPressed:
                                      (AnimationController controller) async {
                                    httpJob(controller);
                                    setState(() {
                                      loading = !loading;
                                    });
                                  },
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  strokeWidth: 2,
                                  child: Text(
                                    "Masuk",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'poppins'),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 14),
                                height: 45,
                                width: MediaQuery.of(context).size.width - 20,
                                child: ProgressButton(
                                  color: Colors.grey,
                                  onPressed:
                                      (AnimationController controller) async {
                                    setState(() {});
                                  },
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  strokeWidth: 2,
                                  child: Text(
                                    "Masuk",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'poppins'),
                                  ),
                                ),
                              ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ResetPass(),
                                ),
                                (Route<dynamic> route) => false);
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            child: Text(
                              'Lupa Kata Sandi?',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(0, 186, 242, 1),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins',
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool canSubmit = false;
TextEditingController email = TextEditingController();
TextEditingController katasandi = TextEditingController();
