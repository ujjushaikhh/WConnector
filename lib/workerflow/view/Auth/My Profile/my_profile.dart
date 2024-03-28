import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Edit%20Profile/edit_profile.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/My%20Profile/profile_cell.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Help%20Centre/help_centre.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/dailog.dart';
import '../../../../utils/sharedprefs.dart';
import '../../../../utils/textwidget.dart';
import '../../E-wallet/e_wallet.dart';
import '../../Job Seeking/job_seeking.dart';
import '../../Privacy Policy/privacy_policy.dart';
import '../Login/login.dart';
import '../Edit Profile/My Work History/my_work_history.dart';
import '../Setting/settings.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String getUserimg = getString('userimage');
  String getUsername = getString('username');
  int langid = getInt('lang_id');

  @override
  void initState() {
    super.initState();
    debugPrint(getUserimg);
    debugPrint(getUsername);
    debugPrint('language id $langid');
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: Container(
              height: 87,
              decoration: BoxDecoration(
                  color: bluecolor, borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 10, bottom: 10.0),
                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        height: 67.0,
                        width: 67.0,
                        fit: BoxFit.cover,
                        imageUrl: getUserimg,
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
                            height: 67.0,
                            width: 67.0,
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
                      padding: const EdgeInsets.only(top: 13.0, left: 9.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTextWidget(
                              title: getUsername,
                              textFontSize: fontSize15,
                              textFontWeight: fontWeightMedium,
                              textColor: whitecolor),
                          const SizedBox(
                            height: 4.0,
                          ),
                          getTextWidget(
                            title: 'UI UX Designer',
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightRegular,
                            textColor: whitecolor,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: MyProfileCell(
              iconImg: icEditProfile,
              optionName: AppLocalizations.of(context)!.editprofile,
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyEditWorkerProfile()))
                    .whenComplete(() {
                  setState(() {
                    getUserimg = getString('userimage');
                    getUsername = getString('username');
                  });
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MyProfileCell(
              iconImg: icBlueeye,
              optionName: AppLocalizations.of(context)!.jobseekingstatus,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyJobSeekingStatus()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MyProfileCell(
              iconImg: icWallet,
              optionName: AppLocalizations.of(context)!.myewallet,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyEWallet()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MyProfileCell(
              iconImg: icAffiliate,
              optionName: AppLocalizations.of(context)!.workhistory,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyWorkHistoryEdit()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MyProfileCell(
              iconImg: icSetting,
              optionName: AppLocalizations.of(context)!.settingsstring,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyWorkerSettings()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MyProfileCell(
              iconImg: icQuestion,
              optionName: AppLocalizations.of(context)!.helpcenter,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WorkerHelpCenter()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MyProfileCell(
              iconImg: ictermsandcondition,
              optionName: AppLocalizations.of(context)!.privacy,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyPrivacyPolicy()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: MyProfileCell(
              iconImg: icLogout,
              optionName: AppLocalizations.of(context)!.logout,
              onTap: () {
                showOkCancelAlertDialog(
                    context: context,
                    message: AppLocalizations.of(context)!.wantlogout,
                    okButtonTitle: AppLocalizations.of(context)!.yesstring,
                    cancelButtonTitle: AppLocalizations.of(context)!.nostring,
                    cancelButtonAction: () {},
                    okButtonAction: () async {
                      // await init();
                      // await clear();
                      setString('userlogin', '0');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyWorkerLogin()));
                    });
              },
            ),
          ),

          // ListView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: myprofile.length,
          //     itemBuilder: (context, index) {
          //       return Column(
          //         children: [
          //           GestureDetector(
          //             behavior: HitTestBehavior.translucent,
          //             onTap: () {
          //               if ((myprofile.length - 1) == index) {
          //                 showOkCancelAlertDialog(
          //                     context: context,
          //                     message:
          //                         AppLocalizations.of(context)!.wantlogout,
          //                     okButtonTitle:
          //                         AppLocalizations.of(context)!.yesstring,
          //                     cancelButtonTitle:
          //                         AppLocalizations.of(context)!.nostring,
          //                     cancelButtonAction: () {},
          //                     okButtonAction: () async {
          //                       await init();
          //                       await clear();
          //                       Navigator.pushReplacement(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) =>
          //                                   const MyWorkerLogin()));
          //                     });
          //               } else if (myprofile[index]['route'] != null) {
          //                 if (myprofile[index]['name'] == 'Edit Profile') {
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) => myprofile[index]
          //                               ['route'])).whenComplete(() {
          //                     setState(() {
          //                       getUserimg = getString('userimage');
          //                       getUsername = getString('username');
          //                     });
          //                   });
          //                 } else {
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) =>
          //                               myprofile[index]['route']));
          //                 }
          //               } else {
          //                 if (myprofile[index]['route'] == null) {
          //                   Fluttertoast.showToast(
          //                       msg: 'There is no route');
          //                 }
          //               }
          //             },
          //             child: Padding(
          //               padding: const EdgeInsets.only(top: 10.0),
          //               child: Row(
          //                 children: [
          //                   Container(
          //                     height: 42,
          //                     width: 42,
          //                     decoration: const BoxDecoration(
          //                         image: DecorationImage(
          //                             image: AssetImage(
          //                       icBackgroundProfile,
          //                     ))),
          //                     child: IconButton(
          //                       icon: Image.asset(
          //                         myprofile[index]['icon'],
          //                         height: 24,
          //                         width: 24,
          //                         fit: BoxFit.cover,
          //                       ),
          //                       onPressed: () {},
          //                     ),
          //                   ),
          //                   Padding(
          //                     padding: const EdgeInsets.only(
          //                         left: 19.0, top: 11.0),
          //                     child: Column(
          //                       crossAxisAlignment:
          //                           CrossAxisAlignment.start,
          //                       children: [
          //                         getTextWidget(
          //                             title: myprofile[index]['name'],
          //                             textFontSize: fontSize15,
          //                             textFontWeight: fontWeightMedium,
          //                             textColor: darkblack),
          //                         // const SizedBox(
          //                         //   height: 16.0,
          //                         // ),
          //                         Padding(
          //                           padding:
          //                               const EdgeInsets.only(top: 16.0),
          //                           child: Container(
          //                               height: 1.0,
          //                               width: screenSize!.width - 77,
          //                               decoration: BoxDecoration(
          //                                   border: Border.all(
          //                                       color: dividercolor,
          //                                       width: 1))),
          //                         ),
          //                         // const SizedBox(
          //                         //   height: 6.0,
          //                         // )
          //                       ],
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     })
        ],
      ),
    );
  }

  // List myprofile = [
  //   {
  //     'icon': icEditProfile,
  //     'name': "Edit Profile",
  //     'route': const MyEditWorkerProfile()
  //   },
  //   {
  //     'icon': icBlueeye,
  //     'name': 'Job Seeking Status',
  //     'route': const MyJobSeekingStatus()
  //   },
  //   {'icon': icWallet, 'name': 'My e-Wallet', 'route': const MyEWallet()},
  //   {
  //     'icon': icAffiliate,
  //     'name': 'My Work History',
  //     'route': const MyWorkHistoryEdit()
  //   },
  //   {'icon': icSetting, 'name': 'Settings', 'route': const MyWorkerSettings()},
  //   {
  //     'icon': icQuestion,
  //     'name': 'Help Center',
  //     'route': const WorkerHelpCenter()
  //   },
  //   {
  //     'icon': ictermsandcondition,
  //     'name': 'Privacy Policy',
  //     'route': const MyPrivacyPolicy()
  //   },
  //   {'icon': icLogout, 'name': 'Logout', 'route': null},
  // ];
}
