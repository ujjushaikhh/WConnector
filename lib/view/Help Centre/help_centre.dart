import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wconnectorconnectorflow/utils/dailog.dart';
import 'package:wconnectorconnectorflow/utils/validation.dart';
import 'package:wconnectorconnectorflow/view/Help%20Centre/model/contact_usmodel.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textwidget.dart';
import '../../workerflow/view/Help Centre/model/help_center_model.dart';
import '../../workerflow/view/Help Centre/model/help_detail_model.dart';

class MyHelpCentre extends StatefulWidget {
  const MyHelpCentre({super.key});

  @override
  State<MyHelpCentre> createState() => _MyHelpCentreState();
}

class _MyHelpCentreState extends State<MyHelpCentre> {
  Future<void> contactusapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = contactusurl;

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body =
            json.encode({"message": _messagecontroller.text.toString()});
        debugPrint('Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getContactus = ContactUsModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getContactus.status == '1') {
            setState(() {
              Fluttertoast.showToast(msg: ' ${getContactus.message}');
              _messagecontroller.clear();
              _fullnamecontroller.clear();
              Navigator.pop(context);
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load :-${getContactus.message}');

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

  int? faqtitleid = 1;
  int? faqtitledetailid;

  @override
  void initState() {
    super.initState();
    getFaqTitleapi();
    getFaqDetailapi(1, showProgress: false);
  }

  Future<void> getFaqDetailapi(int titleid, {bool showProgress = true}) async {
    if (await checkUserConnection()) {
      if (showProgress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = '$getuserfaqtitleditailsurl/$titleid';
        debugPrint(' url :- $apiurl');
        var headers = {
          'Authorization': 'Bearer' '${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getfaqDetail = GetFaqDetalModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getfaqDetail.status == '1') {
            setState(() {
              help = getfaqDetail.faqTitleDetails ?? [];
              isload = false;
            });
            debugPrint('is it success');
          } else {
            setState(() {
              isload = false;
              help = [];
            });

            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getfaqDetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getfaqDetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getfaqDetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getfaqDetail.message}',
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

  Future<void> getFaqTitleapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getuserfaqtitleurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer' '${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getfaqTitle = GetFaqTitleModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getfaqTitle.status == '1') {
            setState(() {
              helptype = getfaqTitle.faqTitles!;
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
            desc: '${getfaqTitle.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getfaqTitle.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getfaqTitle.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getfaqTitle.message}',
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
  final _fullnamecontroller = TextEditingController();
  final _messagecontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  List<FaqTitleDetails> help = [];
  List<FaqTitles> helptype = [];

  final List<FaqTitleDetails> _searchfaqtitledetail = [];

  int? selectedIndex = 0;
  bool isload = true;

  void onSearchTextChanged(String text) async {
    _searchfaqtitledetail.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var faqDetail in help) {
      if (faqDetail.title!.contains(text)) {
        _searchfaqtitledetail.add(faqDetail);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitecolor,
        appBar: AppBar(
          centerTitle: true,
          title: getTextWidget(
              title: AppLocalizations.of(context)!.helpcenter,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              getTitleBar(),
              selectedIndex == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getHelptype(),
                        getSearchBar(),
                        isload
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.transparent,
                                ),
                              )
                            : help.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 50.0, left: 36.0, right: 36.0),
                                    child: Center(
                                      child: getTextWidget(
                                          title: AppLocalizations.of(context)!
                                              .nohelp,
                                          textFontSize: fontSize20,
                                          textColor: darkblack,
                                          textAlign: TextAlign.center),
                                    ),
                                  )
                                : getWorkConnectorHelp()
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: getTextWidget(
                                  title: AppLocalizations.of(context)!.fullname,
                                  textFontSize: fontSize14,
                                  textFontWeight: fontWeightMedium,
                                  textColor: darkblack),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 9.0,
                              ),
                              child: PrimaryTextFeild(
                                hintText:
                                    AppLocalizations.of(context)!.fullname,
                                autoValidate:
                                    AutovalidateMode.onUserInteraction,
                                validation: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .requiredname;
                                  }
                                  return null;
                                },
                                controller: _fullnamecontroller,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: getTextWidget(
                                  title: AppLocalizations.of(context)!.message,
                                  textFontSize: fontSize14,
                                  textFontWeight: fontWeightMedium,
                                  textColor: darkblack),
                            ),
                            getMessage(),
                            getButton()
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 15),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.submit,
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              contactusapi();
            }
          }),
    );
  }

