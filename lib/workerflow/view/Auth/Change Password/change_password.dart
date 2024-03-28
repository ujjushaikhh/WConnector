import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/view/Change%20Password/model/change_passs_model.dart';

import 'package:http/http.dart' as http;

import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/button.dart';
import '../../../../utils/dailog.dart';
import '../../../../utils/internetconnection.dart';
import '../../../../utils/progressdialog.dart';
import '../../../../utils/sharedprefs.dart';
import '../../../../utils/textfeild.dart';
import '../../../../utils/textwidget.dart';

class WorkerChangePassword extends StatefulWidget {
  const WorkerChangePassword({super.key});

  @override
  State<WorkerChangePassword> createState() => _WorkerChangePasswordState();
}

class _WorkerChangePasswordState extends State<WorkerChangePassword> {
  final _oldpasscontroller = TextEditingController();
  final _newpasscontroller = TextEditingController();
  final _confirmpasscontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> changepasswordapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = changepasswordurl;

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('usertoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({});
        debugPrint('Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getChangepassword = ChangePasswordModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getChangepassword.status == '1') {
            setState(() {
              Fluttertoast.showToast(msg: ' ${getChangepassword.message}');
              Navigator.pop(context);
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load :-${getChangepassword.message}');

            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Unauthorized user',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request 400',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Internal server error',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint("$e");
        if (!mounted) return;
        connectorAlertDialogue(
          context: context,
          desc: '$e',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ).show();
      }
    } else {
      if (!mounted) return;
      connectorAlertDialogue(
        context: context,
        desc: 'Check Internet Connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

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
            title: AppLocalizations.of(context)!.changepasswordstring,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 34.0, bottom: 16.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    icChangePassword,
                    height: 189,
                    width: 213,
                    fit: BoxFit.cover,
                  ),
                ),
                getOldPassword(),
                getNewPassword(),
                getConfirmPassword(),
                // const Spacer(),
                // getButton()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: getButton(),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: CustomizeButton(
          text: 'Reset Password',
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              changepasswordapi();
            }
          }),
    );
  }

  getOldPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 34.0),
      child: PrimaryTextFeild(
        controller: _oldpasscontroller,
        hintText: AppLocalizations.of(context)!.currentpassowrd,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        suffixIcon: icCloseeye,
        prefixIcon: icpassword,
        obscureText: true,
      ),
    );
  }

  getNewPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: PrimaryTextFeild(
        controller: _newpasscontroller,
        hintText: AppLocalizations.of(context)!.newpassword,
        suffixIcon: icCloseeye,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        prefixIcon: icpassword,
        obscureText: true,
      ),
    );
  }

  getConfirmPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: PrimaryTextFeild(
        controller: _confirmpasscontroller,
        hintText: AppLocalizations.of(context)!.confirmpassword,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        prefixIcon: icpassword,
      ),
    );
  }
}
