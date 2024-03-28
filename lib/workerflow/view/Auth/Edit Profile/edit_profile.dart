import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Edit%20Profile/model/get_workerdetail_model.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Edit%20Profile/model/update_profile_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
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

class MyEditWorkerProfile extends StatefulWidget {
  const MyEditWorkerProfile({super.key});

  @override
  State<MyEditWorkerProfile> createState() => _MyEditWorkerProfileState();
}

class _MyEditWorkerProfileState extends State<MyEditWorkerProfile> {
  bool isload = true;
  @override
  void initState() {
    super.initState();
    getuserdataapi();
  }

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _universitycontroller = TextEditingController();
  final _addresscontroller = TextEditingController();

  File? _image;
  String? getuserImage;

  String? _trcfile;
  String? _passportfile;
  int? isStudentSelected = 0;
  bool isStudentNotSelected = false;
  final picker = ImagePicker();

  Future<void> getuserdataapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getuserurl;

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(' Token ${getString('token')}');
        debugPrint('url $apiurl');

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getUserdata = GetUserDataModel.fromJson(jsonResponse);

        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getUserdata.status == '1') {
            setState(() {
              _nameController.text = getUserdata.data!.jobName!;
              _addresscontroller.text = getUserdata.data!.address!;
              _emailController.text = getUserdata.data!.email!;
              _mobileController.text = getUserdata.data!.phone!;
              _universitycontroller.text = getUserdata.data!.university!;
              getuserImage = getUserdata.data!.userImage!;
              isStudentSelected = getUserdata.data!.isStudent!;
              _trcfile = getUserdata.data!.tRC;
              _passportfile = getUserdata.data!.passport!;
              isload = false;
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

  Future<void> updateprofile() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);

      var apiurl = updateuserprofileurl;

      try {
        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint('Url: $apiurl');
        debugPrint('Token : ${getString('usertoken')}');

        var request = http.MultipartRequest('POST', Uri.parse(apiurl));

        request.fields['name'] = _nameController.text.toString();
        request.fields['address'] = _addresscontroller.text.toString();
        request.fields['latitude'] = '10.12';
        request.fields['longitude'] = '11.12';
        request.fields['university'] = _universitycontroller.text.toString();
        request.fields['is_student'] = isStudentSelected == 0 ? '0' : '1';

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
              await http.MultipartFile.fromPath('passport', _passportfile!
                  // _imagedrivingfile!.bytes!,
                  // filename: _imagedrivingfile!.name,
                  );
          request.files.add(passportFile);
        }
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getRegister = UpdateUserModel.fromJson(jsonResponse);

        debugPrint('Response status code: ${response.statusCode}');
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          ProgressDialogUtils.dismissProgressDialog();
          if (getRegister.status == '1') {
            if (!mounted) return;
            debugPrint('Updated  Successfully');

            setState(() {
              setString('userimage', getRegister.data!.userImage!.toString());
              setString('username', getRegister.data!.jobName!.toString());
            });
            Navigator.pop(context, true);
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.profilesuccessfull);
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
      backgroundColor: whitecolor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.editprofile,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
        backgroundColor: whitecolor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkblack,
              size: 24,
            )),
      ),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getImage(),
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.fullname,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getFullName(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.mobile,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getMobile(),
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
            ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.save,
          onPressed: () {
            // updateprofile();
            debugPrint('Trc $_trcfile');
            debugPrint('Passport $_passportfile');
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
                          color: darkblack,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
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
                          color: darkblack,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
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

  _getUniversity() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _universitycontroller,
        hintColor: darkblack,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        borderColor: darkblack,
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getMobile() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
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
        hintColor: darkblack,
        borderColor: darkblack,
        keyboardType: TextInputType.number,
        controller: _mobileController,
      ),
    );
  }

  _getEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
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
        hintColor: darkblack,
        readonly: true,
        keyboardType: TextInputType.emailAddress,
        borderColor: darkblack,
        controller: _emailController,
      ),
    );
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
                    isStudentSelected = 0;
                  });
                },
                child: Container(
                  height: 45,
                  // alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isStudentSelected == 0 ? bluecolor : whitecolor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: bordercolor)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.student,
                      style: TextStyle(
                          color:
                              isStudentSelected == 0 ? whitecolor : darkblack,
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
                    isStudentSelected = 1;
                  });
                },
                child: Container(
                  height: 45,
                  // width: MediaQuery.of(context).size.width * 0.4,
                  // alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isStudentSelected != 0 ? bluecolor : whitecolor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: bordercolor)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.nonstudent,
                      style: TextStyle(
                          color:
                              isStudentSelected != 0 ? whitecolor : darkblack,
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
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        hintColor: darkblack,
        borderColor: darkblack,
        controller: _addresscontroller,
      ),
    );
  }

  _getFullName() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredname;
          }
          return null;
        },
        hintColor: darkblack,
        borderColor: darkblack,
        controller: _nameController,
      ),
    );
  }

  _getImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          ClipOval(
            child: _image == null
                ? CachedNetworkImage(
                    imageUrl: getuserImage!,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 147.0,
                      width: 147.0,
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
                        height: 147.0,
                        width: 147.0,
                        decoration: const BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image.file(
                    _image!,
                    height: 147.0,
                    width: 147.0,
                    fit: BoxFit.cover,
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
              ))
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
