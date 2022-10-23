import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:lyf/src/global/variables.dart';
import 'drawer.dart';
import 'home_screen.dart';
import 'dart:io' show Platform;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Future.delayed(
          const Duration(seconds: 1),
        );
        if (loginState == true) {
          if (Platform.isAndroid) {
            // SystemNavigator.pop();
          }
          return false;
        } else {
          return true;
        }
      },
      child: Stack(
        children: const [
          SideDrawer(),
          // SplashScreen(),
          HomeScreen(),
        ],
      ),
    );
  }
}
