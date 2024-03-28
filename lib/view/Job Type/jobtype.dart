import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wconnectorconnectorflow/view/Auth/Login/login.dart';
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../main.dart';
import '../../utils/button.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../../workerflow/view/Auth/Login/login.dart';
import '../../workerflow/view/Bottom Tab/primarybottomtab.dart';
import '../Bottom Tab/primarybottomtab.dart';
import '../SelectCountry/select_country.dart';

class MyJobType extends StatefulWidget {
  // final int? langid;
  const MyJobType({
    super.key,
  });

  @override
  State<MyJobType> createState() => _MyJobTypeState();
}

class _MyJobTypeState extends State<MyJobType> {
  @override
  void initState() {
    super.initState();

    // debugPrint('${getInt('lang_id')}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      languagechange();
    });
  }

  void languagechange() {
    if (getInt('lang_id') != 1) {
      MyApp.of(context).setLocale(const Locale('pl'));
    } else {
      MyApp.of(context).setLocale(const Locale('en'));
    }
  }

  int? isSelected = 0;
  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whitecolor,
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(
        //       Icons.arrow_back,
        //       size: 24,
        //       color: darkblack,
        //     )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getLogo(),
            Padding(
              padding: const EdgeInsets.only(top: 43.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.chooseyourjobtype,
                  textFontSize: fontSize25,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 40.0, right: 40),
              child: getTextWidget(
                  textAlign: TextAlign.center,
                  title: AppLocalizations.of(context)!
                      .chooseyourjobtypedescription,
                  textFontSize: fontSize13,
                  textFontWeight: fontWeightLight,
                  textColor: lightblack),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 84.0, top: 23, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getFindjob(),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  getFindEmployee()
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: getButton(),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.continuetext,
          onPressed: () {
            if (isSelected == 0) {
              if (getString('workerselectcountry') == '1') {
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
                                // langid: widget.langid,
                                selectedcountryid: getInt('workercountry'),
                                // selectedCountryid: selectedCountry,
                              )));
                }
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MySelectCountry(
                              // langid: widget.langid,
                              checkApplicant: 0,
                            )));
              }
            } else {
              if (getString('companyselectcountry') == "1") {
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
                                // langid: widget.langid,
                                selectedcountryid: getInt('companycountry'),
                              )));
                }
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MySelectCountry(
                              // langid: widget.langid,
                              checkApplicant: 1,
                            )));
              }
            }
          }),
    );
  }

  getFindjob() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          isSelected = 0;
        });
      },
      child: Container(
        // margin: const EdgeInsets.only(right: 15),
        width: 164,
        height: 244,
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isSelected == 0 ? bluecolor : lightbordercolor),
            borderRadius: BorderRadius.circular(40.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icBag,
              height: 78,
              width: 78,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.findajob,
                  textFontSize: fontSize18,
                  textFontWeight: fontWeightSemiBold,
                  textColor: darkblack),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9.0, left: 28.0, right: 28.0),
              child: getTextWidget(
                  textAlign: TextAlign.center,
                  title: AppLocalizations.of(context)!.findajobdescription,
                  textFontSize: fontSize13,
                  textFontWeight: fontWeightLight,
                  textColor: lightblack),
            )
          ],
        ),
      ),
    );
  }

  getFindEmployee() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          isSelected = 1;
        });
      },
      child: Container(
        // margin: const EdgeInsets.only(
        //   right: 16,
        // ),
        width: 164,
        height: 244,
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: isSelected == 1 ? bluecolor : lightbordercolor),
            borderRadius: BorderRadius.circular(40.0)),
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icPeople,
                height: 78,
                width: 78,
                fit: BoxFit.cover,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 4.0, right: 4.0),
                child: getTextWidget(
                    textAlign: TextAlign.center,
                    title: AppLocalizations.of(context)!.requestanemployee,
                    textFontSize: fontSize18,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
              getTextWidget(
                  textAlign: TextAlign.center,
                  title: AppLocalizations.of(context)!
                      .requestanemployeedescription,
                  textFontSize: fontSize13,
                  textFontWeight: fontWeightLight,
                  textColor: lightblack)
            ],
          ),
        ),
      ),
    );
  }

  getLogo() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Image.asset(
          icAppIcon,
          height: 98,
          width: 97,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
