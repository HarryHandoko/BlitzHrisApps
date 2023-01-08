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

class GantiPassword extends StatefulWidget {
  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  String? verif;
  String? name;
  String? token;
  String? email;
  bool loading_s = false;
  bool _isLoading = false;
  bool _isObscure = true;
  bool _isObscures = true;
  bool _isObscuress = true;

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
                  MaterialPageRoute(builder: (BuildContext context) => Auth()),
                  (Route<dynamic> route) => false);
            });
          });
        }
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
                                        'Ganti Password',
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
                                      'Password Lama',
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
                                      controller: katasandi_lama,
                                      autocorrect: false,
                                      obscureText: _isObscure,
                                      enableSuggestions: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          FeatherIcons.lock,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        hintText:
                                            'Masukan kata sandi lama anda',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
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
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Password Baru',
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
                                      controller: katasandi_baru,
                                      autocorrect: false,
                                      obscureText: _isObscures,
                                      enableSuggestions: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          FeatherIcons.lock,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        hintText:
                                            'Masukan kata sandi baru anda',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscures
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscures = !_isObscures;
                                              });
                                            }),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      controller: katasandi_konfirm,
                                      autocorrect: false,
                                      obscureText: _isObscuress,
                                      enableSuggestions: false,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          FeatherIcons.lock,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        hintText:
                                            'Masukan kata sandi konfirmasi anda',
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscuress
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscuress = !_isObscuress;
                                              });
                                            }),
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

  TextEditingController katasandi_lama = TextEditingController();
  TextEditingController katasandi_baru = TextEditingController();
  TextEditingController katasandi_konfirm = TextEditingController();
  Future editProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((katasandi_konfirm.text != '' || katasandi_konfirm.text != null) &&
        (katasandi_baru.text != '' || katasandi_baru.text != null) &&
        katasandi_baru.text == katasandi_konfirm.text) {
      try {
        String myUrl = KEY.BASE_URL + "v1/change-password";
        var result = await http.post(Uri.parse(myUrl), headers: {
          'Accept': 'application/json',
          "Authorization": "Bearer ${prefs.getString('token')}",
        }, body: {
          "old_password": katasandi_lama.text,
          "new_password": katasandi_baru.text,
          "new_password_confirmation": katasandi_konfirm.text,
        });
        var jsonObject = json.decode(result.body);
        print(jsonObject);
        if (jsonObject['code'] == 200) {
          await Future.delayed(Duration(seconds: 3), () {
            setState(() {
              _isLoading = false;

              Alert(
                context: context,
                type: AlertType.success,
                desc: "Password berhasil diubah!",
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
          });
        } else {
          if ((katasandi_baru.text == null || katasandi_baru.text == '') ||
              (katasandi_lama.text == null || katasandi_lama.text == '') ||
              (katasandi_konfirm.text == null ||
                  katasandi_konfirm.text == '')) {
            setState(() {
              _isLoading = false;
              Alert(
                context: context,
                type: AlertType.error,
                desc: "Password tidak boleh kosong",
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
    } else {
      setState(() {
        _isLoading = false;
        Alert(
          context: context,
          type: AlertType.error,
          desc: "Password tidak sama",
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
}
