import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/model/job_perhour_model.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textwidget.dart';
import '../Congratulation/congratulation.dart';
import 'model/apply_job_model.dart';

class MyApplyJob extends StatefulWidget {
  final String? companyImg;
  final String? comapnayName;
  final String? companyAddress;
  final String? companyId;
  final String? jobId;
  const MyApplyJob(
      {super.key,
      this.companyImg,
      this.comapnayName,
      this.companyAddress,
      this.companyId,
      this.jobId});

  @override
  State<MyApplyJob> createState() => _MyApplyJobState();
}

class _MyApplyJobState extends State<MyApplyJob> {
  @override
  void initState() {
    super.initState();
    // getjobfrequencyapi();
    getjobperhourapi();
  }

  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _expectedSalarycontroller = TextEditingController();
  final _telluscontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  String? _trcfile;
  PerHours? selectedJobTime;
  List<PerHours> jobtime = [];

  Future<void> getjobperhourapi() async {
    if (await checkUserConnection()) {
      // if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$getsalarytypedropdownurl?id=${getInt('lang_id')}";
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('companytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var jobFrequencyPerHrs = JobPerHrsModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (jobFrequencyPerHrs.status == '1') {
            setState(() {
              jobtime = jobFrequencyPerHrs.perhour!;
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
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
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

  Future<void> applyjobapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);

      try {
        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint('Token :- ${getString('usertoken')}');

        var apiurl = '$userapplyjoburl/${widget.companyId}/${widget.jobId}';
        debugPrint(apiurl);
        var request = http.MultipartRequest('POST', Uri.parse(apiurl));

        request.fields['name'] = _namecontroller.text.toString();
        request.fields['email'] = _emailcontroller.text.toString();
        request.fields['expected_salary'] =
            _expectedSalarycontroller.text.toString();

        request.fields['about_me'] = _telluscontroller.text.toString();

        request.fields['salary_type'] = selectedJobTime!.id.toString();

        if (_trcfile != null) {
          var imagedrivingfile =
              await http.MultipartFile.fromPath('cv', _trcfile!);
          request.files.add(imagedrivingfile);
        }
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getRegister = ApplyJobModel.fromJson(jsonResponse);

        debugPrint('Response status code: ${response.statusCode}');

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          ProgressDialogUtils.dismissProgressDialog();
          if (getRegister.status == '1') {
            if (!mounted) return;
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyCongratulationScreen()));
            });
          } else {
            debugPrint('Failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            connectorAlertDialogue(
              context: context,
              desc: getRegister.message,
              onPressed: () {
                Navigator.pop(context);
              },
            ).show();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          debugPrint('400');
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: getRegister.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
          debugPrint(getRegister.message);
        } else if (response.statusCode == 401) {
          debugPrint('401');
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: getRegister.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();

          debugPrint(getRegister.message);
        } else if (response.statusCode == 500) {
          debugPrint('500');
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: getRegister.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();

          debugPrint(getRegister.message);
        } else if (response.statusCode == 404) {
          debugPrint('404');
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: getRegister.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();

          debugPrint(getRegister.message);
        }
      } catch (e) {
        if (!mounted) return;
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint('The Error is Here :- $e');
        connectorAlertDialogue(
          context: context,
          desc: '$e',
          onPressed: () {
            Navigator.pop(context);
          },
        ).show();
      }
    } else {
      ProgressDialogUtils.dismissProgressDialog();
      if (!mounted) return;
      connectorAlertDialogue(
        context: context,
        type: AlertType.info,
        desc: 'Please check your internet connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        backgroundColor: whitecolor,
        centerTitle: true,
        elevation: 0.0,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.applyjob,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkblack,
              size: 24.0,
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border:
                            Border.all(width: 1, color: lightbordercolorpro)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: CachedNetworkImage(
                        height: 73,
                        width: 73,
                        imageUrl: widget.companyImg!,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 73,
                          width: 73,
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
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 19.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTextWidget(
                            title: widget.comapnayName!,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                icGreyLocation,
                                height: 17,
                                color: greycolor,
                                width: 17,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              getTextWidget(
                                  title: widget.companyAddress!,
                                  textFontSize: fontSize13,
                                  textFontWeight: fontWeightRegular,
                                  textColor: lightwhitecolor)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            const Divider(
              color: bordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 16.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.fullname,
                  textFontSize: fontSize14,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
            ),
            _getFullname(),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 16.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.email,
                  textFontSize: fontSize14,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
            ),
            _getEmail(),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.taptouploadcv,
                  textFontSize: fontSize14,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
            ),
            _getyourCV(),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.expectedsalary,
                  textFontSize: fontSize14,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
            ),
            getExpectedSalary(),
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
              child: getTextWidget(
                  title: AppLocalizations.of(context)!.tellsomethingaboutyou,
                  textFontSize: fontSize14,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
            ),
            getTellus(),
            getButton()
          ]),
        ),
      ),
    );
  }

  getTellus() {
    return Padding(
        padding: const EdgeInsets.only(top: 9.0, left: 16.0, right: 16.0),
        child: TextFormField(
          controller: _telluscontroller,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.requiredsomething;
            }
            return null;
          },
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

  getjobTime() {
    return DropdownButtonHideUnderline(
        child: SizedBox(
      height: 50,
      child: DropdownButton2(
        style: const TextStyle(color: darkblack),
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.select,
                  style: const TextStyle(
                    color: hintcolor,
                    fontSize: fontSize14,
                    fontWeight: fontWeightRegular,
                    fontFamily: fontfamilybeVietnam,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        items: jobtime.map((item) {
          return DropdownMenuItem(
            value: item,
            enabled: true,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.time!.toString(),
                      style: const TextStyle(
                        fontSize: fontSize14,
                        fontFamily: fontfamilybeVietnam,
                        fontWeight: fontWeightRegular,
                        color: blackcolor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        value: selectedJobTime,
        onChanged: (value) {
          setState(() {
            selectedJobTime = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 45,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43.0),
            border: Border.all(
              color: bordercolor,
            ),
            color: whitecolor,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: darkblack,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: screenSize!.width / 2.3,
          padding: null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14), color: Colors.white),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    ));
  }

  getExpectedSalary() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize!.width / 2.3,
            child: PrimaryTextFeild(
              controller: _expectedSalarycontroller,
              hintText: '\$',
              keyboardType: TextInputType.number,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.requiredsomething;
                }
                return null;
              },
            ),
          ),
          SizedBox(width: screenSize!.width / 2.3, child: getjobTime()),
        ],
      ),
    );
  }

  _getEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0, left: 16, right: 16.0),
      child: PrimaryTextFeild(
        controller: _emailcontroller,
        hintText: AppLocalizations.of(context)!.email,
        keyboardType: TextInputType.emailAddress,
        fontSize: fontSize14,
        validation: (value) {
          const pattern =
              r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
          final regExp = RegExp(pattern);

          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredemail;
          } else if (!regExp.hasMatch(value)) {
            return AppLocalizations.of(context)!.requiredvalidemail;
          }

          return null;
        },
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getFullname() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0, left: 16, right: 16.0),
      child: PrimaryTextFeild(
        controller: _namecontroller,
        hintText: AppLocalizations.of(context)!.fullname,
        fontSize: fontSize14,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredname;
          }
          return null;
        },
        fontWeight: fontWeightLight,
      ),
    );
  }

  void _showtrcfile() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          // height: 150.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ListTile(
              //   leading: const Icon(Icons.camera_alt),
              //   title: const Text('Take a photo'),
              //   onTap: () {
              //     // Handle camera button tap
              //     getImageRegistration(ImageSource.camera);
              //     Navigator.pop(context);
              //   },
              // ),
              // ListTile(
              //   leading: const Icon(Icons.photo_library),
              //   title: const Text('Choose from gallery'),
              //   onTap: () {
              //     // Handle gallery button tap
              //     getImageRegistration(ImageSource.gallery);
              //     Navigator.pop(context);
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.file_copy),
                title: Text(AppLocalizations.of(context)!.pickfromfile),
                onTap: () {
                  // Handle gallery button tap
                  _picktrcfile();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _picktrcfile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _trcfile = result.files.single.path!;
        });
        // Use the filePath as needed (e.g., upload it to a server or process locally).
        debugPrint('Selected file: $_trcfile');
      } else {
        // User canceled the picker
        debugPrint('File picking canceled.');
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  _getyourCV() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
      child: _trcfile == null
          ? DottedBorder(
              dashPattern: const [4, 4],
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              color: dottedborder,
              child: GestureDetector(
                onTap: () {
                  // _picktrcfile();
                  _showtrcfile();
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 138,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: documentcontainercolro,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // _picktrcfile();
                        _showtrcfile();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            icUploaddoc,
                            height: 44,
                            width: 44,
                          ),
                          // const SizedBox(
                          //   height: 2.0,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: getTextWidget(
                                title:
                                    AppLocalizations.of(context)!.taptouploadoc,
                                textFontSize: fontSize14,
                                textColor: documentuploadcolor,
                                textFontWeight: fontWeightRegular),
                          ),
                        ],
                      ),
                    )),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: 138,
              decoration: BoxDecoration(
                color: documentcontainercolro,
                border: Border.all(color: blackcolor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _trcfile = null;
                          });
                        },
                        child: Image.asset(
                          icClose,
                          height: 24.0,
                          width: 24.0,
                          fit: BoxFit.cover,
                          color: blackcolor,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.insert_drive_file,
                        size: 44,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        _trcfile!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 16.0, top: 20.0, left: 16.0, right: 16.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.submit,
          onPressed: () {
            if (_formkey.currentState!.validate() &&
                _trcfile != null &&
                selectedJobTime != null) {
              applyjobapi();
            } else if (_trcfile == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requireddocument);
            } else if (selectedJobTime == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requiredjobtype);
            }
          }),
    );
  }
}
