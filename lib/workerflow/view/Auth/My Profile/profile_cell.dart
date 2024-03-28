import 'package:flutter/material.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/textwidget.dart';

class MyProfileCell extends StatelessWidget {
  final void Function()? onTap;
  final String? iconImg;
  final String? optionName;

  const MyProfileCell({super.key, this.onTap, this.iconImg, this.optionName});

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                icBackgroundProfile,
              ))),
              child: IconButton(
                icon: Image.asset(
                  iconImg!,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
                onPressed: onTap,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 19.0, top: 11.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTextWidget(
                      title: optionName!,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightMedium,
                      textColor: darkblack),
                  // const SizedBox(
                  //   height: 16.0,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                        height: 1.0,
                        width: screenSize!.width - 77,
                        decoration: BoxDecoration(
                            border: Border.all(color: dividercolor, width: 1))),
                  ),
                  // const SizedBox(
                  //   height: 6.0,
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
