import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/Auth.dart';
import 'package:blitz_hris/View/Home/FotoSelfie.dart';
import 'package:blitz_hris/View/Home/Hadir.dart';
import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Router/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:tellme_alert/tellme_alert.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Config/Api.dart';

class Foto extends StatefulWidget {
  @override
  State<Foto> createState() => _FotoState();
}

class _FotoState extends State<Foto> {
  String? verif;
  String? name;
  String? token;
  String? email;
  bool loading_s = false;
  bool _isLoading = false;

  File? image;

  Future<void> openCamera() async {
    //fuction openCamera();
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      // tempat untuk set state image
      image = File(pickedImage!.path);
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
                            left: 0, right: 0, top: 50, bottom: 10),
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
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (BuildContext
                                                      context,
                                                  Animation<double> animation,
                                                  Animation<double>
                                                      secondaryAnimation) {
                                                return Navigation();
                                              },
                                            ),
                                          );
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        Hadir(),
                                              ),
                                              (Route<dynamic> route) => false);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        FotoSelfie(),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(0),
                                          margin: EdgeInsets.only(top: 10),
                                          alignment: Alignment.topLeft,
                                          child: Icon(
                                            FontAwesomeIcons.circleChevronLeft,
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
                                        'Foto',
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
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          'Foto Selfie',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: image != null
                                            ? GestureDetector(
                                                onTap: () {
                                                  openCamera();
                                                },
                                                child: Text(
                                                  'Ulangi Foto',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              )
                                            : Text(''),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: image == null
                                        ? Image(
                                            height: 350,
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                                'https://kare.ee/images/no-image.jpg'),
                                          )
                                        : Image.file(image!),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  image == null
                                      ? Container(
                                          margin: EdgeInsets.only(top: 20),
                                          height: 45,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          child: ProgressButton(
                                            color:
                                                Color.fromRGBO(0, 186, 242, 1),
                                            onPressed: (AnimationController
                                                controller) {
                                              openCamera();
                                            },
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            strokeWidth: 2,
                                            child: Text(
                                              "Ambil Foto",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'poppins'),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(top: 20),
                                          height: 45,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          child: ProgressButton(
                                            onPressed: ((p0) async {
                                              final preff1 =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await preff1.setString(
                                                  'imageAbsen',
                                                  image!.toString());
                                              print(preff1
                                                  .getString('imageAbsen'));
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return Navigation();
                                                  },
                                                ),
                                              );
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Hadir(),
                                                  ),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            }),
                                            color:
                                                Color.fromRGBO(0, 186, 242, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            strokeWidth: 2,
                                            child: Text(
                                              "Simpan",
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
}
