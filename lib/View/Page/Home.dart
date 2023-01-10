import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Home/Hadir.dart';
import 'package:blitz_hris/View/Page/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tellme_alert/tellme_alert.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter/src/painting/_network_image_io.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Config/Api.dart';
import '../Auth/Auth.dart';
import '../Router/Navigation.dart';

enum att { hadir, izin, sakit, tidakhadir }

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name;
  String? avatar;
  String? token;
  String? presence;
  var dt = DateTime.now();
  var tanggal = DateFormat("EEEEE, dd MMMM yyyy").format(DateTime.now());
  bool loading_s = false;
  att? _att = att.hadir;

  var presenceData;
  var presenceDatas;
  Future getAbsen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http
        .get(Uri.parse(Uri.encodeFull(KEY.BASE_URL + 'v1/shift')), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token')}",
    });

    setState(() {
      var jsosn = json.decode(response.body);
      presenceData = json.decode(response.body)['data']['employee_in'];
      presenceDatas = json.decode(response.body)['data'];
    });

    return "Success";
  }

  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      avatar = prefs.getString('avatar');
      token = prefs.getString('token');
      presence = prefs.getString('presence');
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
    });

    return "Success";
  }

  void initState() {
    super.initState();
    getAbsen().whenComplete(() {
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
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: CircularProfileAvatar(
                                              '',
                                              child: Image.network(avatar!),
                                              borderColor: Color.fromRGBO(
                                                  0, 186, 242, 1),
                                              borderWidth: 2,
                                              backgroundColor: Color.fromRGBO(
                                                  0, 186, 242, 1),
                                              elevation: 5,
                                              radius: 20,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Welcome to Blitz',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'poppins',
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    180,
                                                                    195,
                                                                    199),
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: RichText(
                                                        // overflow: TextOverflow,
                                                        strutStyle: StrutStyle(
                                                            fontSize: 12.0),
                                                        text: TextSpan(
                                                          text: name!,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'poppins',
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    186,
                                                                    242,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          )
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        // color:
                                        //     Color.fromARGB(150, 174, 227, 244),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: Icon(FeatherIcons.bell),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: "Presensi hari ini",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontFamily: 'poppins'),
                                                ),
                                                presenceData != null
                                                    ? TextSpan(
                                                        text: " (Hadir)",
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'poppins'),
                                                      )
                                                    : TextSpan(
                                                        text: "",
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'poppins'),
                                                      ),
                                              ]),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              presenceDatas['employee_in'] !=
                                                          null &&
                                                      presenceDatas[
                                                              'employee_out'] !=
                                                          null
                                                  ? presenceDatas['employee_in']
                                                          ['datetime'] +
                                                      " - " +
                                                      presenceDatas[
                                                              'employee_out']
                                                          ['datetime']
                                                  : DateFormat("HH:mm")
                                                      .format(DateTime.now()),
                                              style: TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontSize: 36,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            child: Text(
                                              tanggal,
                                              style: TextStyle(
                                                  fontFamily: 'poppins',
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Container(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 14),
                                              height: 45,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  20,
                                              child: presenceDatas[
                                                              'employee_in'] !=
                                                          null &&
                                                      presenceDatas[
                                                              'employee_out'] !=
                                                          null
                                                  ? ProgressButton(
                                                      color: Color.fromRGBO(
                                                          0, 186, 242, 1),
                                                      onPressed:
                                                          (AnimationController
                                                              controller) async {
                                                        // httpJob(controller);
                                                        setState(() {
                                                          loading = !loading;
                                                        });
                                                        // Navigator.of(context)
                                                        //     .push(
                                                        //   PageRouteBuilder(
                                                        //     pageBuilder: (BuildContext
                                                        //             context,
                                                        //         Animation<
                                                        //                 double>
                                                        //             animation,
                                                        //         Animation<
                                                        //                 double>
                                                        //             secondaryAnimation) {
                                                        //       return Hadir();
                                                        //     },
                                                        //   ),
                                                        // );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12)),
                                                      strokeWidth: 2,
                                                      child: Text(
                                                        "Hasil",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'poppins'),
                                                      ),
                                                    )
                                                  : ProgressButton(
                                                      color: Color.fromRGBO(
                                                          0, 186, 242, 1),
                                                      onPressed:
                                                          (AnimationController
                                                              controller) async {
                                                        // httpJob(controller);
                                                        setState(() {
                                                          loading = !loading;
                                                        });
                                                        Navigator.of(context)
                                                            .push(
                                                          PageRouteBuilder(
                                                            pageBuilder: (BuildContext
                                                                    context,
                                                                Animation<
                                                                        double>
                                                                    animation,
                                                                Animation<
                                                                        double>
                                                                    secondaryAnimation) {
                                                              return Hadir();
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      strokeWidth: 2,
                                                      child: Text(
                                                        presenceData == null
                                                            ? "Lakukan Presensi"
                                                            : "Nyatakan Selesai Kerja",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontFamily:
                                                                'poppins'),
                                                      ),
                                                    ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 228, 228, 228)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Kehadiran',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Lihat semuanya',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        fontSize: 12,
                                        color: Color.fromRGBO(0, 186, 242, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //nav absensi
                            Column(
                              children: [
                                Container(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  0, 186, 255, 1),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Nov',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.blue,
                                                    fontFamily: 'poppins',
                                                  ),
                                                ),
                                                Text(
                                                  '23',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.blue,
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Text(
                                              'Senin, 06:30 - 15:00',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontFamily: 'poppins',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: 1,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              onPressed: null,
                                              child: Text(
                                                'Hadir',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'poppins',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child:
                                                Icon(FeatherIcons.chevronRight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 218, 218, 218)),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 38, 129, 1),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Nov',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromRGBO(
                                                        255, 38, 129, 1),
                                                    fontFamily: 'poppins',
                                                  ),
                                                ),
                                                Text(
                                                  '23',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromRGBO(
                                                        255, 38, 129, 1),
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontFamily: 'poppins',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            width: 1,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    255, 38, 129, 1),
                                              ),
                                              onPressed: null,
                                              child: Text(
                                                'Tidak Hadir',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'poppins',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Text(''),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 218, 218, 218)),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 183, 15, 1),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Nov',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromRGBO(
                                                        255, 183, 15, 1),
                                                    fontFamily: 'poppins',
                                                  ),
                                                ),
                                                Text(
                                                  '23',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromRGBO(
                                                        255, 183, 15, 1),
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Text(
                                              'Senin, 06:30 - 15:00',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontFamily: 'poppins',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: 1,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    255, 183, 15, 1),
                                              ),
                                              onPressed: null,
                                              child: Text(
                                                'Sakit',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'poppins',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child:
                                                Icon(FeatherIcons.chevronRight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 218, 218, 218)),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 73, 15, 1),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Nov',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromRGBO(
                                                        255, 73, 15, 1),
                                                    fontFamily: 'poppins',
                                                  ),
                                                ),
                                                Text(
                                                  '23',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Color.fromRGBO(
                                                        255, 73, 15, 1),
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Text(
                                              'Senin, 06:30 - 15:00',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontFamily: 'poppins',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: 1,
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Color.fromRGBO(
                                                    255, 73, 15, 1),
                                              ),
                                              onPressed: null,
                                              child: Text(
                                                'Ijin',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'poppins',
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            child:
                                                Icon(FeatherIcons.chevronRight),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 218, 218, 218)),
                                    ),
                                  ),
                                ),
                              ],
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
}
