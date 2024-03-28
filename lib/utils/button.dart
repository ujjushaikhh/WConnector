import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/font_constants.dart';

class CustomizeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? buttonHeight;
  final double? buttonWidth;
  final Color color;
  final Color textcolor;
  final double textfontsize;
  final Color borderColor;
  final String textfontfamily;
  final FontWeight textfontweight;
  final double borderWidth;
  const CustomizeButton(
      {Key? key,
      this.color = bluecolor,
      required this.text,
      this.textfontsize = fontSize15,
      this.textfontweight = fontWeightBold,
      this.textfontfamily = fontfamilybeVietnam,
      this.borderWidth = 0.0,
      this.borderColor = Colors.transparent,
      this.textcolor = whitecolor,
      required this.onPressed,
      this.buttonHeight = 45,
      this.buttonWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth ?? MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(43.0),
                side: BorderSide(width: borderWidth, color: borderColor)),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textcolor,
            fontSize: textfontsize,
            fontFamily: textfontfamily,
            fontWeight: textfontweight,
          ),
        ),
      ),
    );
  }
}
