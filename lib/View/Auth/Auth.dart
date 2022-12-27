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
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Silahkan pilih akses masuk',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
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
                          icon: Icon(
                            FontAwesomeIcons.google,
                            size: 24.0,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Masuk dengan Gmail',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          'Atau',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
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
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            size: 24.0,
                            color: Colors.black,
                          ),
                          label: Text(
                            'Masuk dengan WhatsApp',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
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
    );
  }
}
