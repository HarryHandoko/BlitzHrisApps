import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:progress_indicator_button/progress_button.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void initState() {
    super.initState();
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
                      margin: EdgeInsets.only(left: 20, right: 20, top: 60),
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
                                          child: Image.asset(
                                              'assets/image/icon.png'),
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
                                                    'Blitz Driver',
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
                                              httpJob(controller);
                                              setState(() {
                                                loading = !loading;
                                              });
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
