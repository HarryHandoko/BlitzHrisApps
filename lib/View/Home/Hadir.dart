import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blitz_hris/View/Auth/Auth.dart';
import 'package:blitz_hris/View/Home/FotoSelfie.dart';
import 'package:blitz_hris/View/Home/PresensiSuccess.dart';
import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Router/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:tellme_alert/tellme_alert.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:commons/alert_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../Config/Api.dart';
import 'package:shimmer/shimmer.dart';

class Hadir extends StatefulWidget {
  @override
  State<Hadir> createState() => _HadirState();
}

class _HadirState extends State<Hadir> {
  String? verif;
  String? imageAbsen;
  bool loading_s = false;
  bool _isLoading = false;
  String? _currentAddress;
  String? _long;
  String? _lat;
  String? presence;
  Position? _currentPosition;
  var dt = DateTime.now();

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;

  Future getProfile() async {
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      imageAbsen = prefs1.getString('imageAbsen');
    });
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

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition().then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _long = '${_currentPosition!.longitude}';
        _lat = '${_currentPosition!.latitude}';
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            zoom: 17),
      ),
    );
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
      presenceDatas = json.decode(response.body)['data'];
    });

    return "Success";
  }

  void initState() {
    super.initState();
    jam_masuk.text = dt.hour.toString() + ":" + dt.minute.toString();
    getVerifToken().whenComplete(() {
      _getCurrentPosition().whenComplete(() {
        getProfile().whenComplete(() {
          getAbsen().whenComplete(() {
            setState(() {
              if (verif == '200') {
                loading_s = true;
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
                                        'Presensi',
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
                              padding: EdgeInsets.all(0),
                              height: 200,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: _initialcameraposition),
                                mapType: MapType.normal,
                                onMapCreated: _onMapCreated,
                                myLocationEnabled: true,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  left: 30, right: 30, top: 30, bottom: 10),
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
                                      size: 20,
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
                              margin:
                                  EdgeInsets.only(top: 0, left: 20, right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      presenceDatas['employee_in'] == null
                                          ? 'Jam Masuk'
                                          : 'Jam Pulang',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 240, 240, 240),
                                    ),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: jam_masuk,
                                      onChanged: (vale) {},
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          FeatherIcons.clock,
                                          size: 20,
                                          color: Color.fromRGBO(0, 186, 242, 1),
                                        ),
                                        hintText: 'Jam Masuk',
                                        hintStyle: TextStyle(
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 209, 209, 209)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 10),
                              child: Text(
                                'Upload foto selfie',
                                textAlign: TextAlign.start,
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return Navigation();
                                        },
                                      ),
                                    );
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return Hadir();
                                        },
                                      ),
                                    );
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return FotoSelfie();
                                        },
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: SizedBox(
                                          height: 140,
                                          width: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: imageAbsen == null
                                                ? Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 0, left: 20),
                                                    width: 120,
                                                    child: const Image(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      image: AssetImage(
                                                          'assets/image/no-image.png'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        top: 0, left: 20),
                                                    width: 120,
                                                    child: Image.file(File(
                                                        '${imageAbsen!.replaceAll("File: ", "").replaceAll("'", "")}')),
                                                  ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            presenceDatas['employee_in'] == null
                                ? Container(
                                    margin: EdgeInsets.all(20),
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: ProgressButton(
                                      color: Color.fromRGBO(0, 186, 242, 1),
                                      onPressed: (AnimationController
                                          controller) async {
                                        _isLoading = true;
                                        upload(File(
                                            '${imageAbsen!.replaceAll("File: ", "").replaceAll("'", "")}'));
                                        setState(() {
                                          loading = !loading;
                                        });
                                      },
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      strokeWidth: 2,
                                      child: Text(
                                        "Kirim",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'poppins'),
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.all(20),
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    child: ProgressButton(
                                      color: Color.fromRGBO(0, 186, 242, 1),
                                      onPressed: (AnimationController
                                          controller) async {
                                        _isLoading = true;
                                        out(File(
                                            '${imageAbsen!.replaceAll("File: ", "").replaceAll("'", "")}'));
                                        setState(() {
                                          loading = !loading;
                                        });
                                      },
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      strokeWidth: 2,
                                      child: Text(
                                        "Kirim",
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

  TextEditingController jam_masuk = TextEditingController();
  TextEditingController keterangan = TextEditingController();

  // Future attandance() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     String myUrl = KEY.BASE_URL + "v1/presence";
  //     var result = await http.post(Uri.parse(myUrl), headers: {
  //       'Accept': 'application/json',
  //       "Authorization": "Bearer ${prefs.getString('token')}",
  //     }, body: {
  //       'image': imageAbsen!.replaceAll("File: ", "").replaceAll("'", ""),
  //       'longitude': _long,
  //       'latitude': _lat,
  //     });
  //     var jsonObject = json.decode(result.body);
  //     if (jsonObject['code'] == 200) {
  //       await Future.delayed(Duration(seconds: 3), () {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       });
  //     } else {}
  //   } on SocketException catch (_) {
  //     setState(() {
  //       _isLoading = false;
  //       SweetAlert.show(
  //         context,
  //         subtitle: "No Internet Connection!",
  //         style: SweetAlertStyle.error,
  //       );
  //     });
  //   } on TimeoutException {
  //     setState(() {
  //       _isLoading = false;
  //       SweetAlert.show(
  //         context,
  //         subtitle: "Connection Timeout!",
  //         style: SweetAlertStyle.error,
  //       );
  //     });
  //   }
  // }

  upload(File img) async {
    final prefs2 = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer ${prefs2.getString('token')}",
    };
    var uri = Uri.parse(KEY.BASE_URL + "v1/presence");
    var length = await img.length();
    print(img);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['longitude'] = "${_long}"
      ..fields['latitude'] = "${_lat}"
      // ..fields['address'] = "${_currentAddress}"
      ..files.add(
        http.MultipartFile('image', img.openRead(0), length,
            filename: 'test.png'),
      );
    var respons = await http.Response.fromStream(await request.send());
    var jsonObject = json.decode(respons.body);
    print(jsonObject);

    if (respons.statusCode == 200) {
      _isLoading = false;
      setState(() async {
        final preff1 = await SharedPreferences.getInstance();
        preff1.remove('imageAbsen');
        setState(() {
          Alert(
            context: context,
            type: AlertType.success,
            desc: "Presensi Telah Berhasil Dikirim!",
            buttons: [
              DialogButton(
                color: Colors.blue,
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Navigation(),
                    ),
                    (route) => false),
                width: 120,
              )
            ],
          ).show();
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

  out(File img) async {
    final prefs2 = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer ${prefs2.getString('token')}",
    };
    var uri = Uri.parse(KEY.BASE_URL + "v1/presence");
    var length = await img.length();
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields['longitude'] = "${_long}"
      ..fields['latitude'] = "${_lat}"
      // ..fields['address'] = "${_currentAddress}"
      ..files.add(
        http.MultipartFile('image', img.openRead(0), length,
            filename: 'test.png'),
      );
    var respons = await http.Response.fromStream(await request.send());
    var jsonObject = json.decode(respons.body);

    if (respons.statusCode == 200) {
      _isLoading = false;
      setState(() async {
        final preff1 = await SharedPreferences.getInstance();
        preff1.remove('imageAbsen');
        setState(() {
          Alert(
            context: context,
            type: AlertType.success,
            desc: "Presensi Telah Berhasil Dikirim!",
            buttons: [
              DialogButton(
                color: Colors.blue,
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PresensiSuccess(),
                    ),
                    (route) => false),
                width: 120,
              )
            ],
          ).show();
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
