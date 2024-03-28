import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants/color_constants.dart';

void showOkCancelAlertDialog({
  required BuildContext context,
  String? message,
  String? okButtonTitle,
  String? cancelButtonTitle,
  Function? cancelButtonAction,
  Function? okButtonAction,
  bool isCancelEnable = true,
}) {
  showDialog(
    barrierDismissible: isCancelEnable,
    context: context,
    builder: (context) {
      if (Platform.isIOS) {
        return _showOkCancelCupertinoAlertDialog(
            context,
            message!,
            okButtonTitle,
            cancelButtonTitle,
            okButtonAction,
            isCancelEnable,
            cancelButtonAction);
      } else {
        return _showOkCancelMaterialAlertDialog(
            context,
            message!,
            okButtonTitle,
            cancelButtonTitle,
            okButtonAction,
            isCancelEnable,
            cancelButtonAction);
      }
    },
  );
}

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      if (Platform.isIOS) {
        return _showCupertinoAlertDialog(context, message);
      } else {
        return _showMaterialAlertDialog(context, message);
      }
    },
  );
}

CupertinoAlertDialog _showCupertinoAlertDialog(
    BuildContext context, String message) {
  return CupertinoAlertDialog(
    title: const Text("W-Connectors"),
    content: Text(
      message,
      style: TextStyle(color: Colors.black12.withOpacity(0.6)),
    ),
    actions: _actions(context),
  );
}

AlertDialog _showMaterialAlertDialog(BuildContext context, String message) {
  return AlertDialog(
    title: const Text("W-Connectors"),
    content: Text(
      message,
      style: TextStyle(color: Colors.black12.withOpacity(0.6)),
    ),
    actions: _actions(context),
  );
}

AlertDialog _showOkCancelMaterialAlertDialog(
    BuildContext context,
    String message,
    String? okButtonTitle,
    String? cancelButtonTitle,
    Function? okButtonAction,
    bool isCancelEnable,
    Function? cancelButtonAction) {
  return AlertDialog(
    title: const Text("W-Connectors"),
    content: Text(message),
    actions: isCancelEnable
        ? _okCancelActions(
            context: context,
            okButtonTitle: okButtonTitle,
            cancelButtonTitle: cancelButtonTitle,
            okButtonAction: okButtonAction,
            isCancelEnable: isCancelEnable,
            cancelButtonAction: cancelButtonAction,
          )
        : _okAction(
            context: context,
            okButtonAction: okButtonAction,
            okButtonTitle: okButtonTitle),
  );
}

CupertinoAlertDialog _showOkCancelCupertinoAlertDialog(
  BuildContext context,
  String message,
  String? okButtonTitle,
  String? cancelButtonTitle,
  Function? okButtonAction,
  bool isCancelEnable,
  Function? cancelButtonAction,
) {
  return CupertinoAlertDialog(
      title: const Text("W-Connectors"),
      content: Text(message),
      actions: isCancelEnable
          ? _okCancelActions(
              context: context,
              okButtonTitle: okButtonTitle,
              cancelButtonTitle: cancelButtonTitle,
              okButtonAction: okButtonAction,
              isCancelEnable: isCancelEnable,
              cancelButtonAction: cancelButtonAction,
            )
          : _okAction(
              context: context,
              okButtonAction: okButtonAction,
              okButtonTitle: okButtonTitle));
}

List<Widget> _actions(BuildContext context) {
  return <Widget>[
    Platform.isIOS
        ? CupertinoDialogAction(
            child: const Text(
              "ok",
              style: TextStyle(color: bluecolor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        : TextButton(
            child: const Text(
              "ok",
              style: TextStyle(color: bluecolor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
  ];
}

List<Widget> _okCancelActions({
  BuildContext? context,
  String? okButtonTitle,
  String? cancelButtonTitle,
  Function? okButtonAction,
  bool? isCancelEnable,
  Function? cancelButtonAction,
}) {
  return <Widget>[
    Platform.isIOS
        ? CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: cancelButtonAction == null
                ? () {
                    Navigator.of(context!).pop();
                  }
                : () {
                    Navigator.of(context!).pop();
                    cancelButtonAction();
                  },
            child: Text(
              cancelButtonTitle ?? "",
              style: const TextStyle(color: bluecolor),
            ),
          )
        : TextButton(
            onPressed: cancelButtonAction == null
                ? () {
                    Navigator.of(context!).pop();
                  }
                : () {
                    Navigator.of(context!).pop();
                    cancelButtonAction();
                  },
            child: Text(
              cancelButtonTitle ?? "",
              style: const TextStyle(color: blackcolor),
            ),
          ),
    Platform.isIOS
        ? CupertinoDialogAction(
            child: Text(
              okButtonTitle!,
              style: const TextStyle(color: bluecolor),
            ),
            onPressed: () {
              Navigator.of(context!).pop();
              okButtonAction!();
            },
          )
        : TextButton(
            child: Text(
              okButtonTitle!,
              style: const TextStyle(color: bluecolor),
            ),
            onPressed: () {
              Navigator.of(context!).pop();
              okButtonAction!();
            },
          ),
  ];
}

List<Widget> _okAction(
    {BuildContext? context, String? okButtonTitle, Function? okButtonAction}) {
  return <Widget>[
    Platform.isIOS
        ? CupertinoDialogAction(
            child: Text(okButtonTitle!),
            onPressed: () {
              Navigator.of(context!).pop();
              okButtonAction!();
            },
          )
        : TextButton(
            child: Text(okButtonTitle!),
            onPressed: () {
              Navigator.of(context!).pop();
              okButtonAction!();
            },
          ),
  ];
}

Future<bool?> displayToast(String message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: bluecolor,
      textColor: Colors.white,
      fontSize: 14);
}

SnackBar displaySnackBar({required String message}) {
  return SnackBar(
    content: Text(
      message,
      style: const TextStyle(color: Colors.white, fontSize: 14),
    ),
    duration: const Duration(seconds: 2),
    backgroundColor: bluecolor,
  );
}

Alert connectorAlertDialogue({
  required BuildContext context,
  bool onWillPopActive = true,
  AlertType type = AlertType.error,
  required String? desc,
  required void Function()? onPressed,
  String buttonTitle = 'Ok',
}) {
  return Alert(
    onWillPopActive: onWillPopActive,
    closeIcon: const Text(''),
    closeFunction: () {},
    context: context,
    type: type,
    desc: desc,
    buttons: [
      DialogButton(
        onPressed: onPressed,
        //  ()  Navigator.pop(context),
        width: 120,
        color: bluecolor,
        child: Text(
          buttonTitle,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ],
  );
}
