import 'package:flutter/material.dart';

import 'package:wconnectorconnectorflow/constants/color_constants.dart';

import '../../constants/font_constants.dart';

import '../../utils/textwidget.dart';

class MyNotification extends StatefulWidget {
  const MyNotification({super.key});

  @override
  State<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends State<MyNotification> {
  @override
  void initState() {
    super.initState();
    // getnotiapi();
  }

  String? dateformat = '';
  List<NotificationList> notificationlist = [
    NotificationList(
        date: '12 Nov 24',
        notification:
            'Hey, New Order ID FIAH0939933 is available to be accepted. Please accept it within 15 mins of time frame erase you will lose it.')
  ];
  bool isload = true;

  // Future<void> getnotiapi() async {
  //   if (await checkUserConnection()) {
  //     if (!mounted) return;
  //     ProgressDialogUtils.showProgressDialog(context);
  //     try {
  //       var apiurl = getnotificationurl;
  //       debugPrint(apiurl);
  //       var headers = {
  //         'authkey': 'Bearer ${getString('token')}',
  //         'Content-Type': 'application/json',
  //       };

  //       debugPrint(getString('token'));

  //       var request = http.Request('GET', Uri.parse(apiurl));
  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var getnoti = NotificationModel.fromJson(jsonResponse);

  //       debugPrint(responsed.body);

  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (getnoti.status == 1) {
  //           setState(() {
  //             notificationlist = getnoti.data!;
  //             if (notificationlist.isNotEmpty) {
  //               for (var datetime in notificationlist) {
  //                 DateTime date = DateTime.parse(datetime.createdAt!).toLocal();
  //                 dateformat = DateFormat('dd MMM yyyy').format(date);
  //               }
  //               isload = false;
  //             }
  //           });
  //           debugPrint('is it success');
  //         } else {
  //           debugPrint('failed to load');
  //           ProgressDialogUtils.dismissProgressDialog();
  //           notificationlist = [];
  //           isload = false;
  //         }
  //       } else if (response.statusCode == 401) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getnoti.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 404) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getnoti.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 400) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getnoti.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 500) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         vapeAlertDialogue(
  //           context: context,
  //           desc: '${getnoti.message}',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       }
  //     } catch (e) {
  //       ProgressDialogUtils.dismissProgressDialog();
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
  //       desc: 'Check Internet Connection',
  //       onPressed: () {
  //         Navigator.of(context, rootNavigator: true).pop();
  //       },
  //     ).show();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whitecolor,
        title: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: getTextWidget(
            title: 'Notification',
            textFontSize: fontSize15,
            textFontWeight: fontWeightSemiBold,
            textColor: darkblack,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: darkblack,
              )),
        ),
      ),
      body: notificationlist.isEmpty
          ? Center(
              child: getTextWidget(
                  title: 'No Notification are there',
                  textColor: darkblack,
                  textFontSize: fontSize20,
                  textFontWeight: fontWeightSemiBold))
          : ListView.builder(
              itemCount: notificationlist.length,
              itemBuilder: (context, index) {
                // List<String> parts =
                //     notificationlist[index].notiMsg!.split('ID: #82671866457');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 16.0,
                          left: 16.0,
                          right: 26.0,
                        ),
                        child: getTextWidget(
                            title: notificationlist[index].notification!,
                            textColor: darkblack,
                            textFontSize: fontSize14,
                            textFontWeight: fontWeightMedium)
                        // RichText(
                        //   text: TextSpan(
                        //       style: const TextStyle(
                        //           color: darkblack,
                        //           fontSize: fontSize13,
                        //           fontFamily: fontfamilybeVietnam,
                        //           fontWeight: fontWeightRegular),
                        //       //  getTextWidget(
                        //       //   title: notificationlist[index].notification.toString(),
                        //       //   textFontSize: fontSize13,
                        //       //   textFontWeight: fontWeightRegular,
                        //       //   textColor: darkblack),,
                        //       children: [
                        //         TextSpan(text: parts[0]),
                        //         const TextSpan(
                        //             text: ,
                        //             style: TextStyle(
                        //                 color: darkblack,
                        //                 fontSize: fontSize13,
                        //                 fontFamily: fontfamilybeVietnam,
                        //                 fontWeight: fontWeightSemiBold)),
                        //         TextSpan(text: parts[1])
                        //       ]),
                        // ),
                        ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 16),
                      child: getTextWidget(
                          title: notificationlist[index].date!,
                          textFontSize: fontSize13,
                          textFontWeight: fontWeightRegular,
                          textColor: blackcolor),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Divider(
                        color: dividercolor,
                        thickness: 1.0,
                        height: 2.0,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class NotificationList {
  String? notification;
  String? date;

  NotificationList({this.notification, this.date});
}
