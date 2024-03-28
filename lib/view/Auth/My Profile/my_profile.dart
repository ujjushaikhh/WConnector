import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/view/Auth/Company%20Profile%20Edit/company_profile.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wconnectorconnectorflow/view/Auth/Login/login.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/dailog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textwidget.dart';
import '../../../workerflow/view/Auth/My Profile/profile_cell.dart';
import '../../Help Centre/help_centre.dart';
import '../../Privacy Policy/privacy_policy.dart';
import '../../Setting/settings.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String? companyName = getString('companyname');
  String? companyImg = getString('companyimage');
  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        child: Container(
                          color: whitecolor,
                          child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                              height: 67.0,
                              width: 67.0,
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
                                    color: Colors.grey, shape: BoxShape.circle),
                              ),
                            ),
                            imageUrl: getString('companyimage'),
                            height: 67.0,
                            width: 67.0,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 13.0, left: 9.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getTextWidget(
                                title: getString('companyname'),
                                textFontSize: fontSize15,
                                textFontWeight: fontWeightMedium,
                                textColor: whitecolor),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Opacity(
                              opacity: 0.7,
                              child: getTextWidget(
                                title: 'Garut, Angola',
                                textFontSize: fontSize13,
                                textFontWeight: fontWeightRegular,
                                textColor: whitecolor,
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

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: MyProfileCell(
                iconImg: icEditProfile,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyCompanyEditProfile()));
                },
                optionName: AppLocalizations.of(context)!.companydetails,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: MyProfileCell(
                iconImg: icSetting,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MySetting()));
                },
                optionName: AppLocalizations.of(context)!.settingsstring,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: MyProfileCell(
                iconImg: icQuestion,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHelpCentre()));
                },
                optionName: AppLocalizations.of(context)!.helpcenter,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: MyProfileCell(
                iconImg: ictermsandcondition,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyPrivacyPolicy()));
                },
                optionName: AppLocalizations.of(context)!.privacy,
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
                        setString('comapnylogin', '0');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyLogin()));
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
            //                     message: 'Are you sure you want to logout ',
            //                     okButtonTitle: 'Yes',
            //                     cancelButtonTitle: 'No',
            //                     cancelButtonAction: () {},
            //                     okButtonAction: () async {
            //                       await init();
            //                       await clear();
            //                       Navigator.pushReplacement(
            //                           context,
            //                           MaterialPageRoute(
            //                               builder: (context) =>
            //                                   const MyLogin()));
            //                     });
            //               } else if (myprofile[index]['route'] !=
            //                   'Company Details') {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => myprofile[index]
            //                             ['route'])).whenComplete(() {
            //                   setState(() {
            //                     companyImg = getString('companyimage');
            //                     companyName = getString('companyname');
            //                   });
            //                 });
            //               } else if (myprofile[index]['route'] != null) {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) =>
            //                             myprofile[index]['route']));
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
            //                               height: 1,
            //                               width: screenSize!.width - 77,
            //                               decoration: BoxDecoration(
            //                                   border: Border.all(
            //                                 color: dividercolor,
            //                               ))),
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
      ),
    );
  }

  List myprofile = [
    {
      'icon': icEditProfile,
      'name': 'Company Details',
      'route': const MyCompanyEditProfile()
    },
    {'icon': icSetting, 'name': 'Settings', 'route': const MySetting()},
    {'icon': icQuestion, 'name': 'Help Center', 'route': const MyHelpCentre()},
    {
      'icon': ictermsandcondition,
      'name': 'Privacy Policy',
      'route': const MyPrivacyPolicy()
    },
    {'icon': icLogout, 'name': 'Logout', 'route': null},
  ];
}
