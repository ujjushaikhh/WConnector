import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textwidget.dart';
import '../Applied Job Status/job_status.dart';
import 'model/applied_job_model.dart';

class MyAplliedJobs extends StatefulWidget {
  const MyAplliedJobs({super.key});

  @override
  State<MyAplliedJobs> createState() => _MyAplliedJobsState();
}

class _MyAplliedJobsState extends State<MyAplliedJobs> {
  @override
  void initState() {
    super.initState();
    getAppliedJobapi();
  }

  List<Data> appliedJobs = [];
  bool isload = true;

  Future<void> getAppliedJobapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = userjoblisturl;

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(' Token ${getString('usertoken')}');
        debugPrint('url $apiurl');

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getAppliedJob = AppliedJobModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getAppliedJob.status == '1') {
            setState(() {
              appliedJobs = getAppliedJob.data ?? [];
              isload = false;
            });
            debugPrint('is it success');
          } else {
            appliedJobs = [];
            isload = false;
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
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : appliedJobs.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                  child: Center(
                    child: getTextWidget(
                        textAlign: TextAlign.center,
                        title: AppLocalizations.of(context)!.dontappliedforjob,
                        textFontSize: fontSize20,
                        textFontWeight: fontWeightSemiBold,
                        textColor: blackcolor),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: ListView.builder(
                      itemCount: appliedJobs.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyJobStatus(
                                              isSaved: appliedJobs[index]
                                                  .favoriteJob,
                                              companyAddress: appliedJobs[index]
                                                  .companyAddress,
                                              companyImage: appliedJobs[index]
                                                  .companyImage,
                                              companyName: appliedJobs[index]
                                                  .companyName,
                                              daysAgo: appliedJobs[index]
                                                  .daysAgoCreate,
                                              jobId: appliedJobs[index].jobId,
                                              jobName:
                                                  appliedJobs[index].jobName,
                                              salary: appliedJobs[index].salary,
                                              salaryType:
                                                  appliedJobs[index].salaryType,
                                              userId: appliedJobs[index].userId,
                                              vacancy:
                                                  appliedJobs[index].vacancies,
                                              workType:
                                                  appliedJobs[index].workType,
                                              userjobstatus: appliedJobs[index]
                                                  .userJobStatus,
                                              companystatus: appliedJobs[index]
                                                  .companyJobStatus,
                                            ))).whenComplete(() {
                                  setState(() {
                                    getAppliedJobapi();
                                  });
                                });
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: lightbordercolorpro),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          child: CachedNetworkImage(
                                            imageUrl: appliedJobs[index]
                                                .companyImage!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 51.0,
                                              width: 51.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                height: 51.0,
                                                width: 51.0,
                                                decoration: const BoxDecoration(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, top: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getTextWidget(
                                            title: appliedJobs[index].jobName!,
                                            textFontSize: fontSize15,
                                            textFontWeight: fontWeightMedium,
                                            textColor: darkblack),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        getTextWidget(
                                            title:
                                                appliedJobs[index].companyName!,
                                            textFontSize: fontSize13,
                                            textFontWeight: fontWeightRegular,
                                            textColor: shadowcolor),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: appliedJobs[index]
                                                            .userJobStatus ==
                                                        "Sent"
                                                    ? lightbluecolor
                                                    : appliedJobs[index]
                                                                .userJobStatus ==
                                                            "Accept"
                                                        ? lightgreencolor
                                                        : appliedJobs[index]
                                                                    .userJobStatus ==
                                                                "Reject"
                                                            ? lightredcolor
                                                            : lightyellowcolor,
                                                borderRadius:
                                                    BorderRadius.circular(33)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 10.0,
                                                  top: 2.0,
                                                  bottom: 2.0),
                                              child: getTextWidget(
                                                  title: appliedJobs[index]
                                                              .userJobStatus ==
                                                          "Sent"
                                                      ? AppLocalizations.of(context)!
                                                          .applicationsent
                                                      : appliedJobs[index].userJobStatus ==
                                                              "Accept"
                                                          ? AppLocalizations.of(context)!
                                                              .applicationaccepted
                                                          : appliedJobs[index]
                                                                      .userJobStatus ==
                                                                  "Reject"
                                                              ? AppLocalizations.of(
                                                                      context)!
                                                                  .applicationrejected
                                                              : AppLocalizations.of(
                                                                      context)!
                                                                  .applicationpending,
                                                  textFontSize: fontSize12,
                                                  textFontWeight:
                                                      fontWeightMedium,
                                                  textColor: appliedJobs[index]
                                                              .userJobStatus ==
                                                          "Sent"
                                                      ? bluecolor
                                                      : appliedJobs[index]
                                                                  .userJobStatus ==
                                                              "Accept"
                                                          ? greencolor
                                                          : appliedJobs[index]
                                                                      .userJobStatus ==
                                                                  "Reject"
                                                              ? redcolor
                                                              : yellowcolor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Image.asset(
                                      icArrowright,
                                      color: greycolor,
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              child: Container(
                                height: 1.2,
                                width: screenSize!.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: boxborderpro, width: 1)),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
    );
  }
}
