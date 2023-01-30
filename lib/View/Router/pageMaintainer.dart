import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotFoundPage extends StatefulWidget {
  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark),
        child: Stack(children: [
          Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 100, bottom: 25),
                        width: 175,
                        height: 175,
                        child: SvgPicture.asset(
                          "assets/image/empty.svg",
                          width: 170,
                        ),
                      ),
                      Center(
                        child: Text(
                          'Pemberitahuan',
                          style: TextStyle(
                              color: Color.fromARGB(255, 110, 110, 110),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.only(top: 8, left: 20, right: 20),
                        child: Center(
                          child: Text(
                            'Layanan yang Anda pilih saat ini sedang dalam proses pengembangan',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: 45,
                          padding: EdgeInsets.only(
                              top: 8, left: 5, right: 5, bottom: 8),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 186, 242, 1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Text(
                            'Kembali ke Beranda',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )),
                        ),
                      )
                    ]),
              ))
        ]),
      ),
    );
  }
}
