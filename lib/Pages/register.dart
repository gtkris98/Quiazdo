import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quizadoapp/widgets/dialog.dart';
import 'package:quizadoapp/widgets/loading_animation.dart';
import '../widgets/CustomTextField.dart';
import '../Services/Auth.dart';
import '../widgets/error_alert.dart';

class RegisterState extends StatefulWidget {
  final BaseAuth _auth;

  const RegisterState( this._auth);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterState> {
  String _userEmail;
  String _password;
  String _confirmPassword;
  String _userName;

  final _backgroundColor = Colors.green[100];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    ProgressDialog registerDialog = createProgressDialog();

    final loginForm = Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1),
              child: Text(
                'Register',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 30),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1),
              child: CustomTextField(
                onSaved: (input) {
                  setState(() {
                    _userName = input;
                  });
                },
                validator: _isNameValid,
                icon: Icon(Icons.perm_identity),
                hint: "Name",
                textInputType: TextInputType.text,
                currentFocusNode: _nameFocus,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1),
              child: CustomTextField(
                onSaved: (input) {
                  setState(() {
                    _userEmail = input;
                  });
                },
                validator: _isEmailValid,
                icon: Icon(Icons.email),
                hint: "Email",
                textInputType: TextInputType.emailAddress,
                currentFocusNode: _emailFocus,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1),
              child: CustomTextField(
                icon: Icon(Icons.lock),
                obscure: true,
                onSaved: (input) {
                  setState(() {
                    _password = input;
                  });
                },
                validator: _isPasswordValid,
                hint: "Password",
                currentFocusNode: _passwordFocus,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1),
              child: CustomTextField(
                icon: Icon(Icons.lock),
                obscure: true,
                onSaved: (input) {
                  setState(() {
                    _confirmPassword = input;
                  });
                },
                validator: _doPasswordMatch,
                hint: "Confirm Password",
                currentFocusNode: _confirmPasswordFocus,
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
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate()) {
                      registerDialog.show();
                      widget._auth.register(_userEmail, _password, _userName).then((FirebaseUser user) {
                        print(user.uid + 'Signup Succesfull');
                      }).then((_){
                        widget._auth.sendEmailVerification().then((_){
                          registerDialog.hide();
                          Navigator.pop(context);
                          _showDialog();
//                          Navigator.push(context, route)
//                          return InfoDialog("Verify Email","Please verify your email using the link sent to you.","Ok");
                        });
                      }).catchError((e) {
                        registerDialog.hide();
                        print('Login failed');
                        print(e);
                        _handleRegisterError(e);
                      });
                    } else {
                      _autoValidate = true;
                    }
                  },
                  child: Text(
                    'Register',
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
      child: loginForm,
    );
  }


  String _isEmailValid(String email) {
    if (EmailValidator.validate(email)) {
      return null;
    }
    return 'Invalid Email Id';
  }

  String _isPasswordValid(String password) {
    print("hey password is" + password);
    if (password.isEmpty || password.length < 6 || password.length > 20) {
      return 'Password length should be between 6 to 20';
    }
    return null;
  }

  String _isNameValid(String name) {
    if (name.isEmpty || name.length < 3) {
      return 'Name must be atleast 3 char';
    } else if (name.length > 15) {
      return 'Name length should be less than 15';
    }
    return null;
  }

  String _doPasswordMatch(String password) {
    if (_password != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  ProgressDialog createProgressDialog() {
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Registering...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: LoadingAnimation(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return pr;
  }

  void _handleRegisterError(e) {

    switch(e.code){
      case "ERROR_EMAIL_ALREADY_IN_USE": {new ErrorAlert("Email Already Exists", "You already have a account with this email address. Please try logging in.", "Ok").showErrorAlert(context);}
      break;
      case "ERROR_NETWORK_REQUEST_FAILED": {new ErrorAlert("Internal Error", "We are facing some internal error. Please try again after some time.", "Ok").showErrorAlert(context);}
      break;
      case "ERROR_INVALID_EMAIL": {new ErrorAlert("Invalid Email", "This email is not valid. Please try again.", "Ok").showErrorAlert(context);}
      break;
      default: {new ErrorAlert(e.code, e.message, "Ok").showErrorAlert(context);}
      break;
    }

  }

  void _showDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verification"),
          content: new Text("Please verify your email address. Verification link has been sent to your email"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
