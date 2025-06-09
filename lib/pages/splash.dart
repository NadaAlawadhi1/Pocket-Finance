import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/colors/colors.dart';
import 'package:test_app/pages/home.dart';
import 'package:test_app/pages/on_boarding.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    Timer(Duration(seconds: 3), () {
      if (isFirstLaunch) {
        prefs.setBool('isFirstLaunch', false);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              child: Image.asset("assets/images/Logo1.png"),
            ),
            SizedBox(height: 20),
            Text(
              "Finance",
              style: TextStyle(
                fontSize: 24,
                color: kPrimaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
