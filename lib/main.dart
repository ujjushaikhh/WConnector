import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:wconnectorconnectorflow/constants/color_constants.dart';
import 'package:wconnectorconnectorflow/constants/font_constants.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/view/splash/splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBy9gjv0jTik3meEdp9lCusQe8lawDg0kM",
            appId: "1:655581197427:ios:3ee0d204c05613b028e606",
            messagingSenderId: "655581197427",
            projectId: "wconnector-2e79f"));
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  bool isEnglish = true;
  Locale _locale = const Locale('en');

  void setLocale(Locale value) async {
    isEnglish = value == const Locale('en', '');
    setBool('isEnglish', isEnglish);
    setState(() {
      _locale = value;
    });
  }

  getLangFromPreferences() async {
    isEnglish = getBool('isEnglish') ?? true;
    setLocale(isEnglish ? const Locale('en', '') : const Locale('pl', ''));
    debugPrint("Setting Langaue $_locale");
    debugPrint("prefs.getBool('isEnglish') ${getBool('isEnglish')}");
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     // statusBarColor: Color.fromARGB(0, 145, 98, 98),
    //     statusBarBrightness: Brightness.dark,
    //   ),
    // );

    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: _locale,
      //const Locale("en"),
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      //title: AppLocalizations.of(context)!.login,

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: fontfamilybeVietnam,
        appBarTheme: const AppBarTheme(
          backgroundColor: whitecolor,
          elevation: 0.0,
        ),
      ),
      home: const MySplash(),
    );
  }
}
