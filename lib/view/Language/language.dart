import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/utils/dailog.dart';
import 'package:wconnectorconnectorflow/utils/internetconnection.dart';
import 'package:wconnectorconnectorflow/utils/progressdialog.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/view/Intro/intro.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wconnectorconnectorflow/view/Language/model/change_language.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/textwidget.dart';
import '../../main.dart';

class MyLanguage extends StatefulWidget {
  final String? from;
  const MyLanguage({super.key, this.from});

  @override
  State<MyLanguage> createState() => _MyLanguageState();
}

class _MyLanguageState extends State<MyLanguage> {
  int? langid = 1;

  String token = getString('usertoken') == ""
      ? getString('commpanytoken')
      : getString('usertoken');
  // int? isEnglish = 1;

  @override
  void initState() {
    debugPrint('Token : $token');
    super.initState();
    if (widget.from == "settings") {
      setState(() {
        langid = getInt('lang_id');
      });
    }

    debugPrint('This is langid:- $langid');
  }

  Future<void> changelanguageapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var apiurl = changelanguageurl;
        debugPrint(apiurl);

        var headers = {
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({'lang_id': langid});

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var languagechangeModel = ChangeLanguageModel.fromJson(jsonResponse);
        debugPrint(' Body ${request.body}');
        debugPrint(responsed.body);

        ProgressDialogUtils.dismissProgressDialog();

        if (response.statusCode == 200) {
          ProgressDialogUtils.dismissProgressDialog();
          if (languagechangeModel.status == '1') {
            debugPrint(responsed.body);
            var languageid = languagechangeModel.data!.language!;
            debugPrint('Lang id $languageid');
            if (!mounted) return;
            MyApp.of(context).setLocale(MyApp.of(context).isEnglish
                ? const Locale('pl')
                : const Locale('en'));
            debugPrint('${languagechangeModel.message}');
            setInt('lang_id', languagechangeModel.data!.language!);
            Navigator.pop(context, true);
          } else {
            debugPrint('failed to load');
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          debugPrint('400');
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: 'Bad request',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          debugPrint('404');
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: 'Unauthorized ',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          debugPrint('401');
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: 'Bad request 404',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          debugPrint('500');
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: AppLocalizations.of(context)!.somethingwrong,
              onPressed: () {
                Navigator.pop(context);
              }).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint('$e');
        if (!mounted) return;
        connectorAlertDialogue(
            context: context,
            desc: AppLocalizations.of(context)!.somethingwrong,
            onPressed: () {
              Navigator.pop(context);
            }).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: widget.from == "settings"
          ? AppBar(
              elevation: 0.0,
              backgroundColor: whitecolor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: darkblack,
                  )),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.selectlanguage,
                  textFontSize: fontSize21,
                  textFontWeight: fontWeightRegular,
                  textColor: blackcolor),
            ),
            getEnglish(),
            const SizedBox(height: 21),
            getPolish(),
          ],
        ),
      ),
      bottomNavigationBar: getButton(),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 26.0, right: 26.0, bottom: 21.0),
      child: widget.from != "settings"
          ? CustomizeButton(
              text: AppLocalizations.of(context)!.continuetext,
              onPressed: () {
                setBool('selected', true);
                if (langid != 2) {
                  setInt('lang_id', 1);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyIntro(
                                langid: langid,
                              )));
                } else {
                  setInt('lang_id', 2);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyIntro(
                                langid: langid,
                              )));
                }
              })
          : CustomizeButton(
              text: AppLocalizations.of(context)!.save,
              onPressed: () {
                changelanguageapi();
              }),
    );
  }

  getEnglish() {
    return GestureDetector(
      onTap: () {
        // if (langid != 1) {
        setState(() {
          // isEnglish = 1;
          // setInt('lang_id', 1);
          langid = 1;
          widget.from != "settings"
              ? MyApp.of(context).setLocale(const Locale('en'))
              : null;
          debugPrint(' lang id:- $langid');
        });
        // }
      },
      child: Container(
        height: 185,
        margin: const EdgeInsets.only(left: 26, right: 26, top: 42),
        decoration: BoxDecoration(
          color: lightblue,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: bluecolor),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getTextWidget(
                title: 'English',
                textFontSize: fontSize25,
                textColor: darkblack,
                textFontWeight: fontWeightSemiBold,
              ),
              const Spacer(),
              Image.asset(
                langid == 1 ? ictick : icuntick,
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }

  getPolish() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // if (langid != 2) {
        setState(() {
          // isEnglish = 2;
          // setInt('lang_id', 2);
          langid = 2;
          widget.from != "settings"
              ? MyApp.of(context).setLocale(const Locale('pl'))
              : null;
        });
        // }
      },
      child: Container(
        height: 185,
        margin: const EdgeInsets.only(
          left: 26,
          right: 26,
        ),
        decoration: BoxDecoration(
          color: lightblue,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1, color: bluecolor),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getTextWidget(
                title: 'Polish',
                textFontSize: fontSize25,
                textColor: darkblack,
                textFontWeight: fontWeightSemiBold,
              ),
              const Spacer(),
              Image.asset(
                langid == 2 ? ictick : icuntick,
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }
}
