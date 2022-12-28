import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/Config/Api.dart';
import 'package:blitz_hris/View/Auth/OTP.dart';
import 'package:blitz_hris/View/Auth/ResetPassword.dart';
import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Router/Navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';

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
    controller.reset();
  }

  bool loading = false;
  bool _isObscure = true;
  bool _isLoading = false;

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
                                    _isLoading = true;
                                    auth();
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
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return ResetPass();
                                },
                              ),
                            );
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
            if (_isLoading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool canSubmit = false;
  TextEditingController email = TextEditingController();
  TextEditingController katasandi = TextEditingController();

  Future auth() async {
    try {
      String myUrl = KEY.BASE_URL + "v1/login";
      var result = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
      }, body: {
        "email": email.text,
        "password": katasandi.text
      });
      var jsonObject = json.decode(result.body);
      if (jsonObject['code'] == 200) {
        var token = jsonObject['data']['secret_code'];
        final preff1 = await SharedPreferences.getInstance();
        await preff1.setString('token', token);
        await preff1.setString('email', email.text);
        await preff1.setString('katasandi', katasandi.text);
        await Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return OTP();
              },
            ),
          );
        });
      } else {
        if (katasandi.text == '') {
          setState(() {
            Alert(
              context: context,
              type: AlertType.error,
              desc: "Password Tidak Boleh Kosong",
              buttons: [
                DialogButton(
                  color: Colors.blue,
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            Alert(
              context: context,
              type: AlertType.error,
              desc: "Email atau Password Anda tidak cocok",
              buttons: [
                DialogButton(
                  color: Colors.blue,
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  width: 120,
                )
              ],
            ).show();
          });
        }
      }
    } on SocketException catch (_) {
      setState(() {
        _isLoading = false;
        SweetAlert.show(
          context,
          subtitle: "No Internet Connection!",
          style: SweetAlertStyle.error,
        );
      });
    } on TimeoutException {
      setState(() {
        _isLoading = false;
        SweetAlert.show(
          context,
          subtitle: "Connection Timeout!",
          style: SweetAlertStyle.error,
        );
      });
    }
  }
}
