import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Job%20Details/job_detail.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Saved%20Jobs/model/saved_model.dart';
import 'package:http/http.dart' as http;
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textwidget.dart';
import '../Job Details/model/saved_job_model.dart';

class MySavedJobs extends StatefulWidget {
  const MySavedJobs({super.key});

  @override
  State<MySavedJobs> createState() => _MySavedJobsState();
}

class _MySavedJobsState extends State<MySavedJobs> {
  bool isload = true;
  List<Data> recommendedJobs = [];

  @override
  void initState() {
    super.initState();
    getSavedJobsapi();
  }

  Future<void> postSavedapi(int jobid) async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$addfavjoburl/$jobid';

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
              getSavedJobsapi(showProgress: false);
              // isSaved = getJobDetail.isLike!;
              // debugPrint(' IsSaved :-$isSaved');
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

  Future<void> getSavedJobsapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = userfavjoblisturl;

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
        var getSavedJobs = SavedJobModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getSavedJobs.status == '1') {
            setState(() {
              recommendedJobs = getSavedJobs.data ?? [];
              isload = false;
            });
            debugPrint('is it success');
          } else {
            setState(() {
              recommendedJobs = [];
              isload = false;
            });
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
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : recommendedJobs.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                  child: Center(
                    child: getTextWidget(
                        textAlign: TextAlign.center,
                        title: AppLocalizations.of(context)!.dontsaveanyjob,
                        textFontSize: fontSize20,
                        textFontWeight: fontWeightSemiBold,
                        textColor: blackcolor),
                  ),
                )
              : getRecommendedJobs(),
    );
  }

  getRecommendedJobs() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              // shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendedJobs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyJobDetail(
                                    userId: recommendedJobs[index]
                                        .userId!
                                        .toString(),
                                    jobId:
                                        recommendedJobs[index].jobId.toString(),
                                  ))).whenComplete(() {
                        setState(() {
                          getSavedJobsapi();
                        });
                      });
                    },
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: whitecolor,
                          border:
                              Border.all(color: lightbordercolorpro, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 73,
                                  width: 73,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                        width: 1, color: lightbordercolorpro),
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: CachedNetworkImage(
                                        imageUrl: recommendedJobs[index]
                                            .companyImage!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
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
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 17.0, left: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getTextWidget(
                                          title: recommendedJobs[index]
                                              .companyName!,
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: darkblack),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      SizedBox(
                                        width: screenSize!.width - 228,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              icLocation,
                                              height: 17,
                                              width: 17,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              width: 4.0,
                                            ),
                                            Flexible(
                                              child: getTextWidget(
                                                  title: recommendedJobs[index]
                                                      .companyAddress!,
                                                  maxLines: 4,
                                                  textColor: lightwhitecolor,
                                                  textFontSize: fontSize13,
                                                  textFontWeight:
                                                      fontWeightRegular),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, right: 10.0),
                                  child: Container(
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                        color: recommendedJobs[index]
                                                    .companyJobStatus! ==
                                                'Open'
                                            ? greencolor
                                            : lightgreypromax,
                                        borderRadius:
                                            BorderRadius.circular(33)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 2.0,
                                          left: 10.0,
                                          right: 10.0),
                                      child: Center(
                                        child: getTextWidget(
                                            title: recommendedJobs[index]
                                                        .companyJobStatus! ==
                                                    'Open'
                                                ? AppLocalizations.of(context)!
                                                    .openword
                                                : AppLocalizations.of(context)!
                                                    .closedword,
                                            textFontSize: fontSize12,
                                            textFontWeight: fontWeightMedium,
                                            textColor: whitecolor),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: getTextWidget(
                                  title: recommendedJobs[index].jobName!,
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
                                          '${recommendedJobs[index].daysAgoCreate.toString()} ${AppLocalizations.of(context)!.daysago}',
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightRegular,
                                      textColor: bluecolor),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, top: 2.0),
                                    child: Image.asset(
                                      icDash,
                                      width: 6,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  getTextWidget(
                                      title:
                                          '${recommendedJobs[index].vacancies!.toString()} ${AppLocalizations.of(context)!.vacancy}',
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightRegular,
                                      textColor: darkblack)
                                ],
                              ),
                            ),
                            // const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 17.0, right: 10.0, top: 15.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 24.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(33.0),
                                        color: lightbordercolorpro),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 2.0,
                                          bottom: 2.0),
                                      child: Center(
                                        child: getTextWidget(
                                            title: recommendedJobs[index]
                                                .workType!
                                                .toString(),
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
                                        borderRadius:
                                            BorderRadius.circular(33.0),
                                        color: lightbordercolorpro),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 2.0,
                                          bottom: 2.0),
                                      child: Center(
                                        child: getTextWidget(
                                            title:
                                                '\$ ${recommendedJobs[index].salary!.toString()} ${recommendedJobs[index].salaryType!.toString()} ',
                                            textFontSize: fontSize12,
                                            textFontWeight: fontWeightMedium,
                                            textColor: darkblack),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      postSavedapi(
                                          recommendedJobs[index].jobId!);
                                    },
                                    child: Image.asset(
                                      recommendedJobs[index].favoriteJob !=
                                              false
                                          ? icSavedh
                                          : icSaved,
                                      height: 24.0,
                                      width: 24.0,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
