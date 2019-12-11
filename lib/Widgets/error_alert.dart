import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ErrorAlert{

  final String errorTitle;
  final String errorDescription;
  final String buttonText;

  const ErrorAlert(this.errorTitle, this.errorDescription, this.buttonText) ;

  showErrorAlert(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: errorTitle,
      desc: errorDescription,
      buttons: [
        DialogButton(
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

}