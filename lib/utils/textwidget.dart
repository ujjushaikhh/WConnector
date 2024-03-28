import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/font_constants.dart';

Widget getTextWidget(
        {required String title,
        Color textColor = blackcolor,
        double textFontSize = fontSize14,
        FontWeight? textFontWeight,
        TextAlign? textAlign,
        String? fontfamily = fontfamilybeVietnam,
        TextDecoration? textDecoration,
        FontStyle? textFontStyle,
        TextDirection? textDirection,
        double? height,
        int? maxLines}) =>
    Text(title,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
        textDirection: textDirection,
        style: TextStyle(
            height: height,
            fontSize: textFontSize,
            fontFamily: fontfamily,
            color: textColor,
            decoration: textDecoration,
            fontWeight: textFontWeight,
            fontStyle: textFontStyle));
