import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Change%20Password/change_password.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/textwidget.dart';
import '../../../../view/Language/language.dart';

class MyWorkerSettings extends StatefulWidget {
  const MyWorkerSettings({super.key});

  @override
  State<MyWorkerSettings> createState() => _MyWorkerSettingsState();
}

class _MyWorkerSettingsState extends State<MyWorkerSettings> {
  bool? isSwitchEmail = false;
  bool? isSwitchSMS = false;
  bool? isCoverup = false;

  int? langid = getInt('lang_id');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        backgroundColor: whitecolor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: darkblack,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.settingsstring,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTextWidget(
                    title: AppLocalizations.of(context)!.emailnotification,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightMedium,
                    textColor: darkblack),
                _getEmailButton(),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Divider(
            color: dividercolor,
            thickness: 1.0,
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: getTextWidget(
                      title: AppLocalizations.of(context)!.smsnotification,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightMedium,
                      textColor: darkblack),
                ),
                _getSMSButton(),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Divider(
            color: dividercolor,
            thickness: 1.0,
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 11.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyLanguage(
                              from: "settings",
                            ))).whenComplete(() {
                  setState(() {
                    langid = getInt('lang_id');
                  });
                });
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: getTextWidget(
                        title: AppLocalizations.of(context)!.language,
                        textFontSize: fontSize15,
                        textFontWeight: fontWeightMedium,
                        textColor: darkblack),
                  ),
                  const Spacer(),
                  getTextWidget(
                      title: langid == 1 ? 'English' : 'Polish',
                      textColor: bluecolor,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightSemiBold),
                  const SizedBox(
                    width: 9.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Image.asset(
                      icArrowright,
                      height: 24.0,
                      width: 24.0,
                      fit: BoxFit.cover,
                      color: darkblack,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Divider(
            color: dividercolor,
            thickness: 1.0,
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 11.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WorkerChangePassword()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: getTextWidget(
                        title:
                            AppLocalizations.of(context)!.changepasswordstring,
                        textFontSize: fontSize15,
                        textFontWeight: fontWeightMedium,
                        textColor: darkblack),
                  ),
                  Image.asset(
                    icArrowright,
                    height: 24.0,
                    width: 24.0,
                    fit: BoxFit.cover,
                    color: darkblack,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Divider(
            color: dividercolor,
            thickness: 1.0,
            height: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 11.0, left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: getTextWidget(
                      title: AppLocalizations.of(context)!.coverup,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightMedium,
                      textColor: darkblack),
                ),
                _getCoverButton()
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          const Divider(
            color: dividercolor,
            thickness: 1.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }

  _getEmailButton() {
    return Transform.scale(
      scale: 0.9,
      child: CupertinoSwitch(
        value: isSwitchEmail!,
        activeColor: bluecolor,
        trackColor: trackcolor,
        onChanged: (value) {
          if (isSwitchEmail == true) {
            setState(() {
              isSwitchEmail = false;
              // setInt('getNotification', 0);
              // settingapi(0);
            });
          } else {
            setState(() {
              isSwitchEmail = true;
              // setInt('getNotification', 1);
              // settingapi(1);
            });
          }
        },
      ),
    );
  }

  _getSMSButton() {
    return Transform.scale(
      scale: 0.9,
      child: CupertinoSwitch(
        value: isSwitchSMS!,
        activeColor: bluecolor,
        trackColor: trackcolor,
        onChanged: (value) {
          if (isSwitchSMS == true) {
            setState(() {
              isSwitchSMS = false;
              // setInt('getNotification', 0);
              // settingapi(0);
            });
          } else {
            setState(() {
              isSwitchSMS = true;
              // setInt('getNotification', 1);
              // settingapi(1);
            });
          }
        },
      ),
    );
  }

  _getCoverButton() {
    return Transform.scale(
      scale: 0.9,
      child: CupertinoSwitch(
        value: isCoverup!,
        activeColor: bluecolor,
        trackColor: trackcolor,
        onChanged: (value) {
          if (isCoverup == true) {
            setState(() {
              isCoverup = false;
              // setInt('getNotification', 0);
              // settingapi(0);
            });
          } else {
            setState(() {
              isCoverup = true;
              // setInt('getNotification', 1);
              // settingapi(1);
            });
          }
        },
      ),
    );
  }
}
