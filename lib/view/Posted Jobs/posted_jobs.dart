import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/constants/color_constants.dart';
import 'package:wconnectorconnectorflow/constants/image_constants.dart';
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/update_job.dart';
import 'package:wconnectorconnectorflow/view/Hired%20Applicants/hired_applicants.dart';
import 'package:wconnectorconnectorflow/view/Posted%20Job%20Detail/posted_job_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:wconnectorconnectorflow/view/Posted%20Jobs/model/closed_jobmodel.dart';
import '../../constants/api_constants.dart';
import '../../constants/font_constants.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../Auth/Home/model/home_model.dart';

class MyPostedJobs extends StatefulWidget {
  const MyPostedJobs({super.key});

  @override
  State<MyPostedJobs> createState() => _MyPostedJobsState();
}

class _MyPostedJobsState extends State<MyPostedJobs> {
  @override
  void initState() {
    super.initState();
    getJoblistTypesapi();
  }

  bool isSelected = false;
  bool isload = true;
  bool isloadclose = true;
  int? selectedindex;

  Future<void> postCloseJobapi(int jobId) async {
    if (await checkUserConnection()) {
      // if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$closejobapiurl/$jobId';

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getClosejob = ClosedJobsModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          // ProgressDialogUtils.dismissProgressDialog();
          if (getClosejob.status == '1') {
            setState(() {
              getJoblistTypesapi();
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            if (!mounted) return;
            connectorAlertDialogue(
                context: context,
                type: AlertType.info,
                desc: 'This job is already closed',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
            // ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          // ProgressDialogUtils.dismissProgressDialog();
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
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          // ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request 400',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          // ProgressDialogUtils.dismissProgressDialog();
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
        // ProgressDialogUtils.dismissProgressDialog();
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

  Future<void> getCloseJobTypesapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getjoblistownerurl/Close';

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getJoblist = ClosedJobsModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          // if (getJoblist.status == '1') {
          setState(() {
            closedJobs = getJoblist.jobs ?? [];
            isloadclose = false;
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

  Future<void> getJoblistTypesapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getjoblistownerurl/Open';

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getJoblist = JobListModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          // if (getJoblist.status == '1') {
          setState(() {
            recommendedJobs = getJoblist.jobs ?? [];
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

  List<Jobs> recommendedJobs = [];

  List<ClosedJobs> closedJobs = [
    // ClosedJobs(
    //     status: "closed",
    //     companyImg: icCompany4,
    //     companyName: "Acme Corporation",
    //     companyLocation: "Garut, Angola",
    //     daysago: "4",
    //     noofApplicant: 53,
    //     payPerhrs: "20",
    //     work: "Product Designer - Gopay",
    //     workType: "Seasonal"),
    // ClosedJobs(
    //     status: "closed",
    //     companyImg: icCompany1,
    //     companyName: "Acme Corporation",
    //     companyLocation: "Garut, Angola",
    //     daysago: "4",
    //     noofApplicant: 53,
    //     payPerhrs: "20",
    //     work: "Product Designer - Gopay",
    //     workType: "Seasonal"),
    // ClosedJobs(
    //     status: "closed",
    //     companyImg: icCompany2,
    //     companyName: "Acme Corporation",
    //     companyLocation: "Garut, Angola",
    //     daysago: "4",
    //     noofApplicant: 53,
    //     payPerhrs: "20",
    //     work: "Product Designer - Gopay",
    //     workType: "Seasonal"),
    // ClosedJobs(
    //     status: "closed",
    //     companyImg: icCompany2,
    //     companyName: "Acme Corporation",
    //     companyLocation: "Garut, Angola",
    //     daysago: "4",
    //     noofApplicant: 53,
    //     payPerhrs: "20",
    //     work: "Product Designer - Gopay",
    //     workType: "Seasonal")
  ];

  int? selectedIndex = 0;
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
            : SingleChildScrollView(
                child: Column(
                  children: [
                    getTitleBar(),
                    selectedIndex == 0
                        ? recommendedJobs.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 36.0, right: 36.0, top: 100.0),
                                child: getTextWidget(
                                    title: AppLocalizations.of(context)!
                                        .noongoings,
                                    textAlign: TextAlign.center,
                                    textFontSize: fontSize20,
                                    textFontWeight: fontWeightSemiBold,
                                    textColor: blackcolor),
                              )
                            : getRecommendedJobs()
                        : closedJobs.isEmpty
                            ? isloadclose
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.transparent,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 36.0, right: 36, top: 100.0),
                                    child: getTextWidget(
                                        title: AppLocalizations.of(context)!
                                            .noclosed,
                                        textAlign: TextAlign.center,
                                        textFontSize: fontSize20,
                                        textFontWeight: fontWeightSemiBold,
                                        textColor: blackcolor),
                                  )
                            : getClosedJobs()
                  ],
                ),
              ));
  }

  getOption(int id) {
    return PopupMenuButton(
        color: whitecolor,
        itemBuilder: (context) => [
              // popupmenu item 1
              PopupMenuItem(
                value: 1,
                // row has two child icon and text.
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    postCloseJobapi(id);
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        icClose,
                        height: 24.0,
                        width: 24.0,
                        color: greycolor,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      getTextWidget(
                        title: AppLocalizations.of(context)!.closejob,
                        textFontSize: fontSize14,
                        textFontWeight: fontWeightMedium,
                        textColor: darkblack,
                      )
                    ],
                  ),
                ),
              ),

              // popupmenu item 2
              PopupMenuItem(
                value: 2,
                // row has two child icon and text
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateCreatedJob(
                                  jobid: id,
                                ))).whenComplete(() {
                      setState(() {
                        getJoblistTypesapi();
                      });
                    });
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        icEditProfile,
                        height: 24.0,
                        width: 24.0,
                        color: greycolor,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        // sized box with width 10
                        width: 10,
                      ),
                      getTextWidget(
                        title: AppLocalizations.of(context)!.editjob,
                        textFontSize: fontSize14,
                        textFontWeight: fontWeightMedium,
                        textColor: darkblack,
                      )
                    ],
                  ),
                ),
              ),
            ]);
    // Container(
    //   height: 78,
    //   width: 128,
    //   decoration: BoxDecoration(
    //       color: whitecolor, borderRadius: BorderRadius.circular(6.0)),
    //   child: Column(
    //     children: [
    //       Row(
    //         children: [

    //           const SizedBox(
    //             width: 8,
    //           ),

    //         ],
    //       ),
    //       Row(
    //         children: [

    //           const SizedBox(
    //             width: 8,
    //           ),

    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  getTitleBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0;
                getJoblistTypesapi();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: selectedIndex == 0 ? bluecolor : bordercolor,
                          width: 2.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                    child: getTextWidget(
                        title: AppLocalizations.of(context)!.ongoing,
                        textFontSize: fontSize14,
                        textFontWeight: fontWeightMedium,
                        textColor: selectedIndex == 0 ? bluecolor : darkblack)),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 1;

                getCloseJobTypesapi();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: selectedIndex == 1 ? bluecolor : bordercolor,
                          width: 2.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                    child: getTextWidget(
                        title: AppLocalizations.of(context)!.completed,
                        textFontSize: fontSize14,
                        textFontWeight: fontWeightMedium,
                        textColor: selectedIndex == 1 ? bluecolor : darkblack)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getRecommendedJobs() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
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
                              builder: (context) => MyPostedJobDetail(
                                    jobId: recommendedJobs[index].jobId!,
                                  )));
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
                                    child: CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        // height: 34.0,
                                        // width: 34.0,
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
                                          // height: 34.0,
                                          // width: 34.0,
                                          decoration: const BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      imageUrl: getString('companyimage'),
                                      // height: 34,
                                      // width: 34,
                                      // fit: BoxFit.cover,
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
                                          title: getString('companyname'),
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: darkblack),
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
                                              title: 'Garut, Angola',
                                              textColor: lightwhitecolor,
                                              textFontSize: fontSize13,
                                              textFontWeight: fontWeightRegular)
                                        ],
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
                                          '${recommendedJobs[index].totlapplicationCount!.toString()} ${AppLocalizations.of(context)!.applicants}',
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
                                                '\$ ${recommendedJobs[index].salary!.toString()} ${recommendedJobs[index].salaryType!.toString()}',
                                            textFontSize: fontSize12,
                                            textFontWeight: fontWeightMedium,
                                            textColor: darkblack),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  recommendedJobs[index].companyJobStatus! ==
                                          'Open'
                                      ? getOption(recommendedJobs[index].jobId!)
                                      : Container()
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     setState(() {
                                  //       selectedindex = index;
                                  //     });
                                  //   },
                                  //   child: Image.asset(
                                  //     icMore,
                                  //     height: 24.0,
                                  //     width: 24.0,
                                  //     color:
                                  //         isSelected ? bluecolor : darkblack,
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
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

  getClosedJobs() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: closedJobs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHiredApplicant(
                                    closejobId:
                                        closedJobs[index].jobId!.toString(),
                                    jobName: closedJobs[index].jobName!,
                                    daysago: closedJobs[index]
                                        .daysAgoCreate!
                                        .toString(),
                                    noofApplicant: closedJobs[index]
                                        .totlapplicationCount!
                                        .toString(),
                                    worktype: closedJobs[index].workType!,
                                    salary: closedJobs[index].salary!,
                                    salaryType: closedJobs[index].salaryType!,
                                  )));
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
                                    child: CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        // height: 34.0,
                                        // width: 34.0,
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
                                          // height: 34.0,
                                          // width: 34.0,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                      imageUrl: getString('companyimage'),
                                      // height: 34,
                                      // width: 34,
                                      // fit: BoxFit.cover,
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
                                          title: getString('companyname'),
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: darkblack),
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
                                              title: 'Garut,Angola',
                                              textColor: lightwhitecolor,
                                              textFontSize: fontSize13,
                                              textFontWeight: fontWeightRegular)
                                        ],
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
                                        color: closedJobs[index]
                                                    .companyJobStatus! ==
                                                'open'
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
                                            title: closedJobs[index]
                                                        .companyJobStatus! ==
                                                    'open'
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
                                  title: closedJobs[index].jobName!,
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
                                          '${closedJobs[index].daysAgoCreate.toString()} ${AppLocalizations.of(context)!.daysago}',
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
                                          '${closedJobs[index].totlapplicationCount!.toString()} ${AppLocalizations.of(context)!.applicants}',
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
                                            title: closedJobs[index]
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
                                                '\$ ${closedJobs[index].salary!.toString()} ${closedJobs[index].salaryType!.toString()}',
                                            textFontSize: fontSize12,
                                            textFontWeight: fontWeightMedium,
                                            textColor: darkblack),
                                      ),
                                    ),
                                  ),
                                  // const Spacer(),
                                  // PopupMenuButton(
                                  //   itemBuilder: (context) {
                                  //     return [
                                  //       PopupMenuItem(
                                  //         child: Column(
                                  //           crossAxisAlignment:
                                  //               CrossAxisAlignment.start,
                                  //           children: [
                                  //             Row(
                                  //               children: [
                                  //                 Image.asset(
                                  //                   icClose,
                                  //                   height: 24.0,
                                  //                   width: 24.0,
                                  //                   color: greycolor,
                                  //                   fit: BoxFit.cover,
                                  //                 ),
                                  //                 const SizedBox(width: 8),
                                  //                 getTextWidget(
                                  //                   title: 'Close Job',
                                  //                   textFontSize: fontSize14,
                                  //                   textFontWeight:
                                  //                       fontWeightMedium,
                                  //                   textColor: darkblack,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //             const Divider(
                                  //               color: lightbordercolorpro,
                                  //               thickness: 1.0,
                                  //               height: 1.0,
                                  //             ),
                                  //             Row(
                                  //               children: [
                                  //                 Image.asset(
                                  //                   icEditProfile,
                                  //                   height: 24.0,
                                  //                   width: 24.0,
                                  //                   color: greycolor,
                                  //                   fit: BoxFit.cover,
                                  //                 ),
                                  //                 const SizedBox(width: 8),
                                  //                 getTextWidget(
                                  //                   title: 'Edit Job',
                                  //                   textFontSize: fontSize14,
                                  //                   textFontWeight:
                                  //                       fontWeightMedium,
                                  //                   textColor: darkblack,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ];
                                  //   },
                                  //   child: Image.asset(
                                  //     icMore,
                                  //     height: 24.0,
                                  //     width: 24.0,
                                  //     color: darkblack,
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // )
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
