import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/textwidget.dart';

class MyEWallet extends StatefulWidget {
  const MyEWallet({super.key});

  @override
  State<MyEWallet> createState() => _MyEWalletState();
}

class _MyEWalletState extends State<MyEWallet> {
  final List ewallet = [
    {'name': 'Accounting & Finance'},
    {'name': 'Architecture and Engineering'},
    {'name': 'Management and Consultancy'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              icEditProfile,
              height: 24.0,
              width: 24.0,
              color: darkblack,
            ),
          )
        ],
        backgroundColor: whitecolor,
        centerTitle: true,
        elevation: 0.0,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.myewallet,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkblack,
              size: 24.0,
            )),
      ),
      body: ListView.builder(
        itemCount: ewallet.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: Container(
              height: 45.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(43),
                  border: Border.all(width: 1, color: boxborderpro)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 10.0, top: 13, bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getTextWidget(
                        title: ewallet[index]['name'],
                        textFontSize: fontSize14,
                        textFontWeight: fontWeightRegular,
                        textColor: darkblack),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ewallet.removeAt(index);
                        });
                      },
                      child: Image.asset(
                        icClose,
                        height: 24.0,
                        width: 24.0,
                        fit: BoxFit.cover,
                        color: greycolor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
