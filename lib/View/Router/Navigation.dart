import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Page/Profile.dart';
import 'package:blitz_hris/View/Page/Riwayat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:bottom_bar/bottom_bar.dart';

class Navigation extends StatefulWidget {
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPage = 0;
  final _pageController = PageController();
  void initState() {
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
      }
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();
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
                bottomNavigationBar: BottomBar(
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                  selectedIndex: _currentPage,
                  onTap: (int index) {
                    setState(() => _currentPage = index);
                    changeTab(_currentPage);
                  },
                  items: <BottomBarItem>[
                    BottomBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home'),
                      activeColor: Colors.blue,
                      activeTitleColor: Colors.blue.shade600,
                    ),
                    BottomBarItem(
                      icon: Icon(Icons.bookmark),
                      title: Text('Riwayat'),
                      activeColor: Colors.blue,
                    ),
                    BottomBarItem(
                      icon: Icon(Icons.person),
                      title: Text('Profile'),
                      backgroundColorOpacity: 0.1,
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