  getMessage() {
    return Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => Validation.validateText(value),
          controller: _messagecontroller,
          maxLines: 25,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.writehere,
            hintStyle: const TextStyle(
                color: hintcolor,
                fontSize: fontSize14,
                fontFamily: fontfamilybeVietnam,
                fontWeight: fontWeightLight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: bordercolor, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordererror),
            ),
          ),
        )
        // PrimaryTextFeild(
        //   controller: _acccontroller,
        //   hintText: "Write here",
        //   fontSize: fontSize14,
        //   keyboardType: TextInputType.number,
        //   fontWeight: fontWeightLight,
        // ),
        );
  }

  getWorkConnectorHelp() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
      child: _searchcontroller.text.isNotEmpty ||
              _searchfaqtitledetail.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchfaqtitledetail.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        width: screenSize!.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            // borderRadius: const BorderRadius.only(
                            //     topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            border:
                                Border.all(width: 1, color: boxbordercolor)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20,
                                  top: 11.0,
                                  bottom: 12.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    faqtitledetailid =
                                        _searchfaqtitledetail[index].id!;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, bottom: 2.0),
                                      child: getTextWidget(
                                          title: _searchfaqtitledetail[index]
                                              .title!,
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor:
                                              _searchfaqtitledetail[index].id ==
                                                      faqtitledetailid
                                                  ? bluecolor
                                                  : darkblack),
                                    ),
                                    Image.asset(
                                      _searchfaqtitledetail[index].id ==
                                              faqtitledetailid
                                          ? icbluearrowdown
                                          : icArrowright,
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.cover,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (_searchfaqtitledetail[index].id ==
                                faqtitledetailid)
                              const Divider(
                                color: boxbordercolor,
                                thickness: 1.0,
                                height: 1.0,
                              ),
                            if (_searchfaqtitledetail[index].id ==
                                faqtitledetailid)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20, bottom: 14),
                                child: getTextWidget(
                                    title:
                                        _searchfaqtitledetail[index].message!,
                                    textFontSize: fontSize14,
                                    textFontWeight: fontWeightRegular,
                                    textColor: darkblack),
                              )
                            // TextFormField(
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(
                            //       border: InputBorder.none,
                            //       contentPadding:
                            //           EdgeInsets.only(top: 15, left: 20, bottom: 20.0),
                            //       hintText: '1234 5444 44444 333',
                            //       hintStyle: TextStyle(
                            //           fontSize: fontSize14,
                            //           fontFamily: fontfamilybeVietnam,
                            //           fontWeight: fontWeightRegular,
                            //           color: lightblack)),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   // width: screenSize!.width,
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //           bottomLeft: Radius.circular(6),
                    //           bottomRight: Radius.circular(6)),
                    //       border: Border.all(width: 1, color: boxbordercolor)),

                    //   child:
                    // )
                  ],
                );
              })
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: help.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        width: screenSize!.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            // borderRadius: const BorderRadius.only(
                            //     topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                            border:
                                Border.all(width: 1, color: boxbordercolor)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20,
                                  top: 11.0,
                                  bottom: 12.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    faqtitledetailid = help[index].id!;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3.0, bottom: 2.0),
                                      child: getTextWidget(
                                          title: help[index].title!,
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor:
                                              help[index].id == faqtitledetailid
                                                  ? bluecolor
                                                  : darkblack),
                                    ),
                                    Image.asset(
                                      help[index].id == faqtitledetailid
                                          ? icbluearrowdown
                                          : icArrowright,
                                      height: 24,
                                      width: 24,
                                      fit: BoxFit.cover,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (help[index].id == faqtitledetailid)
                              const Divider(
                                color: boxbordercolor,
                                thickness: 1.0,
                                height: 1.0,
                              ),
                            if (help[index].id == faqtitledetailid)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20, bottom: 14),
                                child: getTextWidget(
                                    title: help[index].message!,
                                    textFontSize: fontSize14,
                                    textFontWeight: fontWeightRegular,
                                    textColor: darkblack),
                              )
                            // TextFormField(
                            //   keyboardType: TextInputType.number,
                            //   decoration: const InputDecoration(
                            //       border: InputBorder.none,
                            //       contentPadding:
                            //           EdgeInsets.only(top: 15, left: 20, bottom: 20.0),
                            //       hintText: '1234 5444 44444 333',
                            //       hintStyle: TextStyle(
                            //           fontSize: fontSize14,
                            //           fontFamily: fontfamilybeVietnam,
                            //           fontWeight: fontWeightRegular,
                            //           color: lightblack)),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   // width: screenSize!.width,
                    //   decoration: BoxDecoration(
                    //       borderRadius: const BorderRadius.only(
                    //           bottomLeft: Radius.circular(6),
                    //           bottomRight: Radius.circular(6)),
                    //       border: Border.all(width: 1, color: boxbordercolor)),

                    //   child:
                    // )
                  ],
                );
              }),
    );
  }

  getSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0, left: 16.0, right: 16.0),
      child: SizedBox(
        height: 45,
        child: PrimaryTextFeild(
          hintText: AppLocalizations.of(context)!.searctext,
          onChange: onSearchTextChanged,
          prefixIcon: icSearch,
          suffixiconcolor: greycolor,
          suffixIcon: _searchcontroller.text.isNotEmpty ? icClose : null,
          controller: _searchcontroller,
        ),
      ),
    );
  }

  getHelptype() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 13.0,
      ),
      child: SizedBox(
        height: 32,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: helptype.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 13.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      faqtitleid = helptype[index].id!;
                      getFaqDetailapi(helptype[index].id!);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: faqtitleid == helptype[index].id
                            ? bluecolor
                            : boxcolor,
                        borderRadius: BorderRadius.circular(28)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 17.0, right: 17.0),
                      child: Center(
                        child: getTextWidget(
                            title: helptype[index].title!.toString(),
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightMedium,
                            textColor: helptype[index].id == faqtitleid
                                ? whitecolor
                                : darkblack),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  getTitleBar() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0;
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
                        title: AppLocalizations.of(context)!.faq,
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
                        title: AppLocalizations.of(context)!.contactus,
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
}
