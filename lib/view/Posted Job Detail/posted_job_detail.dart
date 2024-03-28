import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wconnectorconnectorflow/constants/color_constants.dart';
import 'package:wconnectorconnectorflow/view/Posted%20Job%20Detail/model/job_detail.dart';
import 'package:wconnectorconnectorflow/view/View%20Applicant/view_aaplicant.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../utils/button.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';

class MyPostedJobDetail extends StatefulWidget {
  final int? jobId;
  const MyPostedJobDetail({super.key, this.jobId});

  @override
  State<MyPostedJobDetail> createState() => _MyPostedJobDetailState();
}

class _MyPostedJobDetailState extends State<MyPostedJobDetail> {
  @override
  void initState() {
    super.initState();
    getJobDetailTypesapi();
  }

  bool isLoad = true;

  String? jobName;
  String? daysago;
  String? noofapplicants;
  String? worktype;
  String? salary;
  String? salaryType;
  String? status;
  String? jobDescription;
  String? startingDate;
  DateTime? formattedDate;
  String? date;

  Future<void> getJobDetailTypesapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getjobdetailsurl;

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({"id": widget.jobId!.toString()});
        debugPrint('Body :-${request.body}');
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
              jobName = getJobDetail.data!.jobName.toString();
              daysago = getJobDetail.data!.daysAgoCreate.toString();
              noofapplicants =
                  getJobDetail.data!.totlapplicationCount.toString();
              worktype = getJobDetail.data!.workType.toString();
              salary = getJobDetail.data!.salary.toString();
              salaryType = getJobDetail.data!.salaryType.toString();
              status = getJobDetail.data!.companyJobStatus.toString();
              jobDescription = getJobDetail.data!.jobDescription.toString();
              requirement = getJobDetail.data!.jobRequirements ?? [];
              startingDate = getJobDetail.data!.startDate.toString();
              formattedDate = DateTime.parse(startingDate!);
              date = DateFormat('dd MMM yyyy').format(formattedDate!);

              isLoad = false;
            });
            debugPrint('is it success');
            debugPrint('No of Applicants:- $noofapplicants');
          } else {
            debugPrint('failed to load :-${getJobDetail.message}');

            ProgressDialogUtils.dismissProgressDialog();
          }
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

  List<JobRequirements> requirement = [];

  // String? miniDescription =
  //     "Suspendisse dictum gravida velit. Sed vitae nibh quis turpis elementum semper sed nec nisi. Praesent ultrices tincidunt arcu. Nam eleifend est enim, eu pretium lacus sagittis ac. Cras tincidunt ipsum ac leo aliquet, vitae vehicula felis consequat. Nunc eu convallis dui, a laoreet diam. Cras ac maximus velit, ac vestibulum augue. Donec viverra convallis sapien eu sagittis.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        centerTitle: true,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.postedjobdetail,
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
      body: isLoad
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
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getTextWidget(
                                title: jobName!.toString(),
                                textFontSize: fontSize15,
                                textFontWeight: fontWeightMedium,
                                textColor: darkblack),
                            Image.asset(
                              icMore,
                              height: 24.0,
                              width: 24.0,
                              color: darkblack,
                              fit: BoxFit.cover,
                            )
                          ],
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
                                      '$noofapplicants ${AppLocalizations.of(context)!.applicants}',
                                  textFontSize: fontSize13,
                                  textFontWeight: fontWeightRegular,
                                  textColor: darkblack)
                            ],
                          ),
                        ),
                        // const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                          ),
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
                                        title: worktype!.toString(),
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
                              Container(
                                height: 24.0,
                                decoration: BoxDecoration(
                                    color: status == 'Open'
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
                                        title: status == 'Open'
                                            ? AppLocalizations.of(context)!
                                                .openword
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

                        getButton(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Divider(
                    color: boxborderpro,
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                    child: getTextWidget(
                        title: AppLocalizations.of(context)!.jobdescription,
                        textFontSize: fontSize18,
                        textFontWeight: fontWeightSemiBold,
                        textColor: darkblack),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 9.0, left: 16.0, right: 16.0),
                    child: getTextWidget(
                        title: jobDescription!.toString(),
                        textFontSize: fontSize13,
                        textFontWeight: fontWeightRegular,
                        textColor: greycolor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 16.0),
                    child: getTextWidget(
                        title: AppLocalizations.of(context)!.startingdate,
                        textFontSize: fontSize18,
                        textFontWeight: fontWeightSemiBold,
                        textColor: darkblack),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          icCalendar,
                          height: 24.0,
                          width: 24.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 9.0,
                        ),
                        getTextWidget(
                            title: date!.toString(),
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightRegular,
                            textColor: darkblack)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 16.0),
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
    );
  }

  getRequirement() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0, left: 16.0),
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
                      title: requirement[index].jobRequirements.toString(),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        CustomizeButton(
          buttonHeight: 45,
          buttonWidth: screenSize!.width / 2.3,
          text: AppLocalizations.of(context)!.applicants,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyViewApplicant(
                          type: 0,
                          jobId: widget.jobId,
                          daysAgo: daysago,
                          jobName: jobName,
                          status: status,
                          noOfapplicants: noofapplicants,
                          salary: salary,
                          salaryType: salaryType,
                          workType: worktype,
                        )));
          },
        ),
        // const SizedBox(
        //   width: 4,
        // ),
        // CustomizeButton(
        //   buttonHeight: 45,
        //   buttonWidth: screenSize!.width / 3.5,
        //   text: 'Select',
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => const MyViewApplicant()));
        //   },
        // ),
        const SizedBox(
          width: 4,
        ),
        CustomizeButton(
          buttonWidth: screenSize!.width / 2.3,
          buttonHeight: 45,
          text: AppLocalizations.of(context)!.hired,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyViewApplicant(
                          type: 1,
                          status: status,
                          jobId: widget.jobId,
                          daysAgo: daysago,
                          jobName: jobName,
                          noOfapplicants: noofapplicants,
                          salary: salary,
                          salaryType: salaryType,
                          workType: worktype,
                        )));
          },
        )
      ]),
    );
  }
}
