import 'package:flutter/material.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/view/Auth/Home/home_empty.dart';
import 'package:wconnectorconnectorflow/view/Posted%20Jobs/posted_jobs.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../main.dart';
import '../../utils/textwidget.dart';
import '../Auth/Create Job Request/create_job.dart';
import '../Auth/My Profile/my_profile.dart';

class MyPrimaryBottomTab extends StatefulWidget {
  final String? from;
  const MyPrimaryBottomTab({super.key, this.from});

  @override
  State<MyPrimaryBottomTab> createState() => _MyPrimaryBottomTabState();
}

class _MyPrimaryBottomTabState extends State<MyPrimaryBottomTab> {
  int? notifyCount = 2;

  // Future<void> getNotifycountapi() async {
  //   if (await checkUserConnection()) {
  //     try {
  //       var apiurl = getnotificationcounturl;
  //       debugPrint(apiurl);
  //       var headers = {
  //         'Authorization': 'Bearer ${getString('token')}',
  //         'Content-Type': 'application/json',
  //       };

  //       debugPrint(getString('token'));

  //       var request = http.Request('GET', Uri.parse(apiurl));

  //       request.headers.addAll(headers);

  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var getNotifyCount = NotifyCountModel.fromJson(jsonResponse);
  //       debugPrint(responsed.body);

  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (getNotifyCount.status == 1) {
  //           setState(() {
  //             notifyCount = getNotifyCount.count ?? 0;
  //           });
  //           debugPrint('is it success');
  //         } else {
  //           debugPrint('failed to load');
  //         }
  //       } else if (response.statusCode == 401) {
  //         // ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 404) {
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 400) {
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 500) {
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getNotifyCount.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       }
  //     } catch (e) {
  //       debugPrint("$e");
  //       if (!mounted) return;
  //       vapeAlertDialogue(
  //         context: context,
  //         desc: '$e',
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //         },
  //       ).show();
  //     }
  //   } else {
  //     if (!mounted) return;
  //     vapeAlertDialogue(
  //       context: context,
  //       type: AlertType.info,
  //       desc: 'Please check your internet connection',
  //       onPressed: () {
  //         Navigator.of(context, rootNavigator: true).pop();
  //       },
  //     ).show();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    if (widget.from == 'home') {
      setState(() {
        selectedPage = 3;
      });
    } else if (widget.from == "job") {
      setState(() {
        selectedPage = 1;
      });
    } else {
      setState(() {
        selectedPage = 0;
      });
    }
    debugPrint('${getInt('lang_id')}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      languagechange();
    });

    // getNotifycountapi();
  }

  void languagechange() {
    if (getInt('lang_id') != 1) {
      MyApp.of(context).setLocale(const Locale('pl'));
    } else {
      MyApp.of(context).setLocale(const Locale('en'));
    }
  }

  // void languagechange() {
  //   if (getInt('lang_id') != 1) {
  //     MyApp.of(context).setLocale(
  //         MyApp.of(context).isEnglish ? const Locale('pl') : Locale(''));
  //   } else {
  //     MyApp.of(context).setLocale(
  //         MyApp.of(context).isEnglish ? const Locale('en') : Locale(''));
  //   }
  // }

  int selectedPage = 0;

  final _pageOptions = [
    const MyHomeEmpty(),
    const MyCreateJob(),
    const MyPostedJobs(),
    const MyProfile()
  ];

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: selectedPage == 0
              ? null
              // Container()
              // AppBar(
              //     automaticallyImplyLeading: false,
              //     backgroundColor: darkblack,
              //     elevation: 0.0,
              //     centerTitle: true,
              //     title: getTextWidget(
              //         title: 'Home',
              //         textFontSize: fontSize15,
              //         textFontWeight: fontWeightMedium,
              //         textColor: darkblack),
              //     actions: [
              //       Padding(
              //         padding: const EdgeInsets.only(right: 20),
              //         child: Stack(
              //           children: [
              //             IconButton(
              //               icon: Image.asset(
              //                 icNotification,
              //                 height: 24,
              //                 width: 24,
              //                 color: darkblack,
              //               ),
              //               onPressed: () {
              //                 // Navigator.push(
              //                 //         context,
              //                 //         MaterialPageRoute(
              //                 //             builder: (context) =>
              //                 //                 const MyNotification()))
              //                 //     .whenComplete(() => getNotifycountapi());
              //               },
              //             ),
              //             if (notifyCount! > 0)
              //               Positioned(
              //                 top: -1,
              //                 right: 3,
              //                 child: Container(
              //                   height: 22.0,
              //                   width: 22.0,
              //                   decoration: const BoxDecoration(
              //                     color: bluecolor,
              //                     shape: BoxShape.circle,
              //                   ),
              //                   constraints: const BoxConstraints(
              //                     minWidth: 18.0,
              //                     minHeight: 18.0,
              //                   ),
              //                   child: Center(
              //                     child: Text(
              //                       notifyCount!.toString(),
              //                       style: const TextStyle(
              //                         color: darkblack,
              //                         fontSize: fontSize13,
              //                         fontFamily: fontfamilybeVietnam,
              //                         fontWeight: fontWeightSemiBold,
              //                       ),
              //                       textAlign: TextAlign.center,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   )
              : selectedPage == 1
                  ? AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: whitecolor,
                      elevation: 0.0,
                      centerTitle: true,
                      // leading: IconButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         selectedPage = 0;
                      //       });
                      //     },
                      //     icon: const Icon(
                      //       Icons.arrow_back,
                      //       size: 24.0,
                      //       color: darkblack,
                      //     )),

                      actions: [
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
                          padding: const EdgeInsets.only(right: 20),
                          child: Stack(
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  icNotification,
                                  height: 24,
                                  width: 24,
                                  color: darkblack,
                                ),
                                onPressed: () {
                                  // Navigator.push(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) =>
                                  //                 const MyNotification()))
                                  //     .whenComplete(
                                  //         () => getNotifycountapi());
                                },
                              ),
                              if (notifyCount! > 0)
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
                            ],
                          ),
                        ),
                      ],
                    )
                  : selectedPage == 2
                      ? AppBar(
                          automaticallyImplyLeading: false,
                          leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedPage = 0;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 24.0,
                                color: darkblack,
                              )),
                          elevation: 0.0,
                          centerTitle: true,
                          backgroundColor: whitecolor,
                          title: getTextWidget(
                              title: AppLocalizations.of(context)!.postedjobs,
                              textFontSize: fontSize15,
                              textFontWeight: fontWeightMedium,
                              textColor: darkblack),
                          // actions: [
                          //   Padding(
                          //     padding: const EdgeInsets.only(right: 20),
                          //     child: Stack(
                          //       children: [
                          //         IconButton(
                          //           icon: Image.asset(
                          //             icNotification,
                          //             height: 24,
                          //             width: 24,
                          //             color: darkblack,
                          //           ),
                          //           onPressed: () {
                          //             // Navigator.push(
                          //             //         context,
                          //             //         MaterialPageRoute(
                          //             //             builder: (context) =>
                          //             //                 const MyNotification()))
                          //             //     .whenComplete(
                          //             //         () => getNotifycountapi());
                          //           },
                          //         ),
                          //         if (notifyCount! > 0)
                          //           Positioned(
                          //             top: 1,
                          //             right: 3,
                          //             child: Container(
                          //               height: 22.0,
                          //               width: 22.0,
                          //               decoration: const BoxDecoration(
                          //                 color: bluecolor,
                          //                 shape: BoxShape.circle,
                          //               ),
                          //               constraints: const BoxConstraints(
                          //                 minWidth: 16.0,
                          //                 minHeight: 16.0,
                          //               ),
                          //               child: Center(
                          //                 child: Text(
                          //                   notifyCount!.toString(),
                          //                   style: const TextStyle(
                          //                     color: whitecolor,
                          //                     fontSize: fontSize13,
                          //                     fontFamily: fontfamilybeVietnam,
                          //                     fontWeight: fontWeightSemiBold,
                          //                   ),
                          //                   textAlign: TextAlign.center,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //       ],
                          //     ),
                          //   ),
                          // ],
                        )
                      : selectedPage == 3
                          ? AppBar(
                              automaticallyImplyLeading: false,
                              elevation: 0.0,
                              centerTitle: true,
                              backgroundColor: whitecolor,
                              title: getTextWidget(
                                  title:
                                      AppLocalizations.of(context)!.myprofile,
                                  textFontSize: fontSize15,
                                  textFontWeight: fontWeightMedium,
                                  textColor: darkblack),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Stack(
                                    children: [
                                      IconButton(
                                        icon: Image.asset(
                                          icNotification,
                                          height: 24,
                                          width: 24,
                                          color: darkblack,
                                        ),
                                        onPressed: () {
                                          // Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 const MyNotification()))
                                          //     .whenComplete(
                                          //         () => getNotifycountapi());
                                        },
                                      ),
                                      if (notifyCount! > 0)
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
                                                  fontFamily:
                                                      fontfamilybeVietnam,
                                                  fontWeight:
                                                      fontWeightSemiBold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : AppBar(),
          body: _pageOptions[selectedPage],
          extendBody: true,
          bottomNavigationBar: _createBottomNavigationBar()),
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomAppBar(
      color: whitecolor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildBottomNavItem(AppLocalizations.of(context)!.jobrequests,
              icJobRequest, icJobRequestH, 0),
          buildBottomNavItem(AppLocalizations.of(context)!.createjob, icAddicon,
              icAddiconH, 1),
          buildBottomNavItem(
              AppLocalizations.of(context)!.postedjobs, icblackbag, icbagh, 2),
          buildBottomNavItem(AppLocalizations.of(context)!.myprofile, icProfile,
              icProfileh, 3),
        ],
      ),
    );
  }

  Widget buildBottomNavItem(
    String label,
    String iconPath,
    String activeIconPath,
    int index,
  ) {
    bool isSelected = selectedPage == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedPage = index;
        });
      },
      child: Container(
        width: screenSize!.width / 4.5,
        padding: const EdgeInsets.only(
          left: 8.0,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isSelected ? activeIconPath : iconPath,
              width: 24.0,
              height: 24.0,
            ),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(
                  color: isSelected ? bluecolor : darkblack,
                  fontSize: fontSize12,
                  fontWeight: fontWeightRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (selectedPage != 0) {
      setState(() {
        selectedPage = 0;
      });
      return false; // Do not exit the app
    } else {
      // If already on the home page, allow the app to exit
      return true;
    }
  }
}
