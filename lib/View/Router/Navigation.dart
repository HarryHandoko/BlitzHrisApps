import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:blitz_hris/View/Page/Home.dart';
import 'package:blitz_hris/View/Page/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

class Navigation extends StatefulWidget {
  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        currentScreen = Home();
      } else if (_selectedIndex == 1) {
        currentScreen = Home();
      } else if (_selectedIndex == 2) {
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
              padding: EdgeInsets.only(bottom: 20),
              child: Scaffold(
                extendBody: true,
                body: DoubleBack(
                  message: "Tekan lagi untuk keluar",
                  child: PageStorage(
                    child: currentScreen,
                    bucket: bucket,
                  ),
                ),
                bottomNavigationBar: ResponsiveNavigationBar(
                  selectedIndex: _selectedIndex,
                  backgroundColor: Colors.black,
                  backgroundOpacity: 1,
                  onTabChange: changeTab,
                  showActiveButtonText: false,
                  inactiveIconColor: Colors.white,
                  activeIconColor: Colors.black,
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  navigationBarButtons: const <NavigationBarButton>[
                    NavigationBarButton(
                        text: 'Beranda',
                        icon: FeatherIcons.home,
                        textColor: Colors.black,
                        backgroundColor: Colors.white),
                    NavigationBarButton(
                        text: 'Riwayat',
                        icon: FeatherIcons.bookmark,
                        backgroundColor: Colors.white),
                    NavigationBarButton(
                        text: 'Profile',
                        icon: FeatherIcons.user,
                        backgroundColor: Colors.white),
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
