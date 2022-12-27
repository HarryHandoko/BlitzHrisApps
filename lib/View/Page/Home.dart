import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tellme_alert/tellme_alert.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter/src/painting/_network_image_io.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class GroupModel {
  String text;
  int index;
  bool selected;

  GroupModel({required this.text, required this.index, required this.selected});
}

class _HomeState extends State<Home> {
  var name;
  var avatar;

  Future getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      avatar = prefs.getString('avatar');
    });
  }

  void initState() {
    super.initState();
    getProfile();
  }

  void httpJob(AnimationController controller) async {
    controller.forward();
    await Future.delayed(Duration(seconds: 5), () {});
    controller.reset();
  }

  bool loading = false;

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
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 60, bottom: 100),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: CircularProfileAvatar(
                                          '',
                                          child: Image.network(avatar!),
                                          borderColor:
                                              Color.fromRGBO(0, 186, 242, 1),
                                          borderWidth: 2,
                                          backgroundColor:
                                              Color.fromRGBO(0, 186, 242, 1),
                                          elevation: 5,
                                          radius: 20,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Welcome to Blitz',
                                                    style: TextStyle(
                                                        fontFamily: 'poppins',
                                                        color: Color.fromRGBO(
                                                            0, 186, 242, 1),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    name,
                                                    style: TextStyle(
                                                      fontFamily: 'poppins',
                                                      color: Color.fromRGBO(
                                                          0, 186, 242, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(150, 174, 227, 244),
                                    borderRadius: BorderRadius.circular(100),
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
                                          child: Text('Presensi hari ini'),
                                        ),
                                        Container(
                                          child: Text(
                                            '05:37',
                                            style: TextStyle(
                                                fontFamily: 'poppins',
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'Selasa, 23 November 2022',
                                            style: TextStyle(
                                                fontFamily: 'poppins',
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
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
                                          child: ProgressButton(
                                            color:
                                                Color.fromRGBO(0, 186, 242, 1),
                                            onPressed: (AnimationController
                                                controller) async {
                                              // httpJob(controller);
                                              setState(() {
                                                loading = !loading;
                                              });
                                              //Aligned
                                              TellMeAlert(
                                                context: context,
                                                padding:
                                                    const EdgeInsets.all(30),
                                                child: Container(
                                                  color: Colors.white,
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 14, right: 14),
                                                    child: Column(
                                                      children: [],
                                                    ),
                                                  ),
                                                ),
                                                borderRadius: 10,
                                                showCancelButton: false,
                                                showContent: false,
                                                showConfirmButton: false,
                                                showTitle: false,
                                                showIcon: false,
                                                onConfirm: () => print(
                                                    "Custom widget confirmed"),
                                              );
                                            },
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            strokeWidth: 2,
                                            child: Text(
                                              "Lakukan Presensi",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'poppins'),
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Lihat semuanya',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.bold,
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
                                            color:
                                                Color.fromRGBO(0, 186, 255, 1),
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
                                              fontWeight: FontWeight.bold,
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
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
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
                                            color:
                                                Color.fromRGBO(255, 38, 129, 1),
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
                                              fontWeight: FontWeight.bold,
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
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
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
                                            color:
                                                Color.fromRGBO(255, 183, 15, 1),
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
                                              fontWeight: FontWeight.bold,
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
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
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
                                            color:
                                                Color.fromRGBO(255, 73, 15, 1),
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
                                              fontWeight: FontWeight.bold,
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
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
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
