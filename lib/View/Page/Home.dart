import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:blitz_hris/View/Components/Notifications.dart';
import 'package:blitz_hris/View/Home/Hadir.dart';
import 'package:blitz_hris/View/Home/HasilAbsensi.dart';
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

  late ScrollController _controller;
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        //you can do anything here
      });
    }
  }

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

  var dataHistoryPre;
  List dataHistory = [];
  Future getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await http.get(
        Uri.parse(Uri.encodeFull(KEY.BASE_URL + 'v1/presence-history')),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${prefs.getString('token')}",
        });

    setState(() {
      var jsosn = json.decode(response.body);
      dataHistory = json.decode(response.body)['data'];
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
      avatar = jsosn['data']['avatar'];
    });

    return "Success";
  }

  void initState() {
    super.initState();
    getVerifToken().whenComplete(() {
      getHistory().whenComplete(() {
        getProfile().whenComplete(() {
          getAbsen().whenComplete(() {
            setState(() {
              if (verif == '200') {
                loading_s = true;
                _controller = ScrollController();
                _controller.addListener(_scrollListener);
              } else {
                setState(() async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
                            left: 20, right: 20, top: 60, bottom: 10),
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
                                              child: Image.network(avatar!,
                                                  fit: BoxFit.cover),
                                              borderColor: Color.fromRGBO(
                                                  0, 186, 242, 1),
                                              borderWidth: 2,
                                              backgroundColor: Color.fromRGBO(
                                                  0, 186, 242, 1),
                                              elevation: 5,
                                              radius: 18,
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
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder: (BuildContext
                                                          context,
                                                      Animation<double>
                                                          animation,
                                                      Animation<double>
                                                          secondaryAnimation) {
                                                    return Notifications();
                                                  },
                                                ),
                                              );
                                            },
                                            child: Badge(
                                              badgeColor: Colors.blue,
                                              badgeContent: Text('1',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              child: Icon(FeatherIcons.bell),
                                            ),
                                          ),
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
                                                  text:
                                                      "Jadwal kehadiran hari ini",
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
                                                      ' - ' +
                                                      presenceDatas[
                                                              'employee_out']
                                                          ['datetime']
                                                  : presenceDatas[
                                                              'employee_in'] !=
                                                          null
                                                      ? presenceDatas[
                                                                  'employee_in']
                                                              ['datetime'] +
                                                          ' | -- : --'
                                                      : presenceDatas[
                                                                  'employee_out'] !=
                                                              null
                                                          ? ' | -- : --' +
                                                              presenceDatas[
                                                                      'employee_out']
                                                                  ['datetime']
                                                          : '-- : --',
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
                                            width: 400,
                                            margin: EdgeInsets.only(
                                              top: 10,
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Container(
                                                padding: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      FeatherIcons.alertCircle,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      ' Selfie diperlukan pada saat absensi',
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )),
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 222, 226, 250),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                          ),
                                          Container(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 5),
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
                                                              return HasilAbsensi();
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
                                                            ? "Jam Masuk"
                                                            : "Jam Pulang",
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 241, 241, 241),
                                          offset: const Offset(
                                            5.0,
                                            5.0,
                                          ),
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0,
                                        ), //BoxShadow
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: const Offset(0.0, 0.0),
                                          blurRadius: 0.0,
                                          spreadRadius: 0.0,
                                        ),
                                      ],
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 228, 228, 228)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Kehadiran',
                                      style: TextStyle(
                                          fontFamily: 'poppins', fontSize: 15),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: //body
                                      ListView.builder(
                                          controller: _controller,
                                          shrinkWrap: true,
                                          itemCount: dataHistory.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 10),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: 70,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: dataHistory[index]['presence'] ==
                                                                            'Hadir'
                                                                        ? Color.fromRGBO(
                                                                            0,
                                                                            186,
                                                                            255,
                                                                            1)
                                                                        : dataHistory[index]['presence'] ==
                                                                                'Izin'
                                                                            ? Colors.orange
                                                                            : Colors.red,
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10),
                                                                        bottomLeft:
                                                                            Radius.circular(10)),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        "${dataHistory[index]['month']}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.blue,
                                                                          fontFamily:
                                                                              'poppins',
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${dataHistory[index]['tanggal']}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.blue,
                                                                          fontFamily:
                                                                              'poppins',
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 5,
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                    dataHistory[index]['presence'] ==
                                                                            'Hadir'
                                                                        ? '${dataHistory[index]['employee_in'] == null ? '--:--' : dataHistory[index]['employee_in']['datetime']} - ${dataHistory[index]['employee_out'] == null ? '--:--' : dataHistory[index]['employee_out']['datetime']}'
                                                                        : '',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'poppins',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: dataHistory[index]
                                                                            [
                                                                            'presence'] ==
                                                                        'Tidak Hadir'
                                                                    ? 4
                                                                    : 2,
                                                                child:
                                                                    Container(
                                                                  width: 1,
                                                                  child:
                                                                      TextButton(
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      backgroundColor: dataHistory[index]['presence'] ==
                                                                              'Hadir'
                                                                          ? Color.fromRGBO(
                                                                              0,
                                                                              186,
                                                                              255,
                                                                              1)
                                                                          : dataHistory[index]['presence'] == 'Izin'
                                                                              ? Colors.orange
                                                                              : Colors.red,
                                                                    ),
                                                                    onPressed:
                                                                        null,
                                                                    child: Text(
                                                                      "${dataHistory[index]['presence']}",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontFamily:
                                                                            'poppins',
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  child: Icon(
                                                                      FeatherIcons
                                                                          .chevronRight),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        241,
                                                                        241,
                                                                        241),
                                                                offset:
                                                                    const Offset(
                                                                  5.0,
                                                                  5.0,
                                                                ),
                                                                blurRadius:
                                                                    15.0,
                                                                spreadRadius:
                                                                    1.0,
                                                              ), //BoxShadow
                                                              BoxShadow(
                                                                color: Colors
                                                                    .white,
                                                                offset:
                                                                    const Offset(
                                                                        0.0,
                                                                        0.0),
                                                                blurRadius: 0.0,
                                                                spreadRadius:
                                                                    0.0,
                                                              ),
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        240,
                                                                        240,
                                                                        240)),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                )
                              ],
                            ),
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
