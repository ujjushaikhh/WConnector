import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:wconnectorconnectorflow/view/Job%20Type/jobtype.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/textwidget.dart';
import '../../main.dart';
import '../../utils/sharedprefs.dart';

class MyIntro extends StatefulWidget {
  final int? langid;
  const MyIntro({super.key, this.langid});

  @override
  State<MyIntro> createState() => _MyIntroState();
}

class _MyIntroState extends State<MyIntro> {
  @override
  void initState() {
    super.initState();
    debugPrint('this widget.lang ${widget.langid}');
    debugPrint(' this is stored lang ${getInt('lang_id')}');
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

  int currentIndex = 0;

  List screenImage = [icIntro1, icIntro2, icIntro3];
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: screenImage.length,
          itemBuilder: (context, index, realIndex) {
            return Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      icBackgroundintro,
                      width: MediaQuery.of(context).size.width,
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 64.0),
                      child: index == 0
                          ? Image.asset(
                              screenImage[0],
                              height: 368,
                              width: 243,
                              fit: BoxFit.cover,
                            )
                          : index == 1
                              ? Image.asset(
                                  screenImage[2],
                                  height: 366,
                                  width: 244,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  screenImage[1],
                                  height: 370,
                                  width: 216,
                                  fit: BoxFit.cover,
                                ),
                    ))
              ],
            );
          },
          options: CarouselOptions(
            // scrollPhysics: const NeverScrollableScrollPhysics(),
            initialPage: 0,
            viewportFraction: 1.0,
            height: MediaQuery.of(context).size.height,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          )),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            // padding: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: whitecolor,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10, bottom: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 43.0,
                      // left: 50, right: 50.0
                    ),
                    child: getTextWidget(
                        title: getTitle(currentIndex),
                        textFontSize: fontSize21,
                        textFontWeight: fontWeightRegular,
                        textColor: blackcolor,
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 13.0, left: 17, right: 17),
                    child: getTextWidget(
                        textAlign: TextAlign.center,
                        title: getDescription(currentIndex),
                        textFontSize: fontSize13,
                        textFontWeight: fontWeightLight,
                        textColor: lightblack),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DotsIndicator(
                        position: currentIndex,
                        dotsCount: screenImage.length,
                        decorator: DotsDecorator(
                            color: lightgrey,
                            size: const Size.square(9.0),
                            activeSize: const Size(18.0, 9.0),
                            activeColor: bluecolor,
                            activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)))),
                  ),
                  CustomizeButton(
                      text: currentIndex == 2
                          ? AppLocalizations.of(context)!.getstarted
                          : AppLocalizations.of(context)!.next,
                      onPressed: _onNextPress)
                ],
              ),
            ),
          ),
        ),
      ),
      currentIndex != 2
          ? Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 36.0, right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    onSkipPress();
                  },
                  child: getTextWidget(
                      title: AppLocalizations.of(context)!.skip,
                      textFontSize: fontSize15,
                      textFontWeight: fontWeightBold,
                      textColor: bluecolor),
                ),
              ),
            )
          : Container(),
    ]));
  }

  String getTitle(int index) {
    if (index == 0) {
      return "Lorem Ipsum is simply";
    } else if (index == 1) {
      return "Contrary to popular belief";
    } else if (index == 2) {
      return "Aldus PageMaker including";
    }
    return "";
  }

  String getDescription(int index) {
    if (index == 0) {
      return "It is a long established fact that a reader will be distracted by the readable content of a page when looking";
    } else if (index == 1) {
      return "It is a long established fact that a reader will be distracted by the readable content of a page when looking";
    } else if (index == 2) {
      return "It is a long established fact that a reader will be distracted by the readable content of a page when looking";
    }
    return "";
  }

  void _onNextPress() {
    if (currentIndex < screenImage.length - 1) {
      _carouselController.nextPage();
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const MyJobType(
                  // langid: widget.langid,
                  )),
          (route) => false);
      setBool('seen', true);
    }
  }

  void onSkipPress() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const MyJobType(
              // langid: widget.langid,
              )),
      (route) => false,
    );
    await setBool('seen', true);
  }
}
