import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/Auth.dart';
import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Router/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:tellme_alert/tellme_alert.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:http/http.dart' as http;

import '../../Config/Api.dart';

class DataDiri extends StatefulWidget {
  @override
  State<DataDiri> createState() => _DataDiriState();
}

class _DataDiriState extends State<DataDiri> {
  String? verif;
  String? name;
  String? token;
  String? email;
  bool loading_s = false;
  bool _isLoading = false;

  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      token = prefs.getString('token');
      email = prefs.getString('email');

      nama_lengkap.text = name!;
      email_address.text = email!;
    });
  }

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
                            left: 0, right: 0, top: 50, bottom: 100),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      alignment: Alignment.topLeft,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Navigation(),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.only(top: 10),
                                          alignment: Alignment.topLeft,
                                          child: Icon(
                                            FeatherIcons.chevronsLeft,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 11,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 20),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Data Diri',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Nama Lengkap',
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
                                      keyboardType: TextInputType.text,
                                      controller: nama_lengkap,
                                      onChanged: (vale) {},
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          FeatherIcons.user,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        hintText: 'Masukan Nama Lengkap',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
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
                                      keyboardType: TextInputType.emailAddress,
                                      controller: email_address,
                                      onChanged: (vale) {},
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          FeatherIcons.mail,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        hintText: 'Masukan Email Anda',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 14),
                              height: 45,
                              width: MediaQuery.of(context).size.width - 20,
                              child: ProgressButton(
                                color: Color.fromRGBO(0, 186, 242, 1),
                                onPressed:
                                    (AnimationController controller) async {
                                  _isLoading = true;
                                  editProfile();
                                  setState(() {
                                    loading = !loading;
                                  });
                                },
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                strokeWidth: 2,
                                child: Text(
                                  "Simpan",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'poppins'),
                                ),
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
  }

  TextEditingController nama_lengkap = TextEditingController();
  TextEditingController email_address = TextEditingController();
  Future editProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String myUrl = KEY.BASE_URL + "v1/profile";
      var result = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json',
        "Authorization": "Bearer ${prefs.getString('token')}",
      }, body: {
        "name": nama_lengkap.text,
        "email": email_address.text,
      });
      var jsonObject = json.decode(result.body);
      if (jsonObject['code'] == 200) {
        final preff1 = await SharedPreferences.getInstance();
        await preff1.setString('name', nama_lengkap.text);
        await preff1.setString('email', email_address.text);
        await Future.delayed(Duration(seconds: 3), () {
          setState(() {
            _isLoading = false;
          });
        });
      } else {
        if (email_address.text == null || email_address.text == '') {
          setState(() {
            _isLoading = false;
            Alert(
              context: context,
              type: AlertType.error,
              desc: "Alamat Email tidak boleh kosong",
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
        } else if (nama_lengkap.text == null || nama_lengkap.text == '') {
          setState(() {
            _isLoading = false;
            Alert(
              context: context,
              type: AlertType.error,
              desc: "Nama tidak boleh kosong",
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
