import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constants.dart';
import '../constants/font_constants.dart';
import '../constants/image_constants.dart';

class PrimaryTextFeild extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? prefixIcon, suffixIcon;

  final bool filled;
  final bool readonly;
  final AutovalidateMode autoValidate;
  final String? Function(String?)? validation;
  final Color fillColor;
  final Color borderColor;
  final Color prefixiconcolor;
  final Color suffixiconcolor;
  final bool obscureText;
  final String? image;
  final List<TextInputFormatter>? inputFormatters;
  final bool enable;
  final Widget? suffix;
  final String? anysuffixicon;
  // final String suffixText;
  // final TextStyle? suffixtextstyle;
  final Function(void)? onfeildSubmitted;

  final Function(String)? onChange;
  final Color hintColor;

  final Color textstyle;
  final bool autoFocus;
  final double fontSize;
  final FontWeight fontWeight;

  const PrimaryTextFeild(
      {Key? key,
      this.suffix,
      this.controller,
      this.hintText,
      this.anysuffixicon = '',
      this.readonly = false,
      this.inputFormatters,
      this.keyboardType,
      this.onfeildSubmitted,
      this.autoValidate = AutovalidateMode.onUserInteraction,
      // this.suffixText = '',
      this.prefixIcon,
      this.autoFocus = false,
      // this.suffixtextstyle,
      this.suffixiconcolor = blackcolor,
      this.textstyle = blackcolor,
      this.prefixiconcolor = blackcolor,
      this.onChange,
      this.hintColor = hintcolor,
      // this.autoValidate = AutovalidateMode.onUserInteraction;
      this.fontSize = fontSize14,
      this.fontWeight = fontWeightRegular,
      this.enable = true,
      this.filled = true,
      this.fillColor = whitecolor,
      this.borderColor = bordercolor,
      this.suffixIcon,
      this.validation,
      this.image,
      this.obscureText = false})
      : super(key: key);

  @override
  State<PrimaryTextFeild> createState() => _PrimaryTextFeildState();
}

class _PrimaryTextFeildState extends State<PrimaryTextFeild> {
  bool _obscureText = true;

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _oncrosspressed() {
    setState(() {
      widget.controller!.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      autovalidateMode: widget.autoValidate,
      validator: widget.validation,
      controller: widget.controller,
      readOnly: widget.readonly,
      onChanged: widget.onChange,
      autofocus: widget.autoFocus,
      inputFormatters: widget.inputFormatters,
      onFieldSubmitted: widget.onfeildSubmitted,
      keyboardType: widget.keyboardType,
      // autofocus: true,
      obscureText: widget.obscureText ? _obscureText : false,
      style: TextStyle(
          color: widget.textstyle,
          fontFamily: fontfamilybeVietnam,
          fontWeight: fontWeightMedium,
          fontSize: fontSize14),
      decoration: InputDecoration(
        // suffixText: widget.suffixText,
        // suffixStyle: widget.suffixtextstyle,
        suffix: widget.suffix,

        contentPadding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),

        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintColor,
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          fontFamily: fontfamilybeVietnam,
        ),
        fillColor: widget.fillColor,
        filled: widget.filled,
        enabled: widget.enable,
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      widget.prefixIcon!,
                      color: widget.prefixiconcolor,
                    ),
                  ),
                ),
              )
            : null,
        suffixIcon: widget.suffixIcon != null
            ? widget.suffixIcon != icClose &&
                    widget.suffixIcon != icCalendar &&
                    widget.suffixIcon != ictime &&
                    widget.suffixIcon != icEditProfile
                ? GestureDetector(
                    onTap: _togglePassword,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          _obscureText ? icCloseeye : icOpeneye,
                          color: widget.suffixiconcolor,
                          height: 24.0,
                          width: 24.0,
                        ),
                      ),
                    ),
                  )
                : widget.suffixIcon != icCalendar &&
                        widget.suffixIcon != ictime &&
                        widget.suffixIcon != icEditProfile
                    ? GestureDetector(
                        onTap: _oncrosspressed,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              icClose,
                              color: widget.suffixiconcolor,
                              height: 24.0,
                              width: 24.0,
                            ),
                          ),
                        ),
                      )
                    : widget.suffixIcon != ictime &&
                            widget.suffixIcon != icEditProfile
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                icCalendar,
                                color: widget.suffixiconcolor,
                                height: 24.0,
                                width: 24.0,
                              ),
                            ),
                          )
                        : widget.suffixIcon != icEditProfile
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.asset(
                                    ictime,
                                    color: widget.suffixiconcolor,
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.asset(
                                    icEditProfile,
                                    color: widget.suffixiconcolor,
                                    height: 24.0,
                                    width: 24.0,
                                  ),
                                ),
                              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(43.0),
          borderSide: BorderSide(
            width: 1.0,
            color: widget.borderColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(43.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(43.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(43.0),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(43.0),
          borderSide: const BorderSide(color: bordererror),
        ),
      ),
    );
  }
}
