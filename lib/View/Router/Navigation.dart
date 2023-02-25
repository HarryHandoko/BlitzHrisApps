import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:blitz_hris/View/Page/Berita.dart';
import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Page/Profile.dart';
import 'package:blitz_hris/View/Page/Riwayat.dart';
import 'package:blitz_hris/View/Router/pageMaintainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:bottom_bar/bottom_bar.dart';

class Navigation extends StatefulWidget {
  int? tab = 0;
  Navigation({this.tab = 0});
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPage = 0;
  final _pageController = PageController();
  void initState() {
    setState(() {
      _currentPage = this.widget.tab!;
      if (_currentPage == 0) {
        currentScreen = Home();
        currentTab = 0;
      } else if (_currentPage == 1) {
        currentScreen = Riwayat();
        currentTab = 1;
      } else if (_currentPage == 2) {
        currentScreen = Profile();
        currentTab = 2;
      } else if (_currentPage == 3) {
        currentScreen = Berita();
        currentTab = 3;
      }
    });
    super.initState();
  }

  void changeTab(int index) {
    setState(() {
      _currentPage = index;
      if (_currentPage == 0) {
        currentScreen = Home();
      } else if (_currentPage == 1) {
        currentScreen = Riwayat();
      } else if (_currentPage == 2) {
        currentScreen = Profile();
      } else if (_currentPage == 3) {
        currentScreen = Berita();
      }
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();
  int currentTab = 0;
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
            Container(
              child: Scaffold(
                  extendBody: true,
                  body: DoubleBack(
                    message: "Tekan lagi untuk keluar",
                    child: PageStorage(
                      child: currentScreen,
                      bucket: bucket,
                    ),
                  ),
                  // bottomNavigationBar: ResponsiveNavigationBar(
                  //   selectedIndex: _selectedIndex,
                  //   backgroundColor: Colors.black,
                  //   backgroundOpacity: 1,
                  //   onTabChange: changeTab,
                  //   showActiveButtonText: false,
                  //   inactiveIconColor: Colors.white,
                  //   activeIconColor: Colors.black,
                  //   textStyle: const TextStyle(
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  //   navigationBarButtons: const <NavigationBarButton>[
                  //     NavigationBarButton(
                  //         text: 'Beranda',
                  //         icon: FeatherIcons.home,
                  //         textColor: Colors.black,
                  //         backgroundColor: Colors.white),
                  //     NavigationBarButton(
                  //         text: 'Riwayat',
                  //         icon: FeatherIcons.bookmark,
                  //         backgroundColor: Colors.white),
                  //     NavigationBarButton(
                  //         text: 'Profile',
                  //         icon: FeatherIcons.user,
                  //         backgroundColor: Colors.white),
                  //   ],
                  // ),
                  bottomNavigationBar: BottomAppBar(
                      shape: CircularNotchedRectangle(),
                      notchMargin: 10,
                      child: Container(
                          height: 60,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      MaterialButton(
                                        minWidth: 40,
                                        onPressed: () {
                                          setState(() {
                                            currentScreen = Home();
                                            currentTab = 0;
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Icon(
                                                  Icons.home_outlined,
                                                  color: currentTab == 0
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey,
                                                )),
                                            Text(
                                              'Beranda',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: currentTab == 0
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: 40,
                                        onPressed: () {
                                          setState(() {
                                            currentScreen = Riwayat();
                                            currentTab = 1;
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Icon(
                                                  Icons.history,
                                                  color: currentTab == 1
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey,
                                                )),
                                            Text(
                                              'Riwayat',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: currentTab == 1
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: 40,
                                        onPressed: () {
                                          setState(() {
                                            currentScreen = NotFoundPage();
                                            currentTab = 2;
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Icon(
                                                  Icons.mail_outlined,
                                                  color: currentTab == 2
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey,
                                                )),
                                            Text(
                                              'Inboks',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: currentTab == 2
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: 40,
                                        onPressed: () {
                                          setState(() {
                                            currentScreen = Berita();
                                            currentTab = 3;
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Icon(
                                                  Icons.public,
                                                  color: currentTab == 3
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey,
                                                )),
                                            Text(
                                              'Berita',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: currentTab == 3
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                      MaterialButton(
                                        minWidth: 40,
                                        onPressed: () {
                                          setState(() {
                                            currentScreen = Profile();
                                            currentTab = 4;
                                          });
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Icon(
                                                  Icons.person,
                                                  color: currentTab == 4
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey,
                                                )),
                                            Text(
                                              'Profile',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: currentTab == 4
                                                      ? Color.fromRGBO(
                                                          0, 186, 242, 1)
                                                      : Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]))
                              ])))

                  //  BottomBar(
                  //   textStyle: TextStyle(fontWeight: FontWeight.bold),
                  //   selectedIndex: _currentPage,
                  //   onTap: (int index) {
                  //     setState(() => _currentPage = index);
                  //     changeTab(_currentPage);
                  //   },
                  //   items: <BottomBarItem>[
                  //     BottomBarItem(
                  //       icon: Icon(Icons.home),
                  //       title: Text('Home'),
                  //       activeColor: Color.fromRGBO(0, 186, 242, 1),
                  //       activeTitleColor: Color.fromRGBO(0, 186, 242, 1).shade600,
                  //     ),
                  //     BottomBarItem(
                  //       icon: Icon(Icons.bookmark),
                  //       title: Text('Riwayat'),
                  //       activeColor: Color.fromRGBO(0, 186, 242, 1),
                  //     ),
                  //     BottomBarItem(
                  //       icon: Icon(Icons.person),
                  //       title: Text('Profile'),
                  //       backgroundColorOpacity: 0.1,
                  //       activeColor: Color.fromRGBO(0, 186, 242, 1),
                  //     ),
                  //   ],
                  // ),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
