import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/view/Bottom%20Tab/primarybottomtab.dart';
import 'package:wconnectorconnectorflow/view/Intro/intro.dart';
import 'package:wconnectorconnectorflow/view/Job%20Type/jobtype.dart';
import 'package:wconnectorconnectorflow/view/Language/language.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Bottom%20Tab/primarybottomtab.dart';

import '../../../constants/image_constants.dart';
// import '../../utils/sharedprefs.dart';
// import '../Auth/Login/login.dart';
// import '../Bottom Tab/primarybottomtab.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    // _showSpalsh();
    debugPrint('user login ${getString('userlogin')}');
    debugPrint('company login ${getString('comapnylogin')}');
    if (getBool('selected') == true) {
      if (getBool('seen') == true) {
        if (getString('userlogin') == '1') {
          Timer(const Duration(seconds: 3), () async {
            await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const WorkerPrimaryBottomTab()),
                (route) => false);
          });
        } else if (getString('comapnylogin') == '1') {
          {
            Timer(const Duration(seconds: 3), () async {
              await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyPrimaryBottomTab()),
                  (route) => false);
            });
          }
        } else {
          Timer(const Duration(seconds: 3), () async {
            await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyJobType()),
                (route) => false);
          });
        }
      } else {
        Timer(const Duration(seconds: 3), () async {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyIntro()),
              (route) => false);
        });
      }
    } else {
      Timer(const Duration(seconds: 3), () async {
        await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyLanguage()),
            (route) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Image.asset(
        iclogo,
        height: 162,
        width: 211,
        fit: BoxFit.cover,
      )),
    );
  }

  // _showSpalsh() async {
  //   if (getBool('seen') == false) {
  //     Timer(const Duration(seconds: 3), () async {
  //       await Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => const MyIntro()),
  //           (route) => false);
  //     });
  //   } else {
  //     if (getBool('seen') == true) {
  //       if (getString('comapnylogin') == '1') {
  //         Timer(const Duration(seconds: 3), () async {
  //           await Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => const MyPrimaryBottomTab()),
  //               (route) => false);
  //         });
  //       } else if (getString('comapnylogin') == '0') {
  //         Timer(const Duration(seconds: 3), () async {
  //           await Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(builder: (context) => const MyLogin()),
  //               (route) => false);
  //         });
  //       }
  //     }
  //   }
  // }
}
