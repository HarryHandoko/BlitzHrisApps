import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/Auth.dart';
import 'package:blitz_hris/View/Home/Foto.dart';
import 'package:blitz_hris/View/Home/Hadir.dart';
import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Router/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
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

class HasilAbsensi extends StatefulWidget {
  @override
  State<HasilAbsensi> createState() => _HasilAbsensiState();
}

class _HasilAbsensiState extends State<HasilAbsensi> {
  String? verif;
  String? name;
  String? token;
  String? email;
  bool loading_s = false;
  bool _isLoading = false;
  String? _firstMenu = 'jam_masuk';
  String? _currentAddress;
  Position? _currentPosition;
  var dt = DateTime.now();
  var tanggal = DateFormat("EEEEE, dd MMMM yyyy").format(DateTime.now());
  String? _long;
  String? _lat;

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

  var presenceDatas;
  var presenceData;
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

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(long, lat) async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await placemarkFromCoordinates(double.parse(lat), double.parse(long))
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void initState() {
    super.initState();
    getVerifToken().whenComplete(() {
      getAbsen().whenComplete(() {
        _getAddressFromLatLng(presenceDatas['employee_in']['longitude'],
                presenceDatas['employee_in']['latitude'])
            .whenComplete(() {
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
                                        'Riwayat Kehadiran',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Row(
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
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'poppins'),
                                                        )
                                                      : TextSpan(
                                                          text: "",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
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
                                                    ? presenceDatas[
                                                                'employee_in'][
                                                            'datetime'] +
                                                        ' - ' +
                                                        presenceDatas[
                                                                'employee_out'][
                                                            'datetime']
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 6,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      height: 70,
                                                      child: ProgressButton(
                                                        color: _firstMenu ==
                                                                'jam_masuk'
                                                            ? Color.fromRGBO(
                                                                0, 186, 242, 1)
                                                            : Colors.grey,
                                                        onPressed:
                                                            (AnimationController
                                                                controller) async {
                                                          // httpJob(controller);
                                                          setState(() {
                                                            _firstMenu =
                                                                'jam_masuk';
                                                            _getAddressFromLatLng(
                                                                presenceDatas[
                                                                        'employee_in']
                                                                    [
                                                                    'longitude'],
                                                                presenceDatas[
                                                                        'employee_in']
                                                                    [
                                                                    'latitude']);
                                                          });
                                                        },
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        strokeWidth: 2,
                                                        child: Text(
                                                          "Jam Masuk",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'poppins'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 6,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      height: 70,
                                                      child: ProgressButton(
                                                        color: _firstMenu ==
                                                                'jam_pulang'
                                                            ? Color.fromRGBO(
                                                                0, 186, 242, 1)
                                                            : Colors.grey,
                                                        onPressed:
                                                            (AnimationController
                                                                controller) async {
                                                          // httpJob(controller);
                                                          setState(() {
                                                            _firstMenu =
                                                                'jam_pulang';
                                                            _getAddressFromLatLng(
                                                                presenceDatas[
                                                                        'employee_out']
                                                                    [
                                                                    'longitude'],
                                                                presenceDatas[
                                                                        'employee_out']
                                                                    [
                                                                    'latitude']);
                                                          });
                                                        },
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        strokeWidth: 2,
                                                        child: Text(
                                                          "Jam Pulang",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'poppins'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                            ),
                            Container(
                              padding: EdgeInsets.all(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  height: 450,
                                  fit: BoxFit.fill,
                                  image: NetworkImage(_firstMenu == 'jam_masuk'
                                      ? presenceDatas['employee_in']['image']
                                      : presenceDatas['employee_out']['image']),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              child: Text(
                                'Lokasi Anda',
                                textAlign: TextAlign.start,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  borderRadius: BorderRadius.circular(6)),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(
                                      FeatherIcons.mapPin,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      _currentAddress!,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  left: 30, right: 30, top: 10, bottom: 10),
                              child: Text(
                                _firstMenu == 'jam_masuk'
                                    ? 'Jam Masuk'
                                    : 'Jam Pulang',
                                textAlign: TextAlign.start,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: 6, right: 6, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  borderRadius: BorderRadius.circular(6)),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(
                                      FeatherIcons.clock,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Text(
                                      _firstMenu == 'jam_masuk'
                                          ? presenceDatas['employee_in']
                                                  ['datetime']
                                              .toString()
                                          : presenceDatas['employee_out']
                                                  ['datetime']
                                              .toString(),
                                      style: TextStyle(fontSize: 12),
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

  TextEditingController jam_masuk = TextEditingController();
}
