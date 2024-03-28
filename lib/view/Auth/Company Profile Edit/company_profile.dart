import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/constants/color_constants.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:wconnectorconnectorflow/utils/sharedprefs.dart';
import 'package:wconnectorconnectorflow/view/Auth/Company%20Profile%20Edit/model/get_company_data.dart';
import 'package:wconnectorconnectorflow/view/Auth/Company%20Profile%20Edit/model/update_company_model.dart';
import '../../../constants/api_constants.dart';
import '../../../constants/font_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../utils/button.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textwidget.dart';
import '../Register Comapany/model/get_companylists.dart';

class MyCompanyEditProfile extends StatefulWidget {
  const MyCompanyEditProfile({super.key});

  @override
  State<MyCompanyEditProfile> createState() => _MyCompanyEditProfileState();
}

class _MyCompanyEditProfileState extends State<MyCompanyEditProfile> {
  @override
  void initState() {
    super.initState();
    getCompanyDetailapi();
    getCompanyTypesapi();
  }

  bool isload = true;

  String? _companylegaldoc;
  File? _image;
  Data? typeofCompany;
  String? companyimg;
  List<Data> companyType = [];
  String? companytype;
  final picker = ImagePicker();
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _companydescriptioncontroller = TextEditingController();
  final _addresscontroller = TextEditingController();

