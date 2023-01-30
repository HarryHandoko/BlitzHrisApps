import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/Auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tellme_alert/tellme_alert.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

import '../../Config/Api.dart';
import '../Router/Navigation.dart';

class Riwayat extends StatefulWidget {
  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  String? name;
  String? email;
  String? avatar;
  bool loading_s = false;
  bool _isLoading = false;
  File? imageFile;

  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      avatar = prefs.getString('avatar');
    });
  }

  String? verif;
  Future getVerifToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(Uri.parse(Uri.encodeFull(KEY.BASE_URL + 'v1/profile')), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token')}",
    });

    setState(() {
      var jsosn = json.decode(response.body);
      verif = jsosn['code'].toString();
      email = jsosn['data']['email'];
      avatar = jsosn['data']['avatar'];
    });

    return "Success";
  }

  void initState() {
    super.initState();
    getProfile().whenComplete(() {
      getVerifToken().whenComplete(() {
        setState(() {
          if (verif == '200') {
            loading_s = true;
          } else {
            setState(() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('name');
              prefs.remove('avatar');
              prefs.remove('token');
              loading_s = false;
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Auth()),
                    (Route<dynamic> route) => false);
              });
            });
          }
        });
      });
    });
  }

  void httpJob(AnimationController controller) async {
    controller.forward();
    await Future.delayed(Duration(seconds: 5), () {});
    controller.reset();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (!loading_s) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // color: Colors.red,
          child: const Center(
            child: SpinKitFadingCircle(
              color: Colors.blue,
              size: 60.0,
            ),
          ),
        ),
      );
    } else {
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
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 60, bottom: 100),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 100, left: 20),
                              width: 400,
                              child: SvgPicture.asset(
                                "assets/image/empty.svg",
                                width: 170,
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 30, left: 10, right: 10),
                              child: Text(
                                'Belum ada riwayat absensi. Bulan ini sahabat driver blitz belum ada data absensi yang tersimpan, silakan lakukan tap masuk dan tap pulang.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 20),
                                height: 45,
                                width: MediaQuery.of(context).size.width - 20,
                                child: GestureDetector(
                                  onTap: (() {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Navigation(),
                                        ),
                                        (Route<dynamic> route) => false);
                                  }),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 186, 242, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Kembali Ke Menu Utama",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'poppins'),
                                    )),
                                  ),
                                ))
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
}
