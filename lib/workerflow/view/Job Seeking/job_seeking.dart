import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Job%20Seeking/model/job_seeking_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/textwidget.dart';

class MyJobSeekingStatus extends StatefulWidget {
  const MyJobSeekingStatus({super.key});

  @override
  State<MyJobSeekingStatus> createState() => _MyJobSeekingStatusState();
}

class _MyJobSeekingStatusState extends State<MyJobSeekingStatus> {
  int selected = getInt('jobseeking');

  Future<dynamic> jobseekingapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint('Token:- ${getString('usertoken')}');
        var request = http.Request('POST', Uri.parse(userjobSeekinStatus));
        request.body =
            json.encode({"user_job_seekin_status": selected.toString()});

        debugPrint('url :- ${userjobSeekinStatus.toString()}');
        debugPrint('Body :- ${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var jobSeeking = JobSeekingModel.fromJson(jsonResponse);
        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (jobSeeking.status == '1') {
            setState(() {
              debugPrint('${jobSeeking.message}');
              Fluttertoast.showToast(
                      msg: ' Your job status updated Successfully')
                  .then((value) => {Navigator.pop(context)});
              setInt('jobseeking', int.parse(jobSeeking.jobSeekinStatus!));

              debugPrint('selected varaible :- ${getInt('jobseeking')}');
            });
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            connectorAlertDialogue(
                context: context,
                desc: '${jobSeeking.message}',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: 'There is no account with that user name & password !',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: "${jobSeeking.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: "${jobSeeking.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: "${jobSeeking.message}",
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
      bottomNavigationBar: getButton(),
      backgroundColor: whitecolor,
      appBar: AppBar(
        backgroundColor: whitecolor,
        centerTitle: true,
        elevation: 0.0,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.jobseekingstatus,
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          children: [getActivelyJobs(), getPassivelyJobs(), getNotLokingJobs()],
        ),
      ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.save,
          onPressed: () {
            jobseekingapi();
          }),
    );
  }

  getActivelyJobs() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selected = 0;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            selected == 0 ? icCheckRadio : icUncheckradio,
            height: 26.0,
            width: 26.0,
            fit: BoxFit.cover,
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTextWidget(
                      title:
                          AppLocalizations.of(context)!.activelylookingforjob,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightSemiBold,
                      textColor: darkblack),
                  const SizedBox(
                    height: 7.0,
                  ),
                  getTextWidget(
                      title: AppLocalizations.of(context)!
                          .activelylookingforjobdescription,
                      textFontSize: fontSize13,
                      maxLines: 2,
                      textFontWeight: fontWeightRegular,
                      textColor: lightblack),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Divider(
                    color: dividercolor,
                    thickness: 1.0,
                    height: 1.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getPassivelyJobs() {
    return Padding(
      padding: const EdgeInsets.only(top: 19.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            selected = 1;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              selected == 1 ? icCheckRadio : icUncheckradio,
              height: 26.0,
              width: 26.0,
              fit: BoxFit.cover,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTextWidget(
                        title: AppLocalizations.of(context)!
                            .passivelylookingforjobs,
                        textFontSize: fontSize15,
                        textFontWeight: fontWeightSemiBold,
                        textColor: darkblack),
                    const SizedBox(
                      height: 7.0,
                    ),
                    getTextWidget(
                        title: AppLocalizations.of(context)!
                            .passivelylookingforjobsdescription,
                        textFontSize: fontSize13,
                        maxLines: 2,
                        textFontWeight: fontWeightRegular,
                        textColor: lightblack),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Divider(
                      color: dividercolor,
                      thickness: 1.0,
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getNotLokingJobs() {
    return Padding(
      padding: const EdgeInsets.only(top: 19.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            selected = 2;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              selected == 2 ? icCheckRadio : icUncheckradio,
              height: 26.0,
              width: 26.0,
              fit: BoxFit.cover,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0, top: 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTextWidget(
                        title: AppLocalizations.of(context)!.notlookingforjobs,
                        textFontSize: fontSize15,
                        textFontWeight: fontWeightSemiBold,
                        textColor: darkblack),
                    const SizedBox(
                      height: 7.0,
                    ),
                    getTextWidget(
                        title: AppLocalizations.of(context)!
                            .notlookingforjobsdescription,
                        // 'I am not looking for a job right now. please don’t send me job invitations.',
                        textFontSize: fontSize13,
                        maxLines: 2,
                        textFontWeight: fontWeightRegular,
                        textColor: lightblack),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Divider(
                      color: dividercolor,
                      thickness: 1.0,
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
