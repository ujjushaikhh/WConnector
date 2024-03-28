import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Search%20Screen/model/search_job_model.dart';
import 'package:http/http.dart' as http;
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textwidget.dart';
import '../../../view/Auth/Create Job Request/model/job_frequency.dart';
import '../Job Details/model/saved_job_model.dart';

class MySearchScreen extends StatefulWidget {
  const MySearchScreen({super.key});

  @override
  State<MySearchScreen> createState() => _MySearchScreenState();
}

class _MySearchScreenState extends State<MySearchScreen> {
  @override
  void initState() {
    super.initState();
    getjobfrequencyapi();
  }

  int? isSaved;
  Future<void> postSavedapi(int jobId) async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$addfavjoburl/$jobId}';

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
              // getJobDetailapi();
              isSaved = getJobDetail.isLike!;
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

  int? isRelevant = 0;
  int? isHighest = 0;
  int? isNewlyPosted = 0;
  int? isEndingSoon = 0;
  int? isTimeJobselected = 1;
  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: whitecolor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24.0))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: StatefulBuilder(builder: (context, StateSetter myState) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Center(
                          child: Image.asset(
                        icFilterbar,
                        width: 29,
                        height: 5,
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: Center(
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!.filter,
                            textFontSize: fontSize18,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          myState(() {
                            isRelevant = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: getTextWidget(
                                      title: AppLocalizations.of(context)!
                                          .mostrelavant,
                                      textFontSize: fontSize15,
                                      textFontWeight: fontWeightMedium,
                                      textColor: darkblack),
                                ),
                                Image.asset(
                                  isRelevant == 1
                                      ? icBluetick
                                      : icUncheckBluetick,
                                  height: 24.0,
                                  width: 24.0,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            const Divider(
                              color: dividercolor,
                              thickness: 1.0,
                              height: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          myState(() {
                            isHighest = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: getTextWidget(
                                      title: AppLocalizations.of(context)!
                                          .highestsalary,
                                      textFontSize: fontSize15,
                                      textFontWeight: fontWeightMedium,
                                      textColor: darkblack),
                                ),
                                Image.asset(
                                  isHighest == 1
                                      ? icBluetick
                                      : icUncheckBluetick,
                                  height: 24.0,
                                  width: 24.0,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            const Divider(
                              color: dividercolor,
                              thickness: 1.0,
                              height: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          myState(() {
                            isNewlyPosted = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: getTextWidget(
                                      title: AppLocalizations.of(context)!
                                          .newlyposted,
                                      textFontSize: fontSize15,
                                      textFontWeight: fontWeightMedium,
                                      textColor: darkblack),
                                ),
                                Image.asset(
                                  isNewlyPosted == 1
                                      ? icBluetick
                                      : icUncheckBluetick,
                                  height: 24.0,
                                  width: 24.0,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            const Divider(
                              color: dividercolor,
                              thickness: 1.0,
                              height: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          myState(() {
                            isEndingSoon = 1;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: getTextWidget(
                                      title: AppLocalizations.of(context)!
                                          .endingsoon,
                                      textFontSize: fontSize15,
                                      textFontWeight: fontWeightMedium,
                                      textColor: darkblack),
                                ),
                                Image.asset(
                                  isEndingSoon == 1
                                      ? icBluetick
                                      : icUncheckBluetick,
                                  height: 24.0,
                                  width: 24.0,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            const Divider(
                              color: dividercolor,
                              thickness: 1.0,
                              height: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.frequency,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0),
                      child: SizedBox(
                        height: 45,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: frequency.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      myState(() {
                                        isTimeJobselected = frequency[index].id;
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 13.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: isTimeJobselected ==
                                                    frequency[index].id
                                                ? null
                                                : Border.all(
                                                    color: bordercolor,
                                                    width: 1),
                                            color: isTimeJobselected ==
                                                    frequency[index].id
                                                ? bluecolor
                                                : whitecolor,
                                            borderRadius:
                                                BorderRadius.circular(43)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 13.0,
                                              right: 19.0,
                                              bottom: 14.0,
                                              left: 20),
                                          child: getTextWidget(
                                              title: frequency[index]
                                                  .type!
                                                  .toString(),
                                              textFontSize: fontSize14,
                                              textFontWeight:
                                                  isTimeJobselected ==
                                                          frequency[index].id
                                                      ? fontWeightRegular
                                                      : fontWeightLight,
                                              textColor: isTimeJobselected ==
                                                      frequency[index].id
                                                  ? whitecolor
                                                  : darkblack),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomizeButton(
                              buttonWidth: screenSize!.width / 2.3,
                              text: AppLocalizations.of(context)!.cancel,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              borderColor: bluecolor,
                              color: whitecolor,
                              textcolor: bluecolor),
                          CustomizeButton(
                              buttonWidth: screenSize!.width / 2.3,
                              text: AppLocalizations.of(context)!.apply,
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    )
                  ]
                  //   Container(
                  //     padding: const EdgeInsets.all(16.0),
                  //     child: ListView(
                  //       shrinkWrap: true,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       children: [
                  //         getTextWidget(
                  //             title: 'Filter',
                  //             textFontSize: fontSize18,
                  //             textFontWeight: fontWeightSemiBold,
                  //             textColor: darkblack,
                  //             textAlign: TextAlign.center),

                  //         getTextWidget(title: 'Frequency' , textFontSize: fontSize14, textFontWeight: fontWeightMedium , textColor: darkblack),
                  //         // const SizedBox(
                  //         //   height: 8.0,
                  //         // ),
                  //         // StatefulBuilder(
                  //         //   builder: (BuildContext context,
                  //         //       void Function(void Function()) setState) {
                  //         //     return Row(
                  //         //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         //       children: [
                  //         //         GestureDetector(
                  //         //           onTap: () {
                  //         //             setState(() {

                  //         //             });
                  //         //           },
                  //         //           child: Container(
                  //         //             width: 105,
                  //         //             height: 45,
                  //         //             decoration: BoxDecoration(
                  //         //                 color: isMaleSelected
                  //         //                     ? const Color(0xff594CE4)
                  //         //                     : const Color(0xffFFFFFF),
                  //         //                 borderRadius: BorderRadius.circular(24.0),
                  //         //                 border: Border.all(
                  //         //                     color: const Color(0xffD9DADC))),
                  //         //             child: Center(
                  //         //               child: Text(
                  //         //                 "Male",
                  //         //                 style: TextStyle(
                  //         //                     fontSize: 14,
                  //         //                     fontWeight: FontWeight.w400,
                  //         //                     color: isMaleSelected
                  //         //                         ? Colors.white
                  //         //                         : const Color(0xff7F818B)),
                  //         //               ),
                  //         //             ),
                  //         //           ),
                  //         //         ),
                  //         //         GestureDetector(
                  //         //           onTap: () {
                  //         //             setState(() {
                  //         //               isMaleSelected = false;
                  //         //               isFemaleSelected = true;
                  //         //               isBothSelected = false;
                  //         //             });
                  //         //           },
                  //         //           child: Container(
                  //         //             width: 105,
                  //         //             height: 45,
                  //         //             decoration: BoxDecoration(
                  //         //                 color: isFemaleSelected
                  //         //                     ? const Color(0xff594CE4)
                  //         //                     : const Color(0xffFFFFFF),
                  //         //                 borderRadius: BorderRadius.circular(24.0),
                  //         //                 border: Border.all(
                  //         //                     color: const Color(0xffD9DADC))),
                  //         //             child: Center(
                  //         //               child: Text(
                  //         //                 "Female",
                  //         //                 style: TextStyle(
                  //         //                     fontSize: 14,
                  //         //                     fontWeight: FontWeight.w400,
                  //         //                     color: isFemaleSelected
                  //         //                         ? Colors.white
                  //         //                         : const Color(0xff7F818B)),
                  //         //               ),
                  //         //             ),
                  //         //           ),
                  //         //         ),
                  //         //         GestureDetector(
                  //         //           onTap: () {
                  //         //             setState(() {
                  //         //               isMaleSelected = false;
                  //         //               isFemaleSelected = false;
                  //         //               isBothSelected = true;
                  //         //             });
                  //         //           },
                  //         //           child: Container(
                  //         //             width: 105,
                  //         //             height: 45,
                  //         //             decoration: BoxDecoration(
                  //         //                 color: isBothSelected
                  //         //                     ? const Color(0xff594CE4)
                  //         //                     : const Color(0xffFFFFFF),
                  //         //                 borderRadius: BorderRadius.circular(24.0),
                  //         //                 border: Border.all(
                  //         //                     color: const Color(0xffD9DADC))),
                  //         //             child: Center(
                  //         //               child: Text(
                  //         //                 "Both",
                  //         //                 style: TextStyle(
                  //         //                     fontSize: 14,
                  //         //                     fontWeight: FontWeight.w400,
                  //         //                     color: isBothSelected
                  //         //                         ? Colors.white
                  //         //                         : const Color(0xff7F818B)),
                  //         //               ),
                  //         //             ),
                  //         //           ),
                  //         //         ),
                  //         //       ],
                  //         //     );
                  //         //   },
                  //         // ),
                  //         // const SizedBox(
                  //         //   height: 20.0,
                  //         // ),
                  //         // const Align(
                  //         //   alignment: Alignment.centerLeft,
                  //         //   child: Text(
                  //         //     "Rank",
                  //         //     style: TextStyle(
                  //         //         fontFamily: 'Roboto',
                  //         //         fontSize: 15,
                  //         //         fontWeight: FontWeight.w600,
                  //         //         color: Color(0xff222947)),
                  //         //   ),
                  //         // ),
                  //         // const SizedBox(
                  //         //   height: 8.0,
                  //         // ),
                  //         // StatefulBuilder(
                  //         //   builder: (BuildContext context,
                  //         //       void Function(void Function()) setState) {
                  //         //     return DropdownButtonHideUnderline(
                  //         //       child: DropdownButton2(
                  //         //         style: const TextStyle(color: Colors.white),
                  //         //         isExpanded: true,
                  //         //         hint: const Row(
                  //         //           children: [
                  //         //             SizedBox(
                  //         //               width: 4,
                  //         //             ),
                  //         //             Expanded(
                  //         //               child: Text(
                  //         //                 'Silver',
                  //         //                 style: TextStyle(
                  //         //                   fontSize: 14,
                  //         //                   fontWeight: FontWeight.w400,
                  //         //                   color: Color(0xff7F818B),
                  //         //                 ),
                  //         //                 overflow: TextOverflow.ellipsis,
                  //         //               ),
                  //         //             ),
                  //         //           ],
                  //         //         ),
                  //         //         selectedItemBuilder: (BuildContext context) {
                  //         //           return rankItem.map<Widget>((String item) {
                  //         //             return Align(
                  //         //               alignment: Alignment.centerLeft,
                  //         //               child: Text(
                  //         //                 item,
                  //         //                 style: const TextStyle(
                  //         //                   fontSize: 14,
                  //         //                   fontWeight: FontWeight.bold,
                  //         //                   color: Color(
                  //         //                       0xff7F818B), // Set the selected item text color to white
                  //         //                 ),
                  //         //                 overflow: TextOverflow.ellipsis,
                  //         //               ),
                  //         //             );
                  //         //           }).toList();
                  //         //         },
                  //         //         items: rankItem
                  //         //             .map(
                  //         //               (item) => DropdownMenuItem<String>(
                  //         //                 value: item,
                  //         //                 child: Text(
                  //         //                   item,
                  //         //                   style: const TextStyle(
                  //         //                       fontSize: 14,
                  //         //                       fontWeight: FontWeight.bold,
                  //         //                       color: Color(0xFF222947)),
                  //         //                   overflow: TextOverflow.ellipsis,
                  //         //                 ),
                  //         //               ),
                  //         //             )
                  //         //             .toList(),
                  //         //         value: selectedRank,
                  //         //         onChanged: (value) {
                  //         //           setState(() {
                  //         //             selectedRank = value as String;
                  //         //           });
                  //         //         },
                  //         //         buttonStyleData: ButtonStyleData(
                  //         //           height: 45,
                  //         //           width: MediaQuery.of(context).size.width * 0.7,
                  //         //           padding:
                  //         //               const EdgeInsets.only(left: 14, right: 14),
                  //         //           decoration: BoxDecoration(
                  //         //             borderRadius: BorderRadius.circular(24),
                  //         //             border: Border.all(
                  //         //               color: const Color(0xffD9DADC),
                  //         //             ),
                  //         //             color: Colors.white,
                  //         //           ),
                  //         //           // elevation: 2,
                  //         //         ),
                  //         //         iconStyleData: const IconStyleData(
                  //         //           icon: Icon(
                  //         //             Icons.keyboard_arrow_down,
                  //         //             size: 24,
                  //         //           ),
                  //         //           iconSize: 14,
                  //         //           iconEnabledColor: Colors.black,
                  //         //           iconDisabledColor: Colors.black,
                  //         //         ),
                  //         //         dropdownStyleData: DropdownStyleData(
                  //         //           maxHeight: 200,
                  //         //           width: MediaQuery.of(context).size.width * 0.7,
                  //         //           padding: null,
                  //         //           decoration: BoxDecoration(
                  //         //               borderRadius: BorderRadius.circular(14),
                  //         //               color: Colors.white),
                  //         //           scrollbarTheme: ScrollbarThemeData(
                  //         //             radius: const Radius.circular(40),
                  //         //             thickness: MaterialStateProperty.all<double>(6),
                  //         //             thumbVisibility:
                  //         //                 MaterialStateProperty.all<bool>(true),
                  //         //           ),
                  //         //         ),
                  //         //         menuItemStyleData: const MenuItemStyleData(
                  //         //           height: 40,
                  //         //           padding: EdgeInsets.only(left: 14, right: 14),
                  //         //         ),
                  //         //       ),
                  //         //     );
                  //         //   },
                  //         // ),
                  //         // const SizedBox(
                  //         //   height: 20.0,
                  //         // ),
                  //         // const Align(
                  //         //   alignment: Alignment.centerLeft,
                  //         //   child: Text(
                  //         //     "Rating",
                  //         //     style: TextStyle(
                  //         //         fontFamily: 'Roboto',
                  //         //         fontSize: 15,
                  //         //         fontWeight: FontWeight.w600,
                  //         //         color: Color(0xff222947)),
                  //         //   ),
                  //         // ),
                  //         // const SizedBox(
                  //         //   height: 8.0,
                  //         // ),
                  //         // StatefulBuilder(
                  //         //   builder: (BuildContext context,
                  //         //       void Function(void Function()) setState) {
                  //         //     return DropdownButtonHideUnderline(
                  //         //       child: DropdownButton2(
                  //         //         style: const TextStyle(color: Colors.white),
                  //         //         isExpanded: true,
                  //         //         hint: const Row(
                  //         //           children: [
                  //         //             SizedBox(
                  //         //               width: 4,
                  //         //             ),
                  //         //             Expanded(
                  //         //               child: Text(
                  //         //                 '4.0',
                  //         //                 style: TextStyle(
                  //         //                   fontSize: 14,
                  //         //                   fontWeight: FontWeight.w400,
                  //         //                   color: Color(0xff7F818B),
                  //         //                 ),
                  //         //                 overflow: TextOverflow.ellipsis,
                  //         //               ),
                  //         //             ),
                  //         //           ],
                  //         //         ),
                  //         //         selectedItemBuilder: (BuildContext context) {
                  //         //           return ratingItem.map<Widget>((String item) {
                  //         //             return Align(
                  //         //               alignment: Alignment.centerLeft,
                  //         //               child: Text(
                  //         //                 item,
                  //         //                 style: const TextStyle(
                  //         //                   fontSize: 14,
                  //         //                   fontWeight: FontWeight.bold,
                  //         //                   color: Color(
                  //         //                       0xff7F818B), // Set the selected item text color to white
                  //         //                 ),
                  //         //                 overflow: TextOverflow.ellipsis,
                  //         //               ),
                  //         //             );
                  //         //           }).toList();
                  //         //         },
                  //         //         items: ratingItem
                  //         //             .map(
                  //         //               (item) => DropdownMenuItem<String>(
                  //         //                 value: item,
                  //         //                 child: Text(
                  //         //                   item,
                  //         //                   style: const TextStyle(
                  //         //                       fontSize: 14,
                  //         //                       fontFamily: 'Roboto',
                  //         //                       fontWeight: FontWeight.bold,
                  //         //                       color: Color(0xFF222947)),
                  //         //                   overflow: TextOverflow.ellipsis,
                  //         //                 ),
                  //         //               ),
                  //         //             )
                  //         //             .toList(),
                  //         //         value: selectedRating,
                  //         //         onChanged: (value) {
                  //         //           setState(() {
                  //         //             selectedRating = value as String;
                  //         //           });
                  //         //         },
                  //         //         buttonStyleData: ButtonStyleData(
                  //         //           height: 45,
                  //         //           width: MediaQuery.of(context).size.width * 0.7,
                  //         //           padding:
                  //         //               const EdgeInsets.only(left: 14, right: 14),
                  //         //           decoration: BoxDecoration(
                  //         //             borderRadius: BorderRadius.circular(24),
                  //         //             border: Border.all(
                  //         //               color: const Color(0xffD9DADC),
                  //         //             ),
                  //         //             color: Colors.white,
                  //         //           ),
                  //         //           // elevation: 2,
                  //         //         ),
                  //         //         iconStyleData: const IconStyleData(
                  //         //           icon: Icon(
                  //         //             Icons.keyboard_arrow_down,
                  //         //             size: 24,
                  //         //           ),
                  //         //           iconSize: 14,
                  //         //           iconEnabledColor: Colors.black,
                  //         //           iconDisabledColor: Colors.black,
                  //         //         ),
                  //         //         dropdownStyleData: DropdownStyleData(
                  //         //           maxHeight: 200,
                  //         //           width: MediaQuery.of(context).size.width * 0.7,
                  //         //           padding: null,
                  //         //           decoration: BoxDecoration(
                  //         //               borderRadius: BorderRadius.circular(14),
                  //         //               color: Colors.white),
                  //         //           scrollbarTheme: ScrollbarThemeData(
                  //         //             radius: const Radius.circular(40),
                  //         //             thickness: MaterialStateProperty.all<double>(6),
                  //         //             thumbVisibility:
                  //         //                 MaterialStateProperty.all<bool>(true),
                  //         //           ),
                  //         //         ),
                  //         //         menuItemStyleData: const MenuItemStyleData(
                  //         //           height: 40,
                  //         //           padding: EdgeInsets.only(left: 14, right: 14),
                  //         //         ),
                  //         //       ),
                  //         //     );
                  //         //   },
                  //         // ),
                  //         // const SizedBox(
                  //         //   height: 20.0,
                  //         // ),
                  //         // Row(
                  //         //   children: [
                  //         //     // MyClickButton(
                  //         //     //     text: 'Apply',
                  //         //     //     onPressed: () {
                  //         //     //       postfilterapi();
                  //         //     //     }),
                  //         //   ],
                  //         // ),
                  //         // const SizedBox(
                  //         //   height: 20.0,
                  //         // ),
                  //         // TextButton(
                  //         //     onPressed: () {
                  //         //       Navigator.pop(context);
                  //         //     },
                  //         //     child: const Text(
                  //   //             "Cancel ",
                  //   //             style: TextStyle(
                  //   //                 fontSize: 15.0,
                  //   //                 fontWeight: FontWeight.w700,
                  //   //                 color: Color(0xff594CE4)),
                  //   //           )),
                  //   //     ],
                  //   //   ),
                  //   // ),
                  // ]))],

                  );
            }),
          );
        });
  }

  List<SearchData> recommendedJobs = [];
  List<Data> frequency = [];

  Future<void> getSearchJobsapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = userjobsearchurl;

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(' Token ${getString('usertoken')}');
        debugPrint('url $apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));
        request.body = json.encode({
          "Most_Relavant": isRelevant.toString(),
          "Highest_Salary": isHighest.toString(),
          "Ending_Soon": isEndingSoon.toString(),
          "Newly_Posted": isNewlyPosted.toString(),
          "search_data": _searchcontroller.text.toString(),
          "frequency": isTimeJobselected.toString()
        });

        debugPrint(' Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getSearchJobs = SearchJobModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getSearchJobs.status == '1') {
            setState(() {
              recommendedJobs = getSearchJobs.data ?? [];
              // isload = false;
            });
            debugPrint('is it success');
          } else {
            setState(() {
              recommendedJobs = [];
              // isload = false;
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
        type: AlertType.info,
        context: context,
        desc: 'Check Internet Connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  Future<void> getjobfrequencyapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getworktypedropdownurl?id=${getInt('lang_id')}';
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var jobFrequencyPerHrs = JobFrequencyModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (jobFrequencyPerHrs.status == '1') {
            setState(() {
              frequency = jobFrequencyPerHrs.data!;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
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

  final _searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
        backgroundColor: whitecolor,
        body: Column(
          children: [
            getAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    recommendedJobs.isNotEmpty ? getNoOfJob() : Container(),
                    recommendedJobs.isNotEmpty
                        ? getRecommendedJobs()
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 150.0),
                              child: getTextWidget(
                                  title: AppLocalizations.of(context)!.nojobs,
                                  textFontSize: fontSize20,
                                  textFontWeight: fontWeightSemiBold,
                                  textColor: darkblack),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  getNoOfJob() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0),
      child: Row(
        children: [
          getTextWidget(
              title: recommendedJobs.length.toString(),
              textFontSize: fontSize15,
              textFontWeight: fontWeightSemiBold,
              textColor: darkblack),
          getTextWidget(
              title: AppLocalizations.of(context)!.jobfoundsword,
              textFontSize: fontSize15,
              textFontWeight: fontWeightLight,
              textColor: darkblack)
        ],
      ),
    );
  }

  getRecommendedJobs() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 17.0, left: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTextWidget(
                                        title:
                                            recommendedJobs[index].companyName!,
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
                                            title: recommendedJobs[index]
                                                .companyAddress!,
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
                                      borderRadius: BorderRadius.circular(33)),
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
                                          title: recommendedJobs[index]
                                              .workType!
                                              .toString(),
                                          // .toString(),
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
                                          title:
                                              '\$ ${recommendedJobs[index].salary!.toString()} ${recommendedJobs[index].salaryType!.toString()}',
                                          textFontSize: fontSize12,
                                          textFontWeight: fontWeightMedium,
                                          textColor: darkblack),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    postSavedapi(recommendedJobs[index].jobId!);
                                  },
                                  child: Image.asset(
                                    isSaved == 0 ? icSaved : icSavedh,
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
                );
              }),
        ),
      ),
    );
  }

  getAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 68.0),
      child: Row(
        children: [
          IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: darkblack,
                size: 24.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          Padding(
            padding: const EdgeInsets.only(right: 13.0),
            child: SizedBox(
              height: 45,
              // width: ,
              width: screenSize!.width - 101,
              child: PrimaryTextFeild(
                hintText: AppLocalizations.of(context)!.searctext,
                prefixIcon: icSearch,
                onfeildSubmitted: (value) {
                  getSearchJobsapi();
                },
                suffixiconcolor: greycolor,
                autoFocus: true,
                suffixIcon: _searchcontroller.text.isNotEmpty ? icClose : null,
                controller: _searchcontroller,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: GestureDetector(
              onTap: () {
                showFilterBottomSheet(context);
              },
              child: Image.asset(
                icFilter,
                height: 24.0,
                color: greycolor, width: 24.0,
                // fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
