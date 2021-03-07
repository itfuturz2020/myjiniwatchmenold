import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsocietystaff/Common/Constants.dart' as constant;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String MemberId = prefs.getString(constant.Session.MemberId);
      String Role = prefs.getString(constant.Session.Role);

      if (MemberId != null && MemberId != "") if (Role == "Watchmen") {
        Navigator.pushReplacementNamed(context, '/WatchmanDashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/Dashboard');
      }
      else {
        Navigator.pushReplacementNamed(context, '/Login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'images/background.png',
                fit: BoxFit.fill,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60, right: 40, left: 60),
                child: Image.asset(
                  'images/gini.png',
                  height: MediaQuery.of(context).size.height / 1.6,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/myginitext.png',
                  height: 100,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
