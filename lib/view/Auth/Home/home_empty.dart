import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/constants/color_constants.dart';
import 'package:wconnectorconnectorflow/utils/button.dart';
import 'package:wconnectorconnectorflow/utils/internetconnection.dart';
import 'package:wconnectorconnectorflow/utils/progressdialog.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/view/Auth/Home/model/home_model.dart';
import 'package:wconnectorconnectorflow/view/Bottom%20Tab/primarybottomtab.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wconnectorconnectorflow/view/Notification/notification.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/dailog.dart';
import '../../../utils/textwidget.dart';
import '../../Posted Job Detail/posted_job_detail.dart';

class MyHomeEmpty extends StatefulWidget {
  const MyHomeEmpty({super.key});

  @override
  State<MyHomeEmpty> createState() => _MyHomeEmptyState();
}

class _MyHomeEmptyState extends State<MyHomeEmpty> {
  bool isLoad = true;
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
            isLoad = false;
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

  @override
  void initState() {
    super.initState();
    getJoblistTypesapi();
    debugPrint('get lang id : - ${getInt('lang_id')}');
  }

  List<Jobs> recommendedJobs = [
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

  // List<ApplicantDetail> applicantList = [
  //   ApplicantDetail(
  //       applicantImg: icapplicant1,
  //       applicantLocation: "Garut , Angola",
  //       applicantName: "Wade Warren",
  //       work: "Product Designer - Gopay"),
  //   ApplicantDetail(
  //       applicantImg: icapplicant2,
  //       applicantLocation: "Garut , Angola",
  //       applicantName: "Ralph Edwards",
  //       work: "Product Designer - Gopay"),
  //   ApplicantDetail(
  //       applicantImg: icapplicant3,
  //       applicantLocation: "Garut , Angola",
  //       applicantName: "Bessie Cooper",
  //       work: "Product Designer - Gopay"),
  //   ApplicantDetail(
  //       applicantImg: icapplicant4,
  //       applicantLocation: "Garut , Angola",
  //       applicantName: "Cody Fisher",
  //       work: "Product Designer - Gopay")
  // ];
  int? notifyCount = 2;
  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 36.0, left: 16.0, right: 16.0),
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
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     right: 14.0,
                          //   ),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => const MySearchScreen()));
                          //     },
                          //     child: Image.asset(
                          //       icSearch,
                          //       height: 24,
                          //       width: 24,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          Stack(children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyNotification()));
                                },
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
                    recommendedJobs.isEmpty
                        ? getHomeEmpty()
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Column(
                              children: [
                                getRecommendedJobs()
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 12.0),
                                //   child: Row(
                                //     children: [
                                //       getTextWidget(
                                //           title: '212 ',
                                //           textFontSize: fontSize20,
                                //           textFontWeight: fontWeightSemiBold,
                                //           textColor: darkblack),
                                //       getTextWidget(
                                //           title: 'New Requests',
                                //           textFontSize: fontSize20,
                                //           textFontWeight: fontWeightLight,
                                //           textColor: blackcolor)
                                //     ],
                                //   ),
                                // ),
                                // getApplicantList()
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  getRecommendedJobs() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
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
                                  ))).whenComplete(() {
                        setState(() {
                          getJoblistTypesapi();
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
                                  // )
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

  // getApplicantList() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width,
  //     child: MediaQuery.removePadding(
  //       context: context,
  //       removeTop: true,
  //       child: ListView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: applicantList.length,
  //           itemBuilder: (context, index) {
  //             return Padding(
  //               padding: const EdgeInsets.only(top: 12.0),
  //               child: GestureDetector(
  //                 behavior: HitTestBehavior.translucent,
  //                 onTap: () {
  //                   // Navigator.push(
  //                   //     context,
  //                   //     MaterialPageRoute(
  //                   //         builder: (context) => const MyJobDetail()));
  //                 },
  //                 child: Container(
  //                   // height: MediaQuery.of(context).size.height,
  //                   width: MediaQuery.of(context).size.width,
  //                   decoration: BoxDecoration(
  //                       color: whitecolor,
  //                       border:
  //                           Border.all(color: lightbordercolorpro, width: 1),
  //                       borderRadius:
  //                           const BorderRadius.all(Radius.circular(6.0))),
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(
  //                         top: 10.0, left: 10.0, bottom: 20.0),
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                               height: 73,
  //                               width: 73,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(6.0),
  //                                 border: Border.all(
  //                                     width: 1, color: lightbordercolorpro),
  //                               ),
  //                               child: Center(
  //                                 child: Image.asset(
  //                                   applicantList[index].applicantImg!,
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(
  //                                   top: 17.0, left: 15.0),
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   getTextWidget(
  //                                       title:
  //                                           applicantList[index].applicantName!,
  //                                       textFontSize: fontSize15,
  //                                       textFontWeight: fontWeightSemiBold,
  //                                       textColor: darkblack),
  //                                   const SizedBox(
  //                                     height: 5.0,
  //                                   ),
  //                                   Row(
  //                                     children: [
  //                                       Image.asset(
  //                                         icGreyLocation,
  //                                         height: 17,
  //                                         width: 17,
  //                                         fit: BoxFit.cover,
  //                                       ),
  //                                       const SizedBox(
  //                                         width: 4.0,
  //                                       ),
  //                                       getTextWidget(
  //                                           title: applicantList[index]
  //                                               .applicantLocation!,
  //                                           textColor: lightwhitecolor,
  //                                           textFontSize: fontSize13,
  //                                           textFontWeight: fontWeightRegular)
  //                                     ],
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                             const Spacer(),
  //                             Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     top: 17, right: 10.0),
  //                                 child: GestureDetector(
  //                                   onTap: () {
  //                                     Navigator.push(
  //                                         context,
  //                                         MaterialPageRoute(
  //                                             builder: (context) =>
  //                                                 const MyApplicantDetails()));
  //                                   },
  //                                   child: getTextWidget(
  //                                       title: 'View',
  //                                       textFontSize: fontSize14,
  //                                       textFontWeight: fontWeightSemiBold,
  //                                       textColor: bluecolor),
  //                                 )
  //                                 // Container(
  //                                 //   decoration: BoxDecoration(
  //                                 //       color: ApplicantDetail[index].status! ==
  //                                 //               'open'
  //                                 //           ? greencolor
  //                                 //           : lightgreypromax,
  //                                 //       borderRadius: BorderRadius.circular(33)),
  //                                 //   child: Padding(
  //                                 //     padding: const EdgeInsets.only(
  //                                 //         top: 2.0,
  //                                 //         bottom: 2.0,
  //                                 //         left: 10.0,
  //                                 //         right: 10.0),
  //                                 //     child: getTextWidget(
  //                                 //         title: ApplicantDetail[index].status! ==
  //                                 //                 'open'
  //                                 //             ? "Open"
  //                                 //             : "Closed",
  //                                 //         textFontSize: fontSize12,
  //                                 //         textFontWeight: fontWeightMedium,
  //                                 //         textColor: whitecolor),
  //                                 //   ),
  //                                 // ),
  //                                 )
  //                           ],
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 9.0),
  //                           child: getTextWidget(
  //                               title: 'Applied for',
  //                               textFontSize: fontSize13,
  //                               textFontWeight: fontWeightRegular,
  //                               textColor: shadowcolor),
  //                         ),
  //                         Padding(
  //                           padding: const EdgeInsets.only(top: 3.0),
  //                           child: getTextWidget(
  //                               title: applicantList[index].work!,
  //                               textFontSize: fontSize15,
  //                               textFontWeight: fontWeightMedium,
  //                               textColor: darkblack),
  //                         ),
  //                         Padding(
  //                           padding:
  //                               const EdgeInsets.only(top: 15.0, right: 10.0),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               CustomizeButton(
  //                                 borderWidth: 1.5,
  //                                 text: 'Reject',
  //                                 onPressed: () {},
  //                                 borderColor: bluecolor,
  //                                 textcolor: bluecolor,
  //                                 color: whitecolor,
  //                                 buttonHeight: 35,
  //                                 buttonWidth: screenSize!.width / 2.5,
  //                               ),
  //                               CustomizeButton(
  //                                 text: 'Accept',
  //                                 onPressed: () {},
  //                                 buttonHeight: 35,
  //                                 buttonWidth: screenSize!.width / 2.5,
  //                               )
  //                             ],
  //                           ),
  //                         )

  //                         // Padding(
  //                         //   padding: const EdgeInsets.only(top: 9.0),
  //                         //   child: Row(
  //                         //     children: [
  //                         //       getTextWidget(
  //                         //           title:
  //                         //               '${ApplicantDetail[index].daysago.toString()} days ago',
  //                         //           textFontSize: fontSize13,
  //                         //           textFontWeight: fontWeightRegular,
  //                         //           textColor: bluecolor),
  //                         //       Padding(
  //                         //         padding: const EdgeInsets.only(
  //                         //             left: 18.0, top: 2.0),
  //                         //         child: Image.asset(
  //                         //           icDash,
  //                         //           width: 6,
  //                         //         ),
  //                         //       ),
  //                         //       const SizedBox(
  //                         //         width: 12,
  //                         //       ),
  //                         //       getTextWidget(
  //                         //           title:
  //                         //               '${ApplicantDetail[index].noofApplicant!.toString()} Applicants',
  //                         //           textFontSize: fontSize13,
  //                         //           textFontWeight: fontWeightRegular,
  //                         //           textColor: darkblack)
  //                         //     ],
  //                         //   ),
  //                         // ),
  //                         // // const Spacer(),
  //                         // Padding(
  //                         //   padding: const EdgeInsets.only(
  //                         //       bottom: 17.0, right: 10.0, top: 15.0),
  //                         //   child: Row(
  //                         //     children: [
  //                         //       Container(
  //                         //         decoration: BoxDecoration(
  //                         //             borderRadius: BorderRadius.circular(33.0),
  //                         //             color: lightbordercolorpro),
  //                         //         child: Padding(
  //                         //           padding: const EdgeInsets.only(
  //                         //               left: 10.0,
  //                         //               right: 10.0,
  //                         //               top: 2.0,
  //                         //               bottom: 2.0),
  //                         //           child: getTextWidget(
  //                         //               title: ApplicantDetail[index]
  //                         //                   .workType!
  //                         //                   .toString(),
  //                         //               textFontSize: fontSize12,
  //                         //               textFontWeight: fontWeightMedium,
  //                         //               textColor: darkblack),
  //                         //         ),
  //                         //       ),
  //                         //       const SizedBox(
  //                         //         width: 11.0,
  //                         //       ),
  //                         //       Container(
  //                         //         decoration: BoxDecoration(
  //                         //             borderRadius: BorderRadius.circular(33.0),
  //                         //             color: lightbordercolorpro),
  //                         //         child: Padding(
  //                         //           padding: const EdgeInsets.only(
  //                         //               left: 10.0,
  //                         //               right: 10.0,
  //                         //               top: 2.0,
  //                         //               bottom: 2.0),
  //                         //           child: getTextWidget(
  //                         //               title:
  //                         //                   '\$ ${ApplicantDetail[index].payPerhrs!.toString()} per hour',
  //                         //               textFontSize: fontSize12,
  //                         //               textFontWeight: fontWeightMedium,
  //                         //               textColor: darkblack),
  //                         //         ),
  //                         //       ),
  //                         //       const Spacer(),
  //                         //       Image.asset(
  //                         //         icSaved,
  //                         //         height: 24.0,
  //                         //         width: 24.0,
  //                         //         color: darkblack,
  //                         //         fit: BoxFit.cover,
  //                         //       )
  //                         //     ],
  //                         //   ),
  //                         // )
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }),
  //     ),
  //   );
  // }

  getHomeEmpty() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Image.asset(
            ichomeempty,
            height: 146,
            width: 270,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 70, right: 70),
          child: getTextWidget(
              textAlign: TextAlign.center,
              maxLines: 2,
              textColor: darkblack,
              title: AppLocalizations.of(context)!.nothaveanyjobrequest,
              textFontSize: fontSize16,
              textFontWeight: fontWeightSemiBold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: CustomizeButton(
            text: AppLocalizations.of(context)!.createajobs,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyPrimaryBottomTab(
                            from: "job",
                          )));
            },
            buttonWidth: screenSize!.width / 2.2,
          ),
        )
      ],
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
                    builder: ((context) => const MyPrimaryBottomTab(
                          from: 'home',
                        ))));
          },
          child: Container(
            height: 54,
            width: MediaQuery.of(context).size.width,
            color: lightgreypro,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageBuilder: (context, imageProvider) => Container(
                        height: 34.0,
                        width: 34.0,
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
                          height: 34.0,
                          width: 34.0,
                          decoration: const BoxDecoration(
                              color: Colors.grey, shape: BoxShape.circle),
                        ),
                      ),
                      imageUrl: getString('companyimage'),
                      height: 34,
                      width: 34,
                      // fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 5.0, bottom: 8.0),
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
                            title: getString('companyname'),
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
        ));
  }
}

class RecommendedJobs {
  String? companyImg;
  String? companyName;
  String? companyLocation;
  String? work;
  String? daysago;
  int? noofApplicant;
  String? workType;
  String? payPerhrs;
  String? status;

  RecommendedJobs(
      {this.companyImg,
      this.companyName,
      this.companyLocation,
      this.work,
      this.status,
      this.daysago,
      this.noofApplicant,
      this.payPerhrs,
      this.workType});
}

// class ApplicantDetail {
//   String? applicantImg;
//   String? applicantName;
//   String? applicantLocation;
//   String? work;

//   ApplicantDetail(
//       {this.applicantImg,
//       this.applicantLocation,
//       this.applicantName,
//       this.work});
// }
