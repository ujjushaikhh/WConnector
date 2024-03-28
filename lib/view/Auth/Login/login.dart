import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wconnectorconnectorflow/view/Auth/Login/model/login_model.dart';
import 'package:wconnectorconnectorflow/view/SelectCountry/select_country.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textwidget.dart';
import '../../Bottom Tab/primarybottomtab.dart';
import '../Forgot Password/forgot_password.dart';

class MyLogin extends StatefulWidget {
  final int? selectedcountryid;
  final int? langid;
  const MyLogin({
    super.key,
    this.langid,
    this.selectedcountryid,
  });

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
    super.initState();
    // debugPrint('${getInt('lang_id')}');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   languagechange();
    // });
  }

  // void languagechange() {
  //   if (getInt('lang_id') != 1) {
  //     MyApp.of(context).setLocale(
  //         MyApp.of(context).isEnglish ? const Locale('pl') : Locale(''));
  //   } else {
  //     MyApp.of(context).setLocale(
  //         MyApp.of(context).isEnglish ? const Locale('en') : Locale(''));
  //   }
  // }

  bool isChecked = false;
  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<dynamic> getloginapi() async {
    // final token = await NotificationSet().requestUserPermission();
    // debugPrint("Fcm Token $token");
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(loginurl));

        request.body = json.encode({
          "email": _emailcontroller.text,
          "password": _passcontroller.text,
          "lang_id": getInt('lang_id')
          // "device_type": getDeviceType(),
          // "device_id": token
        });

        debugPrint('url :- ${loginurl.toString()}');
        debugPrint('Body :- ${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var loginModel = LoginModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (loginModel.status == '1') {
            setString('comapnylogin', '1');
            setString('commpanytoken', loginModel.data!.token.toString());
            setString('companyid', loginModel.data!.id.toString());
            setString('companyemail', loginModel.data!.email!.toString());
            setString('companyname', loginModel.data!.name.toString());
            setString('companyimage', loginModel.data!.image.toString());
            setInt('lang_id', loginModel.data!.langId!);
            setState(() {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.loginsuccessfull);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyPrimaryBottomTab()),
                  (route) => false);
            });
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            connectorAlertDialogue(
                context: context,
                type: AlertType.info,
                desc: '${loginModel.message}',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: 'There is no account with that user name & password !',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: "${loginModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: "${loginModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: "${loginModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        if (!mounted) return;
        debugPrint('$e');
        connectorAlertDialogue(
            context: context,
            desc: 'Something went wrong',
            onPressed: () {
              Navigator.pop(context);
            }).show();
      }
    } else {
      if (!mounted) return;
      connectorAlertDialogue(
          context: context,
          type: AlertType.info,
          desc: 'Please check your internet connection',
          onPressed: () {
            Navigator.pop(context);
          }).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                getLogo(),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: getTextWidget(
                      title: AppLocalizations.of(context)!.login,
                      textFontSize: fontSize25,
                      textFontWeight: fontWeightMedium,
                      textColor: darkblack),
                ),
                getEmail(),
                getPassword(),
                getRemember(),
                getButton(),
                getSigninwith(),
                _getSocial()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _getBottomtext(),
    );
  }

  _getBottomtext() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.donthaveaccount,
              style: const TextStyle(
                color: darkblack,
                fontSize: fontSize14,
                fontFamily: fontfamilybeVietnam,
                fontWeight: fontWeightRegular,
              ),
            ),
            WidgetSpan(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MySelectCountry(
                              langid: widget.langid,
                              checkApplicant: 1,
                            )),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.register,
                  style: const TextStyle(
                    color: bluecolor,
                    fontSize: fontSize14,
                    fontFamily: fontfamilybeVietnam,
                    fontWeight: fontWeightRegular,
                  ),
                ),
              ),
            ),
            const TextSpan(
              text: '.',
              style: TextStyle(
                color: blackcolor,
                fontSize: fontSize14,
                fontFamily: fontfamilybeVietnam,
                fontWeight: fontWeightRegular,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  getSigninwith() {
    return Padding(
      padding: const EdgeInsets.only(top: 53),
      child: getTextWidget(
          title: AppLocalizations.of(context)!.orsignin,
          textFontSize: fontSize14,
          textFontWeight: fontWeightRegular,
          textColor: lightblack),
    );
  }

  _getSocial() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 70.0, right: 70.0, top: 18.0, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 64,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: bordercolor),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                )),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                icfacebook,
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            height: 48,
            width: 64,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: bordercolor),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: IconButton(
              onPressed: () {
                // _handleSignIn();
              },
              icon: Image.asset(
                icgoogle,
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          if (Platform.isIOS)
            Container(
              height: 48,
              width: 64,
              decoration: BoxDecoration(
                  // color: icPinkShade,
                  border: Border.all(width: 1, color: bordercolor),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: IconButton(
                onPressed: () async {
                  final credential = await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],
                  );

                  debugPrint('$credential');
                },
                icon: Image.asset(
                  icapple,
                  fit: BoxFit.cover,
                  height: 24,
                  width: 24,
                ),
              ),
            )
        ],
      ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.login,
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              getloginapi();
            }

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const MyPrimaryBottomTab()));
          }),
    );
  }

  getRemember() {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
                // fillColor: const MaterialStatePropertyAll<Color>(bluecolor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                side: const BorderSide(color: bordercolor),
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),
          ),
          getTextWidget(
              title: AppLocalizations.of(context)!.rememberme,
              textColor: darkblack,
              textFontSize: fontSize14,
              textFontWeight: fontWeightRegular),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyForgotPassword()));
                },
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.forgotpassword,
                    textColor: bluecolor,
                    fontfamily: fontfamilyBevietnam,
                    textFontSize: fontSize14,
                    textFontWeight: fontWeightSemiBold),
              ),
            ),
          )
        ],
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

  getPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: PrimaryTextFeild(
        controller: _passcontroller,
        hintText: AppLocalizations.of(context)!.password,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredpassword;
          } else if (value.length < 8) {
            return AppLocalizations.of(context)!.passwordlengthvalidation;
          }
          return null;
        },
        suffixIcon: icCloseeye,
        prefixIcon: icpassword,
        obscureText: true,
      ),
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
