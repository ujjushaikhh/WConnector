import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Home/model/get_homemodel.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Bottom%20Tab/primarybottomtab.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/dailog.dart';
import '../../../../utils/internetconnection.dart';
import '../../../../utils/progressdialog.dart';
import '../../../../utils/textwidget.dart';
import '../../Job Details/job_detail.dart';
import '../../Job Details/model/saved_job_model.dart';
import '../../Search Screen/search_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    super.initState();
    getHomeapi();
  }

  int? notifyCount = 2;
  bool isload = true;

  Future<void> postSavedapi(int jobid) async {
    if (await checkUserConnection()) {
      // if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
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
              getHomeapi(showProgress: false);
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

  Future<void> getHomeapi({bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;

        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = homescreenurl;

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('usertoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getHome = GetHome.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          // if (getHome.status == '1') {
          setState(() {
            recommendedJobs = getHome.recommendedJobs ?? [];
            isload = false;
          });
          debugPrint('is it success');

          // }
          //  else {
          //   debugPrint('failed to load');
          //   ProgressDialogUtils.dismissProgressDialog();
          // }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Unauthorized user',
            onPressed: () {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()),
              //     (route) => false);
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

  List<RecommendedJobs> recommendedJobs = [
    // RecommendedJobs(
    //     status: "open",
    //     companyImg: icCompany1,
    //     companyName: "Acme Corporation",
    //     companyLocation: "Garut, Angola",
    //     daysago: "4",
    //     noofApplicant: 53,
    //     payPerhrs: "20",
    //     work: "Product Designer - Gopay",
    //     workType: "Seasonal"),
    // RecommendedJobs(
    //     status: "closed",
    //     companyImg: icCompany2,
    //     companyName: "Acme Corporation",
    //     companyLocation: "Garut, Angola",
    //     daysago: "4",
    //     noofApplicant: 53,
    //     payPerhrs: "20",
    //     work: "Product Designer - Gopay",
    //     workType: "Seasonal"),
    // RecommendedJobs(
    // status: "closed",
    // companyImg: icCompany2,
    // companyName: "Acme Corporation",
    // companyLocation: "Garut, Angola",
    // daysago: "4",
    // noofApplicant: 53,
    // payPerhrs: "20",
    // work: "Product Designer - Gopay",
    // workType: "Seasonal")
  ];

  List<PopularJobs> popularjobs = [
    PopularJobs(
        companyImg: icCompany1,
        companyName: "Acme Corporation",
        companyLocation: "Garut, Angola",
        daysago: "4",
        noofApplicant: 53,
        payPerhrs: "20",
        work: "Product Designer - Gopay",
        workType: "Seasonal"),
    PopularJobs(
        companyImg: icCompany1,
        companyName: "Acme Corporation",
        companyLocation: "Garut, Angola",
        daysago: "4",
        noofApplicant: 53,
        payPerhrs: "20",
        work: "Product Designer - Gopay",
        workType: "Seasonal")
  ];
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
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 42.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTextWidget(
                                title: AppLocalizations.of(context)!
                                    .currentlocation,
                                textFontSize: fontSize13,
                                textFontWeight: fontWeightLight,
                                textColor: lightblack),
                            const SizedBox(
                              height: 3.0,
                            ),
                            Row(
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
                                getTextWidget(
                                    title: 'Garut, New York',
                                    textFontSize: fontSize14,
                                    textFontWeight: fontWeightMedium,
                                    textColor: darkblack)
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        getTextWidget(
                            title: getInt('lang_id') == 1 ? 'EN' : 'PL',
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightMedium,
                            textColor: darkblack),
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(
                              icArrowdown,
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                              color: darkblack,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 14.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MySearchScreen()));
                            },
                            child: Image.asset(
                              icSearch,
                              height: 24,
                              width: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Stack(children: [
                          IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                icNotification,
                                height: 24,
                                width: 24,
                                color: darkblack,
                              )),
                          Positioned(
                            top: 1,
                            right: 3,
                            child: Container(
                              height: 22.0,
                              width: 22.0,
                              decoration: const BoxDecoration(
                                color: bluecolor,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16.0,
                                minHeight: 16.0,
                              ),
                              child: Center(
                                child: Text(
                                  notifyCount!.toString(),
                                  style: const TextStyle(
                                    color: whitecolor,
                                    fontSize: fontSize13,
                                    fontFamily: fontfamilybeVietnam,
                                    fontWeight: fontWeightSemiBold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                  getProfile(),
                  getPopularJobs(),
                  recommendedJobs.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                          child: getTextWidget(
                              title: AppLocalizations.of(context)!.recommended,
                              textFontSize: fontSize18,
                              textFontWeight: fontWeightSemiBold,
                              textColor: darkblack),
                        ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  recommendedJobs.isEmpty
                      ? Center(
                          child: getTextWidget(
                              title: AppLocalizations.of(context)!.nocmpanies,
                              textFontSize: fontSize20,
                              textFontWeight: fontWeightSemiBold,
                              textAlign: TextAlign.center,
                              textColor: darkblack),
                        )
                      : getRecommendedJobs()
                ],
              ),
            ),
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendedJobs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyJobDetail(
                                    jobId:
                                        recommendedJobs[index].jobId.toString(),
                                    userId: recommendedJobs[index]
                                        .userid
                                        .toString(),
                                  ))).whenComplete(() {
                        setState(() {
                          getHomeapi(showProgress: false);
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          recommendedJobs[index].companyImage!,
                                      imageBuilder: (context, imageProvider) =>
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
                                  )),
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
                                                  maxLines: 4,
                                                  title: recommendedJobs[index]
                                                      .companyAddress!,
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
                                    height: 24,
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
                                    height: 24,
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
                                    height: 24,
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
                                      recommendedJobs[index].favoriteJob ==
                                              false
                                          ? icSaved
                                          : icSavedh,
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

  getPopularJobs() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getTextWidget(
                  title: AppLocalizations.of(context)!.popularjobs,
                  textFontSize: fontSize18,
                  textFontWeight: fontWeightSemiBold,
                  textColor: darkblack),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.seeall,
                    textFontSize: fontSize13,
                    textFontWeight: fontWeightMedium,
                    textColor: greencolor),
              )
            ],
          ),
          SizedBox(
            height: 197,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: popularjobs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 5.0),
                    child: Container(
                      height: 197,
                      width: MediaQuery.of(context).size.width - 60,
                      decoration: const BoxDecoration(
                          color: bluecolor,
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Image.asset(
                                    popularjobs[index].companyImg!,
                                    height: 73,
                                    width: 73,
                                    fit: BoxFit.cover,
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
                                          title:
                                              popularjobs[index].companyName!,
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: whitecolor),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
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
                                          getTextWidget(
                                              title: popularjobs[index]
                                                  .companyLocation!,
                                              textColor: lightwhitepro,
                                              textFontSize: fontSize13,
                                              textFontWeight: fontWeightRegular)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: getTextWidget(
                                  title: popularjobs[index].work!,
                                  textFontSize: fontSize15,
                                  textFontWeight: fontWeightMedium,
                                  textColor: whitecolor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: Row(
                                children: [
                                  getTextWidget(
                                      title:
                                          '${popularjobs[index].daysago.toString()} ${AppLocalizations.of(context)!.daysago}',
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightRegular,
                                      textColor: lightorange),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, top: 2.0),
                                    child: Image.asset(
                                      icDash,
                                      width: 6,
                                      color: whitecolor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  getTextWidget(
                                      title:
                                          '${popularjobs[index].noofApplicant!.toString()} ${AppLocalizations.of(context)!.applicants}',
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightRegular,
                                      textColor: whitecolor)
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 17.0, right: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(33.0),
                                        color: Colors.white
                                            .withOpacity(0.7400000095367432)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 2.0,
                                          bottom: 2.0),
                                      child: getTextWidget(
                                          title: popularjobs[index]
                                              .workType!
                                              .toString(),
                                          textFontSize: fontSize12,
                                          textFontWeight: fontWeightMedium,
                                          textColor: darkblack),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 11.0,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(33.0),
                                        color: Colors.white
                                            .withOpacity(0.7400000095367432)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 2.0,
                                          bottom: 2.0),
                                      child: getTextWidget(
                                          title:
                                              '\$ ${popularjobs[index].payPerhrs!.toString()} per hour',
                                          textFontSize: fontSize12,
                                          textFontWeight: fontWeightMedium,
                                          textColor: darkblack),
                                    ),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    icSaved,
                                    height: 24.0,
                                    width: 24.0,
                                    color: whitecolor,
                                    fit: BoxFit.cover,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  getProfile() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => const WorkerPrimaryBottomTab(
                        from: 'home',
                      ))));
        },
        child: Container(
          // height: 54,
          width: MediaQuery.of(context).size.width,
          color: lightgreypro,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 34.0,
                    width: 34.0,
                    fit: BoxFit.cover,
                    imageUrl: getString('userimage'),
                    imageBuilder: (context, imageProvider) => Container(
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
                        height: 34,
                        width: 34,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 9.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getTextWidget(
                        title: AppLocalizations.of(context)!.loggedinas,
                        textColor: lightwhite,
                        textFontSize: fontSize13,
                        textFontWeight: fontWeightRegular,
                      ),
                      const SizedBox(
                        height: 1.0,
                      ),
                      getTextWidget(
                          title: getString('username'),
                          textFontSize: fontSize15,
                          textFontWeight: fontWeightSemiBold,
                          textColor: darkblack)
                    ],
                  ),
                ),
                const Spacer(),
                Image.asset(
                  icArrowright,
                  height: 24.0,
                  width: 24.0,
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class RecommendedJobs {
//   String? companyImg;
//   String? companyName;
//   String? companyLocation;
//   String? work;
//   String? daysago;
//   int? noofApplicant;
//   String? workType;
//   String? payPerhrs;
//   String? status;

//   RecommendedJobs(
//       {this.companyImg,
//       this.companyName,
//       this.companyLocation,
//       this.work,
//       this.status,
//       this.daysago,
//       this.noofApplicant,
//       this.payPerhrs,
//       this.workType});
// }

class PopularJobs {
  String? companyImg;
  String? companyName;
  String? companyLocation;
  String? work;
  String? daysago;
  int? noofApplicant;
  String? workType;
  String? payPerhrs;

  PopularJobs(
      {this.companyImg,
      this.companyName,
      this.companyLocation,
      this.work,
      this.daysago,
      this.noofApplicant,
      this.payPerhrs,
      this.workType});
}
