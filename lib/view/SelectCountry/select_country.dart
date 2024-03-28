import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/view/Auth/Login/login.dart';
import 'package:wconnectorconnectorflow/view/Bottom%20Tab/primarybottomtab.dart';
import 'package:wconnectorconnectorflow/view/SelectCountry/model/country_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Complete%20Profile/complete_profile.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Login/login.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Bottom%20Tab/primarybottomtab.dart';
import '../../../utils/button.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/textfeild.dart';
import '../../utils/textwidget.dart';

class MySelectCountry extends StatefulWidget {
  final int? checkApplicant;
  final int? langid;
  const MySelectCountry({super.key, required this.checkApplicant, this.langid});

  @override
  State<MySelectCountry> createState() => _MySelectCountryState();
}

class _MySelectCountryState extends State<MySelectCountry> {
  @override
  void initState() {
    super.initState();
    getCountrysapi();

    debugPrint('${getInt('lang_id')}');
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   languagechange();
    // });
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

  int? selectedCountry;
  List<Data> country = [];
  final List<Data> _searchcountry = [];

  final _searchcontroller = TextEditingController();

  Future<void> getCountrysapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = countryurl;
        debugPrint(apiurl);
        var headers = {
          // 'Authorization': 'Bearer' '$token',
          'Content-Type': 'application/json',
        };

        // debugPrint(token);

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getCountry = CountryModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getCountry.status == '1') {
            setState(() {
              country = getCountry.data!;
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
            desc: '${getCountry.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCountry.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCountry.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCountry.message}',
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

  void onSearchTextChanged(String text) async {
    _searchcountry.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var userDetail in country) {
      if (userDetail.countryName!.contains(text)) {
        _searchcountry.add(userDetail);
      }
    }

    setState(() {});
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
                title: AppLocalizations.of(context)!.selectyourcountry,
                textFontSize: fontSize25,
                textFontWeight: fontWeightMedium,
                textColor: darkblack),
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: PrimaryTextFeild(
                onChange: onSearchTextChanged,
                controller: _searchcontroller,
                hintText: AppLocalizations.of(context)!.searctext,
                prefixIcon: icSearch,
                prefixiconcolor: darkblack,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [getCountry()],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: getButton(),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.continuetext,
          onPressed: () {
            if (selectedCountry != null) {
              if (widget.checkApplicant == 0) {
                setInt('workercountry', selectedCountry!);
                setString('workerselectcountry', '1');
                if (getString('isCompletedProfile') == '1') {
                  if (getString('userlogin') == '1') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const WorkerPrimaryBottomTab()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyWorkerLogin(
                                  langid: widget.langid,
                                  selectedcountryid: selectedCountry,
                                  // selectedCountryid: selectedCountry,
                                )));
                  }
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyCompleteProfile(
                                langid: widget.langid,
                                selectedCountryid: selectedCountry,
                              )));
                }

                // if (getString('isCompletedProfile') == '0') {

                // } else {
                //   if (getString('isCompletedDetail') == '1') {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const MyWorkexpertise()));
                //   } else {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => const MyWorkDetail()));
                //   }
                // }
              } else {
                setString('companyselectcountry', '1');
                setInt('companycountry', selectedCountry!);

                if (getString('comapnylogin') == '1') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyPrimaryBottomTab()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyLogin(
                                langid: widget.langid,
                                selectedcountryid: selectedCountry,
                              )));
                }

                // if (getString('isregister') != '1') {
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => MyRegisterCompany(
                //                 selectedCountry: selectedCountry,
                //               )));
                // }
                // else {
                // }
              }
            } else {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.selectyourcountry);
            }

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const MyLogin()));
          }),
    );
  }

  getCountry() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 19.0,
      ),
      child: _searchcontroller.text.isNotEmpty || _searchcountry.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchcountry.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCountry = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: Row(
                      children: [
                        Image.asset(
                          index == selectedCountry
                              ? icCheckRadio
                              : icUncheckradio,
                          height: 26,
                          width: 26,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        getTextWidget(
                            title:
                                _searchcountry[index].countryName!.toString(),
                            textFontSize: fontSize14,
                            textFontWeight: fontWeightRegular,
                            textColor: darkblack)
                      ],
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: country.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCountry = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: Row(
                      children: [
                        Image.asset(
                          index == selectedCountry
                              ? icCheckRadio
                              : icUncheckradio,
                          height: 26,
                          width: 26,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        getTextWidget(
                            title: country[index].countryName!.toString(),
                            textFontSize: fontSize14,
                            textFontWeight: fontWeightRegular,
                            textColor: darkblack)
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
