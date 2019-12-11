import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizadoapp/Pages/dahboard.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../widgets/CustomTextField.dart';
import '../Services/Auth.dart';

class ForgotPassword extends StatefulWidget {
  final BaseAuth _auth;

  const ForgotPassword( this._auth);
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _userEmail;
  String _dialogText = 'Reset Password';
  bool _isEmailFieldVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = createProgressDialog();

    final forgotPasswordForm = Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Visibility(
              visible: _isEmailFieldVisible,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1),
                child:
                CustomTextField(
                  onSaved: (input) {
                    _userEmail = input;
                  },
                  validator: _isEmailValid,
                  icon: Icon(Icons.email),
                  hint: "Email",
                  textInputType: TextInputType.emailAddress,
                ),
              ),
            ),
            Visibility(
              visible: !_isEmailFieldVisible,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 1),
                child:
                Text(
                  'Email with reset password link has been sent to you on your email address',
                  softWrap: true,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black, fontSize: 15),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              width: MediaQuery.of(context).size.width * 0.83,
              height: 50,
              child: Padding(
                padding: EdgeInsets.all(2),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  textColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                  splashColor: Colors.red,
                  onPressed: () {
                    if(_dialogText.toLowerCase() == "ok"){
                      progressDialog.hide();
                      Navigator.of(context).pop();
                    }
                    else{
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        progressDialog.show();
                        widget._auth.resetPassword(_userEmail).then((void a){
                          progressDialog.hide();
                          setState(() {
                            _isEmailFieldVisible = false;
                            _dialogText = "Ok";
                          });
                        }).catchError((onError){

                        });
                      } else {
                        _autoValidate = true;
                      }
                    }

                  },
                  child: Text(
                    _dialogText,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: forgotPasswordForm,
    );
  }


  String _isEmailValid(String email) {
    if (EmailValidator.validate(email)) {
      return null;
    }
    return 'Invalid Email Id';
  }



  ProgressDialog createProgressDialog() {
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Please Wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return pr;
  }
}
