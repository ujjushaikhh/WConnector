import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Job%20Details/model/saved_job_model.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textwidget.dart';
import '../Job Details/job_detail.dart';

class MyJobStatus extends StatefulWidget {
  final int? jobId;
  final int? userId;
  final int? daysAgo;
  final int? vacancy;
  final bool? isSaved;
  final String? companystatus;
  final String? userjobstatus;
  final String? companyName;
  final String? companyImage;
  final String? companyAddress;
  final String? jobName;
  final String? workType;
  final String? salary;
  final String? salaryType;

  const MyJobStatus(
      {super.key,
      this.jobId,
      this.userId,
      this.userjobstatus,
      this.companystatus,
      this.companyName,
      this.companyImage,
      this.isSaved,
      this.companyAddress,
      this.jobName,
      this.daysAgo,
      this.vacancy,
      this.workType,
      this.salary,
      this.salaryType});

  @override
  State<MyJobStatus> createState() => _MyJobStatusState();
}

class _MyJobStatusState extends State<MyJobStatus> {
  @override
  void initState() {
    super.initState();
    if (widget.isSaved == true) {
      isSaved = 1;
    } else {
      isSaved = 0;
    }
  }

  int? isSaved;

  Future<void> postSavedapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$addfavjoburl/${widget.jobId}';

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint('Token ${getString('usertoken')}');
        debugPrint('url $apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));

        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getJobDetail = PostSaveJobModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getJobDetail.status == '1') {
            setState(() {
              isSaved = getJobDetail.isLike!;

              debugPrint(' IsSaved :-$isSaved');
              // getJobDetailapi();
            });
            debugPrint('is it success');
          } else {
            // requirements = [];
            // isload = false;
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Unauthorize',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad Request',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad Request 400',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Internal Server Error',
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
        centerTitle: true,
        elevation: 0.0,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.applyjob,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: screenSize!.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border:
                              Border.all(width: 1, color: lightbordercolorpro),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.companyImage!,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 116.0,
                              width: 116.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 116.0,
                                width: 116.0,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: 24.0,
                    decoration: BoxDecoration(
                        color: widget.companystatus! == 'Open'
                            ? greencolor
                            : lightgreypromax,
                        borderRadius: BorderRadius.circular(33)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, bottom: 2.0, left: 10.0, right: 10.0),
                      child: Center(
                        child: getTextWidget(
                            title: widget.companystatus == 'Open'
                                ? AppLocalizations.of(context)!.openword
                                : AppLocalizations.of(context)!.closedword,
                            textFontSize: fontSize12,
                            textFontWeight: fontWeightMedium,
                            textColor: whitecolor),
                      ),
                    ),
                  )

                  // Padding(
                  //   padding: const EdgeInsets.only(right: 16.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: greencolor,
                  //         borderRadius: BorderRadius.circular(33)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           top: 2.0, bottom: 2.0, left: 10.0, right: 10.0),
                  //       child: getTextWidget(
                  //           title: "Open",
                  //           textFontSize: fontSize12,
                  //           textFontWeight: fontWeightMedium,
                  //           textColor: whitecolor),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: Center(
                child: getTextWidget(
                    title: widget.companyName!,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    icGreyLocation,
                    height: 17,
                    color: greycolor,
                    width: 17,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  getTextWidget(
                      title: widget.companyAddress!,
                      textFontSize: fontSize13,
                      textFontWeight: fontWeightRegular,
                      textColor: lightwhitecolor)
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(
              color: bordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: getTextWidget(
                  title: widget.jobName!,
                  textFontSize: fontSize15,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Row(
                children: [
                  getTextWidget(
                      title:
                          '${widget.daysAgo} ${AppLocalizations.of(context)!.daysago}',
                      textFontSize: fontSize13,
                      textFontWeight: fontWeightRegular,
                      textColor: bluecolor),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 2.0),
                    child: Image.asset(
                      icDash,
                      width: 6,
                      color: greycolor,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  getTextWidget(
                      title:
                          '${widget.vacancy} ${AppLocalizations.of(context)!.vacancy}',
                      textFontSize: fontSize13,
                      textFontWeight: fontWeightRegular,
                      textColor: darkblack)
                ],
              ),
            ),
            // const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 11.0),
              child: Row(
                children: [
                  Container(
                    height: 24.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33.0),
                        color: lightbordercolorpro),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                      child: Center(
                        child: getTextWidget(
                            title: widget.workType!,
                            textFontSize: fontSize12,
                            textFontWeight: fontWeightMedium,
                            textColor: darkblack),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 11.0,
                  ),
                  Container(
                    height: 24.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(33.0),
                        color: lightbordercolorpro),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                      child: Center(
                        child: getTextWidget(
                            title: '\$ ${widget.salary} ${widget.salaryType}',
                            textFontSize: fontSize12,
                            textFontWeight: fontWeightMedium,
                            textColor: darkblack),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      postSavedapi();
                    },
                    child: Image.asset(
                      isSaved != 1 ? icSaved : icSavedh,
                      height: 24.0,
                      width: 24.0,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),

            getButton(),
            Padding(
              padding: const EdgeInsets.only(top: 23.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyJobDetail(
                                jobId: widget.jobId.toString(),
                                userId: widget.userId!.toString(),
                              )));
                },
                child: Center(
                  child: getTextWidget(
                      title: AppLocalizations.of(context)!.viewjobdetails,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightBold,
                      textColor: bluecolor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  getButton() {
    debugPrint(' user status :-${widget.userjobstatus}');
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          height: 45,
          width: screenSize!.width,
          padding: const EdgeInsets.only(
            top: 13.0,
            bottom: 13.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43.0),
            color: widget.userjobstatus == "Sent"
                ? lightbluecolor
                : widget.userjobstatus == "Accept"
                    ? lightgreencolor
                    : widget.userjobstatus == "Reject"
                        ? lightredcolor
                        : lightyellowcolor,
          ),
          child: getTextWidget(
              textAlign: TextAlign.center,
              title: widget.userjobstatus == "Sent"
                  ? AppLocalizations.of(context)!.applicationsent
                  : widget.userjobstatus == "Accept"
                      ? AppLocalizations.of(context)!.applicationaccepted
                      : widget.userjobstatus == "Reject"
                          ? AppLocalizations.of(context)!.applicationrejected
                          : AppLocalizations.of(context)!.applicationpending,
              textFontSize: fontSize14,
              textFontWeight: fontWeightSemiBold,
              textColor: widget.userjobstatus == "Sent"
                  ? bluecolor
                  : widget.userjobstatus == "Accept"
                      ? greencolor
                      : widget.userjobstatus == "Reject"
                          ? redcolor
                          : yellowcolor),
        ));
  }
}
