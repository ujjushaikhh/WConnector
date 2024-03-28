import 'package:flutter/material.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Bottom%20Tab/primarybottomtab.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/textwidget.dart';

class MyCongratulationScreen extends StatefulWidget {
  const MyCongratulationScreen({super.key});

  @override
  State<MyCongratulationScreen> createState() => _MyCongratulationScreenState();
}

class _MyCongratulationScreenState extends State<MyCongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      body: Padding(
        padding: const EdgeInsets.only(left: 31.0, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                iccongratulation,
                width: 213,
                height: 199,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.congratulations,
                  textFontSize: fontSize18,
                  textFontWeight: fontWeightSemiBold,
                  textColor: bluecolor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 11.0),
              child: getTextWidget(
                  textAlign: TextAlign.center,
                  title:
                      AppLocalizations.of(context)!.congratulationdescription,
                  textFontSize: fontSize13,
                  textFontWeight: fontWeightRegular,
                  textColor: greycolor),
            ),
            getButton(),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkerPrimaryBottomTab()),
                      (route) => false);
                },
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.gohome,
                    textColor: bluecolor,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightBold),
              ),
            )
          ],
        ),
      ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 27.0,
      ),
      child: CustomizeButton(
          buttonWidth: screenSize!.width / 3.5,
          text: AppLocalizations.of(context)!.ok,
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const WorkerPrimaryBottomTab()),
                (route) => false);
          }),
    );
  }
}
