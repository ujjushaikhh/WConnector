import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../main.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textwidget.dart';
import '../Applied Jobs/applied_jobs.dart';
import '../Auth/Home/home.dart';
import '../Auth/My Profile/my_profile.dart';
import '../Saved Jobs/saved_jobs.dart';

class WorkerPrimaryBottomTab extends StatefulWidget {
  final String? from;
  const WorkerPrimaryBottomTab({super.key, this.from});

  @override
  State<WorkerPrimaryBottomTab> createState() => _WorkerPrimaryBottomTabState();
}

class _WorkerPrimaryBottomTabState extends State<WorkerPrimaryBottomTab> {
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

  int selectedPage = 0;

  final _pageOptions = [
    const MyHome(),
    const MySavedJobs(),
    const MyAplliedJobs(),
    const MyProfile()
  ];

  @override
  Widget build(BuildContext context) {
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
                      title: getTextWidget(
                          title: AppLocalizations.of(context)!.savedjobs,
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
                          elevation: 0.0,
                          centerTitle: true,
                          backgroundColor: whitecolor,
                          title: getTextWidget(
                              title: AppLocalizations.of(context)!.appliedjobs,
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
      child: SizedBox(
        // width: screenSize!.width - 34,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildBottomNavItem(
                AppLocalizations.of(context)!.home, icHome, icHomeh, 0),
            buildBottomNavItem(
                AppLocalizations.of(context)!.saved, icSaved, icSavedh, 1),
            buildBottomNavItem(AppLocalizations.of(context)!.appliedjobs,
                icblackbag, icbagh, 2),
            buildBottomNavItem(AppLocalizations.of(context)!.myprofile,
                icProfile, icProfileh, 3),
          ],
        ),
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
        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isSelected ? activeIconPath : iconPath,
              width: 24.0,
              height: 24.0,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? bluecolor : darkblack,
                fontSize: fontSize12,
                fontWeight: fontWeightRegular,
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
