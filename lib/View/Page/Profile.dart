import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/Auth.dart';
import 'package:blitz_hris/View/Profile/DataDiri.dart';
import 'package:blitz_hris/View/Profile/GantiPassword.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
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

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                              child: Text(
                                'Profil',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: SizedBox(
                                height: 115,
                                width: 115,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  fit: StackFit.expand,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      backgroundImage: NetworkImage(avatar!),
                                    ),
                                    Positioned(
                                      right: -16,
                                      bottom: 0,
                                      child: SizedBox(
                                        height: 46,
                                        width: 46,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            side:
                                                BorderSide(color: Colors.white),
                                          ),
                                          color: Color(0xFFF5F6F9),
                                          onPressed: () {
                                            _getFromGallery();
                                          },
                                          child: Center(
                                            child:
                                                Icon(Icons.camera_alt_outlined),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                'Bergabung sejak Juni 2022',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'poppins',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                name!,
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 186, 242, 1),
                                  fontFamily: 'poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
                                      return DataDiri();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          FeatherIcons.settings,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Data Diri',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 233, 233, 233)),
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
                                      return GantiPassword();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          FeatherIcons.shield,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Ganti Password',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 233, 233, 233)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          FeatherIcons.phoneCall,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Bantuan',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 233, 233, 233)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                confirmationDialog(
                                    title: '',
                                    context,
                                    "Apakah anda ingin keluar?",
                                    positiveText: "Ya",
                                    positiveAction: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    prefs.remove('name');
                                    prefs.remove('avatar');
                                    prefs.remove('token');
                                    loading_s = false;
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Auth()),
                                          (Route<dynamic> route) => false);
                                    });
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          FeatherIcons.logOut,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Keluar Aplikasi',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 233, 233, 233)),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                'versi 1.0',
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
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
            ],
          ),
        ),
      );
    }
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      final prefs2 = await SharedPreferences.getInstance();

      Map<String, String> headers = {
        'Accept': 'application/json',
        "Authorization": "Bearer ${prefs2.getString('token')}",
      };
      var uri = Uri.parse(KEY.BASE_URL + "v1/profile");
      var length = await imageFile!.length();
      http.MultipartRequest request = new http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..fields['name'] = "${name}"
        ..fields['email'] = "${email}"
        ..files.add(
          http.MultipartFile('avatar', imageFile!.openRead(0), length,
              filename: 'test.png'),
        );
      var respons = await http.Response.fromStream(await request.send());
      var jsonObject = json.decode(respons.body);

      if (respons.statusCode == 200) {
        setState(() async {
          setState(() {
            _isLoading = true;
            getVerifToken().whenComplete(() => () {
                  setState(() {
                    _isLoading = false;
                  });
                });
          });
        });
        return;
      } else
        setState(() {
          _isLoading = false;
          errorDialog(
            context,
            "Erorr!",
          );
        });
    }
  }
}
