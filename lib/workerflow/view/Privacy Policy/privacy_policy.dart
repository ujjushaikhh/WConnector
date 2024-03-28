import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../utils/textwidget.dart';

class MyPrivacyPolicy extends StatelessWidget {
  const MyPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        centerTitle: true,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.privacy,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
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
      ),
      body: Center(
        child: getTextWidget(
            title: AppLocalizations.of(context)!.privacy,
            textFontSize: fontSize20,
            textFontWeight: fontWeightSemiBold,
            textColor: darkblack),
      ),
    );
  }
}