  Future<void> getCompanyTypesapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$companytypes?id=${getInt('lang_id')}";
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
        var getCompany = CompanyTypesModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getCompany.status == '1') {
            setState(() {
              companyType = getCompany.data!;
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
            desc: '${getCompany.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCompany.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCompany.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCompany.message}',
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

  Future<void> updatecompanyapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);

      try {
        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));

        var apiurl = updatecompanydeteailsurl;
        debugPrint(apiurl);
        var request = http.MultipartRequest('POST', Uri.parse(apiurl));

        request.fields['name'] = _namecontroller.text.toString();
        request.fields['email'] = _emailcontroller.text.toString();
        request.fields['address'] = _addresscontroller.text.toString();
        request.fields['latitude'] = '10.12';
        request.fields['longitude'] = '11.12';
        request.fields['company_description'] =
            _companydescriptioncontroller.text.toString();
        request.fields['type_of_Company'] = typeofCompany!.id.toString();

        if (_image != null) {
          request.files.add(
              await http.MultipartFile.fromPath('user_image', _image!.path));

          // var imageFile =
          //     await http.MultipartFile.fromPath('image[]', _image!.path);
          // request.files.add(imageFile);
        }
        if (_companylegaldoc != null) {
          var imagedrivingfile = await http.MultipartFile.fromPath(
              'legal_document', _companylegaldoc!
              // _imagedrivingfile!.bytes!,
              // filename: _imagedrivingfile!.name,
              );
          request.files.add(imagedrivingfile);
        }
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var updatCompany = UpdateCompanyDetailModel.fromJson(jsonResponse);

        debugPrint('Response status code: ${response.statusCode}');

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          ProgressDialogUtils.dismissProgressDialog();
          if (updatCompany.status == '1') {
            if (!mounted) return;
            setState(() {
              debugPrint('Updated Successfully');
              setString('companyimage', updatCompany.data!.userImage!);
              setString('companyname', updatCompany.data!.name!);
              Fluttertoast.showToast(msg: ' ${updatCompany.message}')
                  .then((value) => {Navigator.pop(context)});
            });
          } else {
            debugPrint('Failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            connectorAlertDialogue(
              context: context,
              desc: updatCompany.message,
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
            desc: updatCompany.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
          debugPrint(updatCompany.message);
        } else if (response.statusCode == 401) {
          debugPrint('401');
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: updatCompany.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();

          debugPrint(updatCompany.message);
        } else if (response.statusCode == 500) {
          debugPrint('500');
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: updatCompany.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();

          debugPrint(updatCompany.message);
        } else if (response.statusCode == 404) {
          debugPrint('404');
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: updatCompany.message,
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();

          debugPrint(updatCompany.message);
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

  Future<void> getCompanyDetailapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getcompanydetailsurl;
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getCompanyDetail = GetCompanyDetailModel.fromJson(jsonResponse);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getCompanyDetail.status == '1') {
            setState(() {
              companyimg = getCompanyDetail.data!.userImage!;
              _namecontroller.text = getCompanyDetail.data!.name!;
              _addresscontroller.text = getCompanyDetail.data!.address!;
              _emailcontroller.text = getCompanyDetail.data!.email!;
              _companydescriptioncontroller.text =
                  getCompanyDetail.data!.companyDescription!;
              companytype = getCompanyDetail.data!.typeOfCompany!;

              _companylegaldoc = getCompanyDetail.data!.legalDocument!;

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
            desc: '${getCompanyDetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCompanyDetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCompanyDetail.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${getCompanyDetail.message}',
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
        type: AlertType.info,
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
        backgroundColor: whitecolor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: darkblack,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.companydetails,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
      ),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getImage(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: getTextWidget(
                            title:
                                AppLocalizations.of(context)!.companylogophoto,
                            textFontSize: fontSize14,
                            textFontWeight: fontWeightMedium,
                            textColor: darkblack),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.companyname,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getFullname(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.typeofcompany,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getcompanyType(),
                    // _getMobileNumber(),
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
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 20.0),
                    //   child: getTextWidget(
                    //       title: 'Password',
                    //       textFontSize: fontSize14,
                    //       textFontWeight: fontWeightMedium,
                    //       textColor: darkblack),
                    // ),

                    // getPassword(),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title:
                              AppLocalizations.of(context)!.companydescription,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getTellus(),
                    // _areYou(),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 20.0),
                    //   child: getTextWidget(
                    //       title: 'Name of University',
                    //       textFontSize: fontSize14,
                    //       textFontWeight: fontWeightMedium,
                    //       textColor: darkblack),
                    // ),
                    // // _getUniversity(),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 20.0),
                    //   child: getTextWidget(
                    //       title: 'TRC',
                    //       textFontSize: fontSize14,
                    //       textFontWeight: fontWeightMedium,
                    //       textColor: darkblack),
                    // ),
                    // _getTRCdoc(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!
                              .legaldocumentofcompany,
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

  _getPassportdoc() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: _companylegaldoc == null
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
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _companylegaldoc = null;
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
                        _companylegaldoc!,
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
          _companylegaldoc = result.files.single.path!;
        });
        // Use the filePath as needed (e.g., upload it to a server or process locally).
        debugPrint('Selected file: $_companylegaldoc');
      } else {
        // User canceled the picker
        debugPrint('File picking canceled.');
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  _getImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          Positioned(
            child: Container(
              margin: const EdgeInsets.only(top: 12.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: lightbordercolorpro)),
              child: _image == null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: companyimg!,
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
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  : ClipOval(
                      child: Image.file(
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
                      // color: bluecolor,
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

  getTellus() {
    return Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: TextFormField(
          controller: _companydescriptioncontroller,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.requiredsomething;
            }
            return null;
          },
          style: const TextStyle(
            color: darkblack,
            fontSize: fontSize14,
            fontFamily: fontfamilyBevietnam,
            fontWeight: fontWeightLight,
          ),
          decoration: InputDecoration(
            // hintText:
            //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse et malesuada nisl. Sed tempus quam at lorem sagittis fermentum. Proin porta eros lorem, in semper leo interdum quis. Morbi tincidunt varius faucibus. Pellentesque non feugiat massa, eu tempus tortor. Curabitur ac eros fringilla, dapibus purus eget, luctus velit.",
            hintStyle: const TextStyle(
                color: darkblack,
                fontSize: fontSize14,
                fontFamily: fontfamilybeVietnam,
                fontWeight: fontWeightLight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: darkblack, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: darkblack),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: darkblack),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: darkblack),
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

  _getFullname() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _namecontroller,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredname;
          }
          return null;
        },

        // hintText: "Acme Corporation",
        hintColor: darkblack,
        fontSize: fontSize14,
        borderColor: darkblack,
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _emailcontroller,
        // hintText: "georgia.young@example.com",
        readonly: true,

        hintColor: darkblack,
        borderColor: darkblack,
        keyboardType: TextInputType.emailAddress,
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  _getAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _addresscontroller,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredname;
          }
          return null;
        },
        // hintText: "4140 Parker Rd. Allentown, New Mexico 31134",
        borderColor: darkblack,
        fontSize: fontSize14,
        hintColor: darkblack,
        fontWeight: fontWeightLight,
      ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.save,
          onPressed: () {
            updatecompanyapi();
          }),
    );
  }

  getcompanyType() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
        style: const TextStyle(color: darkblack),
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: getTextWidget(
                      title: companytype!,
                      textFontSize: fontSize14,
                      textColor: darkblack,
                      textFontWeight: fontWeightLight)),
            ),
          ],
        ),
        items: companyType.map((item) {
          return DropdownMenuItem(
            value: item,
            enabled: true,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                      child: getTextWidget(
                          title: item.companyTypes!,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightLight,
                          textColor: darkblack)),
                ],
              ),
            ),
          );
        }).toList(),
        value: typeofCompany,
        onChanged: (value) {
          setState(() {
            typeofCompany = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 45,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43.0),
            border: Border.all(
              color: darkblack,
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
          width: MediaQuery.of(context).size.width * 0.9,
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
      )),
    );
  }
}
