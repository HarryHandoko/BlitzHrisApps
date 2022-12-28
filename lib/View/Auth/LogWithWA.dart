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

class LogWithWA extends StatefulWidget {
  @override
  State<LogWithWA> createState() => _LogWithWAState();
}

class _LogWithWAState extends State<LogWithWA> {
  void initState() {
    canSubmit = false;
    super.initState();
  }

  void httpJob(AnimationController controller) async {
    controller.forward();
    controller.reset();
  }

  bool loading = false;
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
                              'Masukkan Nomor Handphone Anda untuk menggunakan Blitz',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ),

                          //NoHandphone
                          Container(
                            padding: EdgeInsets.all(3),
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'No. Handphone',
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
                              keyboardType: TextInputType.phone,
                              controller: mobile_phone,
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
                                  FeatherIcons.phone,
                                  color: Color.fromRGBO(0, 186, 242, 1),
                                ),
                                hintText: 'Masukan No. Handphone anda',
                                hintStyle: TextStyle(color: Colors.grey),
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
                        ],
                      ),
                    ),
                  ),
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
  TextEditingController mobile_phone = TextEditingController();

  Future auth() async {
    try {
      String myUrl = KEY.BASE_URL + "v1/login-mobile";
      var result = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
      }, body: {
        "mobile_phone": mobile_phone.text,
      });
      var jsonObject = json.decode(result.body);
      if (jsonObject['code'] == 200) {
        var token = jsonObject['data']['secret_code'];
        var mobile = mobile_phone.text;
        final preff1 = await SharedPreferences.getInstance();
        await preff1.setString('token', token);
        await preff1.setString('mobile', mobile);
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
        setState(() {
          _isLoading = false;
          Alert(
            context: context,
            type: AlertType.error,
            desc: "Nomor handphone Anda tidak terdaftar",
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
