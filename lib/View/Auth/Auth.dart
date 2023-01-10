import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/Config/Api.dart';
import 'package:blitz_hris/View/Auth/LogWithWA.dart';
import 'package:blitz_hris/View/Auth/Login.dart';
import 'package:blitz_hris/View/Auth/ResetPassword.dart';
import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Router/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';

class Auth extends StatefulWidget {
  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  void initState() {
    canSubmit = false;
    super.initState();
  }

  void httpJob(AnimationController controller) async {
    controller.forward();
    controller.reset();
  }

  bool loading = false;
  bool _isObscure = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color.fromRGBO(0, 186, 242, 1),
      child: SafeArea(
        top: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
              statusBarColor: Color.fromRGBO(0, 186, 242, 1),
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 100),
                            width: 180,
                            child: const Image(
                              alignment: Alignment.bottomLeft,
                              image: AssetImage('assets/image/logoss.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Pilih Metode Verifikasi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Center(
                            child: Text(
                              'Pilih salah satu metode di bawah ini untuk mendapatkan kode verifikasi',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: true),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.5),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return Login();
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 300,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.only(left: 25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.envelope,
                                size: 24.0,
                                color: Color.fromRGBO(0, 186, 242, 1),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Text(
                                  'Masuk dengan Email',
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 186, 242, 1)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return LogWithWA();
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 300,
                          height: 50,
                          padding: EdgeInsets.only(left: 25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                FontAwesomeIcons.whatsapp,
                                size: 24.0,
                                color: Color.fromRGBO(0, 186, 242, 1),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12),
                                child: Text(
                                  'Masuk dengan Whatsapp',
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 186, 242, 1)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
