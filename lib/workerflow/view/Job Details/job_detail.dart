import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wconnectorconnectorflow/view/Posted%20Job%20Detail/model/job_detail.dart';
import 'package:http/http.dart' as http;
import 'package:wconnectorconnectorflow/workerflow/view/Job%20Details/model/saved_job_model.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textwidget.dart';
import '../Apply Now/apply_now.dart';

class MyJobDetail extends StatefulWidget {
  final String? jobId;
  final String? userId;
  const MyJobDetail({super.key, this.jobId, this.userId});

  @override
  State<MyJobDetail> createState() => _MyJobDetailState();
}

class _MyJobDetailState extends State<MyJobDetail> {
  @override
  void initState() {
    super.initState();
    getJobDetailapi();
  }

  bool? isSaved;
  int? daysago;
  int? vacancy;
  int? companyId;
  int? totalApplicant;
  String? companyImg;
  String? companyName;
  String? companyAddress;
  String? jobName;
  String? jobStatus;
  String? startDate;
  String? endDate;
  String? endTime;
  String? salary;
  String? salaryType;
  String? companyDescription;
  String? workType;

  bool isload = true;
  Future<void> postSavedapi() async {
    if (await checkUserConnection()) {
      // if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
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
              getJobDetailapi();
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

  Future<void> getJobDetailapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getjobdetailsurl;

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint('Token ${getString('usertoken')}');
        debugPrint('url $apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));
        request.body =
            json.encode({'id': widget.jobId, 'user_id': widget.userId});

        debugPrint('Body :${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getJobDetail = JobDetailModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getJobDetail.status == '1') {
            setState(() {
              companyId = getJobDetail.data!.companyId!;
              companyImg = getJobDetail.data!.userImage!;
              companyName = getJobDetail.data!.companyName!;
              companyAddress = getJobDetail.data!.address!;
              companyDescription = getJobDetail.data!.jobDescription!;
              jobName = getJobDetail.data!.jobName!;
              jobStatus = getJobDetail.data!.companyJobStatus!;
              workType = getJobDetail.data!.workType!;
              salary = getJobDetail.data!.salary!;
              salaryType = getJobDetail.data!.salaryType!;
              startDate = getJobDetail.data!.startDate!;
              endDate = getJobDetail.data!.endDate!;
              isSaved = getJobDetail.data!.favoriteJob!;
              totalApplicant = getJobDetail.data!.totlapplicationCount!;
              vacancy = getJobDetail.data!.vacancies!;
              daysago = getJobDetail.data!.daysAgoCreate!;
              requirement = getJobDetail.data!.jobRequirements!;
              isload = false;
            });
            debugPrint('is it success');
          } else {
            // requirements = [];
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

  List<JobRequirements> requirement = [];

  // String? miniDescriptum gravida velit. Sed vitae nibh quis turpis elementum semper sed nec nisi. Praesent ultrices tincidunt arcu. Nam eleifend est enim, eu pretium lacus sagittis ac. Cras tincidunt ipsum ac leo aliquet, vitae vehicula felis consequat. Nunc eu convallis dui, a laoreet diam. Cras ac maximus velit, ac vestibulum augue. Donec viverra convallis sapien eu sagittis.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        backgroundColor: whitecolor,
        centerTitle: true,
        elevation: 0.0,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.jobdetails,
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
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenSize!.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 68,
                          ),
                          Container(
                            height: 116,
                            width: 116,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                  width: 1, color: lightbordercolorpro),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                imageUrl: companyImg!,
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
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // const Spacer(),
                          Container(
                            height: 24.0,
                            decoration: BoxDecoration(
                                color: jobStatus! == 'Open'
                                    ? greencolor
                                    : lightgreypromax,
                                borderRadius: BorderRadius.circular(33)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.0,
                                  bottom: 2.0,
                                  left: 10.0,
                                  right: 10.0),
                              child: Center(
                                child: getTextWidget(
                                    title: jobStatus == 'Open'
                                        ? AppLocalizations.of(context)!.openword
                                        : AppLocalizations.of(context)!
                                            .closedword,
                                    textFontSize: fontSize12,
                                    textFontWeight: fontWeightMedium,
                                    textColor: whitecolor),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: Center(
                        child: getTextWidget(
                            title: companyName!,
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
                              title: companyAddress!,
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
                          title: jobName!,
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
                                  '$daysago ${AppLocalizations.of(context)!.daysago}',
                              textFontSize: fontSize13,
                              textFontWeight: fontWeightRegular,
                              textColor: bluecolor),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, top: 2.0),
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
                                  '$vacancy ${AppLocalizations.of(context)!.vacancy}',
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
                                  left: 10.0,
                                  right: 10.0,
                                  top: 2.0,
                                  bottom: 2.0),
                              child: Center(
                                child: getTextWidget(
                                    title: workType!,
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
                                  left: 10.0,
                                  right: 10.0,
                                  top: 2.0,
                                  bottom: 2.0),
                              child: Center(
                                child: getTextWidget(
                                    title: '\$ $salary $salaryType',
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
                              isSaved != true ? icSaved : icSavedh,
                              height: 24.0,
                              width: 24.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),

                    getButton(),

                    const SizedBox(height: 20.0),
                    const Divider(
                      color: bordercolor,
                      thickness: 1.0,
                      height: 1.0,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.jobdescription,
                          textFontSize: fontSize18,
                          textFontWeight: fontWeightSemiBold,
                          textColor: darkblack),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 9.0),
                      child: getTextWidget(
                          title: companyDescription!,
                          textFontSize: fontSize13,
                          textFontWeight: fontWeightRegular,
                          textColor: greycolor),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.requirements,
                          textFontSize: fontSize18,
                          textFontWeight: fontWeightSemiBold,
                          textColor: darkblack),
                    ),

                    getRequirement()
                  ],
                ),
              ),
            ),
    );
  }

  getRequirement() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requirement.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 13.0),
              child: Row(
                children: [
                  Image.asset(
                    iccirculartick,
                    height: 16.67,
                    width: 16.67,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 15.33,
                  ),
                  getTextWidget(
                      title: requirement[index].jobRequirements!,
                      textFontSize: fontSize13,
                      textFontWeight: fontWeightRegular,
                      textColor: darkblack)
                ],
              ),
            );
          }),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: jobStatus == "Close"
          ? CustomizeButton(
              text: AppLocalizations.of(context)!.closedword,
              onPressed: () {},
              color: greycolor,
            )
          : CustomizeButton(
              text: AppLocalizations.of(context)!.apply,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyApplyJob(
                              companyId: companyId.toString(),
                              jobId: widget.jobId,
                              comapnayName: companyName,
                              companyAddress: companyAddress,
                              companyImg: companyImg,
                            )));
              },
            ),
    );
  }
}
