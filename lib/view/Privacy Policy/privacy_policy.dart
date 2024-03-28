import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/utils/dailog.dart';
import 'package:wconnectorconnectorflow/view/Privacy%20Policy/model/get_cms.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';

import 'package:flutter_html/flutter_html.dart';

class MyPrivacyPolicy extends StatefulWidget {
  const MyPrivacyPolicy({super.key});

  @override
  State<MyPrivacyPolicy> createState() => _MyPrivacyPolicyState();
}

class _MyPrivacyPolicyState extends State<MyPrivacyPolicy> {
  @override
  void initState() {
    super.initState();
    getcmsdataapi();
  }

  String? terms;
  Future<void> getcmsdataapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getcmsurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({"id": 1});
        debugPrint(request.body);
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getcmsdata = GetPrivacyPolicy.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getcmsdata.status == "1") {
            setState(() {
              terms = getcmsdata.cms!.cms!;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            debugPrint(' Error Message :- ${getcmsdata.message}');
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getcmsdata.message}',
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
        type: AlertType.info,
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
        body: SingleChildScrollView(
          child: Html(
            data: terms != null ? terms.toString() : '',
            style: {'body': Style(color: darkblack)},
          ),
        ));
  }
}
