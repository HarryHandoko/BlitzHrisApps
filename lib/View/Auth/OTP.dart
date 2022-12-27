import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:blitz_hris/Config/Api.dart';
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
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class OTP extends StatefulWidget {
  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  void initState() {
    super.initState();
  }

  void httpJob(AnimationController controller) async {
    controller.forward();
    controller.reset();
  }

  bool loading = false;
  bool _isLoading = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool resend = false;

  @override
  Widget build(BuildContext context) {
    final CountdownController _controller =
        new CountdownController(autoStart: true);
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
                              'Kode OTP',
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
                              'Silahkan check email/WA anda dan masukan kode OTP',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ),
                          OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 40,
                            style: TextStyle(fontSize: 17),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              setState(() {
                                _isLoading = true;
                                otp(pin);
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                resend
                                    ? GestureDetector(
                                        onTap: () {
                                          _controller.start();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Text(
                                            'Kirim Ulang OTP',
                                            style: TextStyle(
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Text(
                                            'Kirim Ulang OTP',
                                            style: TextStyle(
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                Container(
                                  child: Countdown(
                                    controller: _controller,
                                    seconds: 5,
                                    build: (_, time) => Text(
                                      '00 : ' + time.toInt().toString(),
                                      style: TextStyle(
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.normal),
                                    ),
                                    interval: Duration(seconds: 1),
                                    onFinished: () {
                                      setState(() {
                                        resend = true;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          )
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

  Future otp(pin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String myUrl = KEY.BASE_URL + "v1/otp";
      var result = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
      }, body: {
        "secret_code": prefs.getString('token')!,
        "otp": pin,
      });
      var jsonObject = json.decode(result.body);
      if (jsonObject['code'] == 200) {
        final preff1 = await SharedPreferences.getInstance();
        await preff1.setString('name', jsonObject['data']['name']);
        await preff1.setString('avatar', jsonObject['data']['avatar']);
        await Future.delayed(Duration(seconds: 3), () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Navigation(),
              ),
              (Route<dynamic> route) => false);
        });
      } else {
        setState(() {
          _isLoading = false;
          Alert(
            context: context,
            type: AlertType.error,
            desc: "OTP yang anda masukan salah, silahkan cek kembali!",
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
