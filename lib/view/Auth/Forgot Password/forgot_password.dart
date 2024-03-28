import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textwidget.dart';

class MyForgotPassword extends StatefulWidget {
  const MyForgotPassword({super.key});

  @override
  State<MyForgotPassword> createState() => _MyForgotPasswordState();
}

class _MyForgotPasswordState extends State<MyForgotPassword> {
  final _emailcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Form(
          key: _formkey,
          child: Column(children: [
            getLogo(),
            getForgot(),
            getDescription(),
            getEmail(),
            getButton()
          ]),
        ),
      ),
    );
  }

  getEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 26.0),
      child: PrimaryTextFeild(
        controller: _emailcontroller,
        hintText: AppLocalizations.of(context)!.email,
        validation: (value) {
          const pattern =
              r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
          final regExp = RegExp(pattern);

          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredemail;
          } else if (!regExp.hasMatch(value)) {
            return AppLocalizations.of(context)!.requiredvalidemail;
          }

          return null;
        },
        keyboardType: TextInputType.emailAddress,
        prefixIcon: icemail,
      ),
    );
  }

  getDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 13, right: 13.0),
      child: getTextWidget(
          textAlign: TextAlign.center,
          title: AppLocalizations.of(context)!.forgetmessage,
          textFontSize: fontSize13,
          textFontWeight: fontWeightRegular,
          textColor: lightblack),
    );
  }

  getForgot() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: getTextWidget(
          textAlign: TextAlign.center,
          title: AppLocalizations.of(context)!.forgettitle,
          textFontSize: fontSize25,
          textFontWeight: fontWeightMedium,
          textColor: darkblack),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.submit,
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              Navigator.pop(context);
            }
          }),
    );
  }

  getLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 97.0),
        child: Container(
          height: 140,
          width: 181,
          decoration: const BoxDecoration(color: whitecolor),
          child: Image.asset(
            iclogo,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
