import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_indicator_button/progress_button.dart';

class ResetPass extends StatefulWidget {
  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  void initState() {
    canSubmit = false;
    Emailverif = true;
    super.initState();
  }

  void httpJob(AnimationController controller) async {
    controller.forward();
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        Emailverif = false;
      });
    });
    controller.reset();
  }

  bool loading = false;

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
                    child: Emailverif
                        ? Container(
                            margin: EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          18),
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Login(),
                                          ),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.only(top: 20),
                                      alignment: Alignment.topLeft,
                                      child: Icon(
                                        FeatherIcons.chevronsLeft,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/image/logo.png'),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Reset Password',
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
                                    'Masukkan email dan kata sandi Anda reset password.',
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

                                canSubmit
                                    ? Container(
                                        margin: EdgeInsets.only(top: 14),
                                        height: 45,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        child: ProgressButton(
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                          onPressed: (AnimationController
                                              controller) async {
                                            httpJob(controller);
                                            setState(() {
                                              loading = !loading;
                                            });
                                          },
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          strokeWidth: 2,
                                          child: Text(
                                            "Kirim Link Reset",
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        child: ProgressButton(
                                          color: Colors.grey,
                                          onPressed: (AnimationController
                                              controller) async {
                                            setState(() {});
                                          },
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          strokeWidth: 2,
                                          child: Text(
                                            "Kirim Link Reset",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'poppins'),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          18),
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Emailverif = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.only(top: 20),
                                      alignment: Alignment.topLeft,
                                      child: Icon(
                                        FeatherIcons.chevronsLeft,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/image/logo.png'),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Berhasil!',
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
                                    'Link reset password telah kami kirim. Periksa kotak masuk atau spam email Anda.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'poppins',
                                    ),
                                  ),
                                ),

                                //mail
                                Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.only(top: 7),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Text(
                                            '03.12',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'poppins',
                                              color: Color.fromRGBO(
                                                  0, 186, 242, 1),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'Kirim Ulang',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'poppins',
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                  ),
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
bool Emailverif = false;
TextEditingController email = TextEditingController();
