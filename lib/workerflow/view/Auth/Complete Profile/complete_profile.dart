import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shimmer/shimmer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Complete%20Profile/model/worker_register_model.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/button.dart';
import '../../../../utils/dailog.dart';
import '../../../../utils/internetconnection.dart';
import '../../../../utils/progressdialog.dart';
import '../../../../utils/textfeild.dart';
import '../../../../utils/textwidget.dart';
import '../Work Detail/work_detail.dart';

class MyCompleteProfile extends StatefulWidget {
  final int? selectedCountryid;
  final int? langid;
  const MyCompleteProfile({super.key, this.selectedCountryid, this.langid});

  @override
  State<MyCompleteProfile> createState() => _MyCompleteProfileState();
}

class _MyCompleteProfileState extends State<MyCompleteProfile> {
  @override
  void initState() {
    super.initState();
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

  bool isStudentSelected = true;
  bool isStudentNotSelected = false;

  String? _trcfile;
  String? _passportfile;
  File? _image;
  final picker = ImagePicker();

  final _namecontroller = TextEditingController();
  final _mobilenumcontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _addresscontroller = TextEditingController();
  final _universitycontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future<void> registerapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);

      try {
        var headers = {
          // 'authkey': 'Bearer $token',
          'Content-Type': 'application/json',
        };

        // debugPrint(token);

        var apiurl = userregisterurl;
        debugPrint(apiurl);
        var request = http.MultipartRequest('POST', Uri.parse(apiurl));

        request.fields['lang_id'] = getInt('lang_id').toString();
        request.fields['name'] = _namecontroller.text.toString();
        request.fields['email'] = _emailcontroller.text.toString();
        request.fields['address'] = _addresscontroller.text.toString();
        request.fields['phone'] = _mobilenumcontroller.text.toString();
        request.fields['password'] = _passcontroller.text.toString();
        request.fields['countrycode'] = '+91';
        request.fields['countryid'] = widget.selectedCountryid.toString();
        request.fields['latitude'] = '10.12';
        request.fields['longitude'] = '11.12';
        request.fields['university'] = _universitycontroller.text.toString();
        request.fields['is_student'] = isStudentSelected ? '0' : '1';

        if (_image != null) {
          request.files.add(
              await http.MultipartFile.fromPath('user_image', _image!.path));

          // var imageFile =
          //     await http.MultipartFile.fromPath('image[]', _image!.path);
          // request.files.add(imageFile);
        }
        if (_trcfile != null) {
          var trcFile = await http.MultipartFile.fromPath('TRC', _trcfile!
              // _imagedrivingfile!.bytes!,
              // filename: _imagedrivingfile!.name,
              );
          request.files.add(trcFile);
        }
        if (_passportfile != null) {
          var passportFile =
              await http.MultipartFile.fromPath('passport', _trcfile!
                  // _imagedrivingfile!.bytes!,
                  // filename: _imagedrivingfile!.name,
                  );
          request.files.add(passportFile);
        }
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getRegister = WorkerRegisterModel.fromJson(jsonResponse);

        debugPrint('Response status code: ${response.statusCode}');
        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          ProgressDialogUtils.dismissProgressDialog();
          if (getRegister.status == '1') {
            if (!mounted) return;
            debugPrint('Register Successfully');
            setString('isCompletedProfile', '1');
            setString('workerregistertoken', getRegister.token!);
            Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.registersuccessfull)
                .then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyWorkDetail(
                              langid: widget.langid,
                            ))));
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // bottomNavigationBar: getButton(),
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
                title: AppLocalizations.of(context)!.completeprofile,
                textFontSize: fontSize25,
                textFontWeight: fontWeightMedium,
                textColor: darkblack),
            Expanded(
                child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getImage(),
                    getTextWidget(
                        title: AppLocalizations.of(context)!.fullname,
                        textFontSize: fontSize14,
                        textFontWeight: fontWeightMedium,
                        textColor: darkblack),
                    _getFullname(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.mobile,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getMobileNumber(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.email,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getEmail(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.password,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getPassword(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.address,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getAddress(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.areyoua,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _areYou(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.nameofuniversity,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getUniversity(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.trctext,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getTRCdoc(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.passport,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getPassportdoc(),
                    getButton()
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  getPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: PrimaryTextFeild(
        controller: _passcontroller,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredpassword;
          } else if (value.length < 8) {
            return AppLocalizations.of(context)!.passwordlengthvalidation;
          }
          return null;
        },
        hintText: AppLocalizations.of(context)!.password,
        suffixIcon: icCloseeye,
        prefixIcon: icpassword,
        obscureText: true,
      ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.continuetext,
          onPressed: () {
            if (_formkey.currentState!.validate() &&
                _image != null &&
                _passportfile != null &&
                _trcfile != null) {
              registerapi();
            } else if (_image == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requiredimage);
            } else if (_passportfile == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requiredpassport);
            } else if (_trcfile == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requiredtrcfile);
            }
          }),
    );
  }

  _getTRCdoc() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
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
                    height: 198,
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
              height: 198,
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _trcfile = null;
                        });
                      },
                      child: Align(
                        alignment: Alignment.topRight,
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

  _getPassportdoc() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: _passportfile == null
          ? DottedBorder(
              dashPattern: const [4, 4],
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              color: dottedborder,
              child: GestureDetector(
                onTap: () {
                  // _picktrcfile();
                  _showpassportfile();
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 198,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: documentcontainercolro,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // _picktrcfile();
                        _showpassportfile();
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
              height: 198,
              decoration: BoxDecoration(
                color: documentcontainercolro,
                border: Border.all(color: blackcolor, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _passportfile = null;
                        });
                      },
                      child: Align(
                        alignment: Alignment.topRight,
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
                        _passportfile!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }

  void _showpassportfile() {
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
                  _pickpassportfile();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickpassportfile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _passportfile = result.files.single.path!;
        });
        // Use the filePath as needed (e.g., upload it to a server or process locally).
        debugPrint('Selected file: $_passportfile');
      } else {
        // User canceled the picker
        debugPrint('File picking canceled.');
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  _areYou() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 9.0,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isStudentSelected = true;
                    isStudentNotSelected = false;
                  });
                },
                child: Container(
                  height: 45,
                  // alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isStudentSelected ? bluecolor : whitecolor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: bordercolor)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.student,
                      style: TextStyle(
                          color: isStudentSelected ? whitecolor : darkblack,
                          fontSize: fontSize14,
                          fontFamily: fontfamilybeVietnam,
                          fontWeight: fontWeightMedium),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isStudentNotSelected = true;
                    isStudentSelected = false;
                  });
                },
                child: Container(
                  height: 45,
                  // width: MediaQuery.of(context).size.width * 0.4,
                  // alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isStudentNotSelected ? bluecolor : whitecolor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: bordercolor)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.nonstudent,
                      style: TextStyle(
                          color: isStudentNotSelected ? whitecolor : darkblack,
                          fontSize: fontSize14,
                          fontFamily: fontfamilybeVietnam,
                          fontWeight: fontWeightRegular),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _addresscontroller,
        hintText: AppLocalizations.of(context)!.address,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }

          return null;
        },
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getUniversity() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _universitycontroller,
        hintText: AppLocalizations.of(context)!.nameofuniversity,
        fontSize: fontSize14,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }

          return null;
        },
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _emailcontroller,
        hintText: AppLocalizations.of(context)!.email,
        keyboardType: TextInputType.emailAddress,
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
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getFullname() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
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

  _getMobileNumber() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _mobilenumcontroller,
        hintText: AppLocalizations.of(context)!.mobile,
        validation: (value) {
          const pattern = r'^[0-9]{10}$';
          final regExp = RegExp(pattern);

          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.mobile;
          } else if (!regExp.hasMatch(value)) {
            return AppLocalizations.of(context)!.requiredmobilenumber;
          }

          return null;
        },
        keyboardType: TextInputType.number,
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          Positioned(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: ClipOval(
                child: _image == null
                    ? Image.asset(
                        icUserimg,
                        height: 147,
                        width: 147,
                        fit: BoxFit.cover,
                      )
                    // ? CachedNetworkImage(
                    //     // imageBuilder: (context, imageProvider) => Container(
                    //     //   height: 147.0,
                    //     //   width: 147.0,
                    //     //   decoration: BoxDecoration(
                    //     //     image: DecorationImage(
                    //     //       image: imageProvider,
                    //     //       fit: BoxFit.cover,
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //     placeholder: (context, url) => Shimmer.fromColors(
                    //       baseColor: Colors.grey[300]!,
                    //       highlightColor: Colors.grey[100]!,
                    //       child: Container(
                    //         height: 40.0,
                    //         width: 40.0,
                    //         decoration: const BoxDecoration(
                    //             color: Colors.grey, shape: BoxShape.circle),
                    //       ),
                    //     ),
                    //     imageUrl: "https://picsum.photos/200/300",
                    //     height: 147.0,
                    //     width: 147.0,
                    //     fit: BoxFit.cover,
                    //   )
                    : Image.file(
                        _image!,
                        height: 147.0,
                        width: 147.0,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned(
              bottom: 0.0,
              right: 2.0,
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet();
                },
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(icCamera), fit: BoxFit.cover)),
                ),
              )

              // IconButton(
              //   onPressed: () {
              //     _showBottomSheet();
              //   },
              //   icon: Image.asset(
              //     icCamera,
              //     height: 38.0,
              //     width: 38.0,
              //     fit: BoxFit.cover,
              //   ),
              // ),

              )
        ]),
      ],
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150.0,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.imagefromcamera),
                onTap: () {
                  // Handle camera button tap
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.imagefromlibrary),
                onTap: () {
                  // Handle gallery button tap
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void getImage(ImageSource source) async {
    try {
      final image = await picker.pickImage(source: source);
      if (image == null) {
        return;
      }
      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });
    } catch (e) {
      debugPrint("Failed to open $e");
    }
  }
}
