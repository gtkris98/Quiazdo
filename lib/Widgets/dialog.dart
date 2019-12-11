import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoDialog extends StatefulWidget {
  final String dialogTitle;
  final String dialogText;
  final String dialogButtonText;

  const InfoDialog(this.dialogTitle, this.dialogText, this.dialogButtonText);
  @override
  _InfoDialog createState() => _InfoDialog();
}

class _InfoDialog extends State<InfoDialog> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: AlertDialog(
        title: new Text(widget.dialogTitle),
        content: new Text(widget.dialogText),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.pop(context),
            child: new Text(widget.dialogButtonText),
          )
        ],
      ),
    );

  }
}
