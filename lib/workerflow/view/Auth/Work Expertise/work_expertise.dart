import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Work%20Expertise/model/expertise_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/button.dart';
import '../../../../utils/dailog.dart';
import '../../../../utils/internetconnection.dart';
import '../../../../utils/progressdialog.dart';
import '../../../../utils/sharedprefs.dart';
import '../../../../utils/textfeild.dart';
import '../../../../utils/textwidget.dart';
import '../Login/login.dart';
import 'model/add_expertise_model.dart';

class MyWorkexpertise extends StatefulWidget {
  final int? langid;
  const MyWorkexpertise({super.key, this.langid});

  @override
  State<MyWorkexpertise> createState() => _MyWorkexpertiseState();
}

class _MyWorkexpertiseState extends State<MyWorkexpertise> {
  @override
  void initState() {
    super.initState();
    debugPrint('${getInt('lang_id')}');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   languagechange();
    // });
    getworkwxpertiseapi();
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

  // int? selectedexpertise = 0;
  List<Data> expertise = [];
  final List<Data> _searchexpertise = [];
  List selectedExpertiseIds = [];
  final _searchcontroller = TextEditingController();
  Future<void> addworkexpertiseapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = adduserworkexpertiseurl;

        var headers = {
          'Authorization': 'Bearer ${getString('workerregistertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('workerregistertoken'));

        var request = http.Request('POST', Uri.parse(apiurl));
        request.body = json.encode({"expertise": selectedExpertiseIds});
        debugPrint(' Url :-$apiurl');
        debugPrint('Body :- ${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var workExpertise = ExpertiseModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (workExpertise.status == '1') {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyWorkerLogin(
                            langid: widget.langid,
                          )));
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

  Future<void> getworkwxpertiseapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$getexpertiserecords?id=${getInt('lang_id')}";
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
        var workExpertise = WorkerExpertiseModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (workExpertise.status == '1') {
            setState(() {
              expertise = workExpertise.data!;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whitecolor,
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(
                title: AppLocalizations.of(context)!.whatisyourexpertise,
                textFontSize: fontSize25,
                textFontWeight: fontWeightMedium,
                textColor: darkblack),
            getTextWidget(
                title: AppLocalizations.of(context)!.selectyourexpertise,
                textFontSize: fontSize13,
                textFontWeight: fontWeightLight,
                textColor: lightblack),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: PrimaryTextFeild(
                controller: _searchcontroller,
                hintText: AppLocalizations.of(context)!.searctext,
                onChange: onSearchTextChanged,
                prefixIcon: icSearch,
                prefixiconcolor: darkblack,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [getexpertise()],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: getButton(),
    );
  }

  void onSearchTextChanged(String text) async {
    _searchexpertise.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in expertise) {
      if (userDetail.expertise!.contains(text)) {
        _searchexpertise.add(userDetail);
      }
    }

    setState(() {});
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.continuetext,
          onPressed: () {
            if (selectedExpertiseIds.isNotEmpty) {
              addworkexpertiseapi();
            } else {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.selectyourexpertise);
            }
          }),
    );
  }

  getexpertise() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 19.0,
      ),
      child: _searchexpertise.isNotEmpty || _searchcontroller.text.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchexpertise.length,
              itemBuilder: (context, index) {
                // final expertiseItem = expertise[index];
                final isSelected =
                    selectedExpertiseIds.contains(_searchexpertise[index].id);

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedExpertiseIds.remove(_searchexpertise[index].id);
                      } else {
                        selectedExpertiseIds.add(_searchexpertise[index].id);
                      }

                      // selectedexpertise = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: Row(
                      children: [
                        //           Transform.scale(
                        //   scale: 1.2,
                        //   child: Checkbox(
                        //       fillColor: const MaterialStatePropertyAll<Color>(bluecolor),
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(4)),
                        //       side: const BorderSide(color: bordercolor),
                        //       value: ,
                        //       onChanged: (value) {
                        //         setState(() {
                        //           isChecked = value!;
                        //         });
                        //       }),
                        // ),
                        Image.asset(
                          isSelected ? iccheckbox : icUncheckbox,
                          height: 26,
                          width: 26,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        Flexible(
                          child: getTextWidget(
                              maxLines: 2,
                              title:
                                  _searchexpertise[index].expertise!.toString(),
                              textFontSize: fontSize14,
                              textFontWeight: fontWeightRegular,
                              textColor: darkblack),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: expertise.length,
              itemBuilder: (context, index) {
                // final expertiseItem = expertise[index];
                final isSelected =
                    selectedExpertiseIds.contains(expertise[index].id);

                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedExpertiseIds.remove(expertise[index].id);
                      } else {
                        selectedExpertiseIds.add(expertise[index].id);
                      }

                      // selectedexpertise = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 22.0,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          isSelected ? iccheckbox : icUncheckbox,
                          height: 26,
                          width: 26,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        Flexible(
                          child: getTextWidget(
                              maxLines: 2,
                              title: expertise[index].expertise!.toString(),
                              textFontSize: fontSize14,
                              textFontWeight: fontWeightRegular,
                              textColor: darkblack),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
