import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:quizadoapp/widgets/error_alert.dart';
import 'package:quizadoapp/Pages/forgot_password.dart';
import 'package:quizadoapp/widgets/loading_animation.dart';
import 'package:quizadoapp/Pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../widgets/CustomTextField.dart';
import '../Services/Auth.dart';
import 'dahboard.dart';

class Login extends StatefulWidget {
  final BaseAuth _auth;

  const Login( this._auth);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _userEmail;
  String _password;
  final _backgroundColor = Colors.red[100];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String dialogText = "Please verify your email address using the link sent to you during registration.";
  bool _isEmailSent = false;
  @override
  Widget build(BuildContext context) {
    final loginForm = Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: 8.0, vertical: MediaQuery.of(context).size.height * 0.05),
      child: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: CustomTextField(
                onSaved: (input) {
                  setState(() {
                    _userEmail = input;
                  });
                },
                validator: _isEmailValid,
                icon: Icon(Icons.email),
                hint: "EMAIL",
                textInputType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: CustomTextField(
                icon: Icon(Icons.lock),
                obscure: true,
                onSaved: (input) {
                  setState(() {
                    _password = input;
                  });
                },
                validator: _isPasswordValid,
                hint: "PASSWORD",
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              width: MediaQuery.of(context).size.width * 0.83,
              height: 50,
              child: Padding(
                padding: EdgeInsets.fromLTRB(2, 6, 2, 0),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  splashColor: Colors.red[100],
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      ProgressDialog loginDialog = createProgressDialog();
                      loginDialog.show();
                      _formKey.currentState.save();
                      widget._auth.signIn(_userEmail, _password).then((FirebaseUser user) {
                        print(user.email + 'Login Succesfull');

                      }).then((_){
                        widget._auth.isEmailVerified().then((bool isVerified){
                          loginDialog.hide();
                          if(isVerified){
//                            Navigator.pop(context);
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) =>
//                                        UserDashboardWidget(widget._auth)));
                              Navigator.of(context).popAndPushNamed('/dashboard', arguments: widget._auth);
                          }
                          else{
                            _showDialog();
                          }
                        });
                      }).catchError((e) {
                        loginDialog.hide();
                        print('Login failed' + e.message.toString());
                        _handleLoginError(e);
                      });
                    } else {
                      _autoValidate = true;
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              width: MediaQuery.of(context).size.width * 0.83,
              height: 50,
              child: Padding(
                padding: EdgeInsets.fromLTRB(2, 6, 2, 0),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  textColor: Theme.of(context).primaryColor,
                  color: Colors.white,
                  splashColor: Colors.red,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => RegisterState(widget._auth));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => ForgotPassword(widget._auth));
                  },
                  child: Text(
                    'Forgot Password? Tap Here.',
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                        letterSpacing: 1.3),
                  ),
                )),
          ],
        ),
      ),
    );

    final appBar = AppBar(
      elevation: 1.0,
      title: Image.asset('assets/logo.png', fit: BoxFit.cover),
      centerTitle: true,
    );

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: loginForm,
      ),
    );
  }

  String _isEmailValid(String email) {
    if (EmailValidator.validate(email)) {
      return null;
    }
    return 'Invalid Email Id';
  }

  String _isPasswordValid(String password) {
//    print("hey password is" + password);
    if (password.isEmpty || password.length < 6 || password.length > 20) {
      return 'Password length should be between 6 to 20';
    }
    return null;
  }

  ProgressDialog createProgressDialog() {
    ProgressDialog pr = new ProgressDialog(context,
        isDismissible: false, type: ProgressDialogType.Normal);
    pr.style(
      message: 'Logging In..',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: LoadingAnimation(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return pr;
  }

  void _handleLoginError(e) {

    switch(e.code){
      case "ERROR_WRONG_PASSWORD": {new ErrorAlert("Incorrect Password", "You have entered incorrect password. Please try again.", "Ok").showErrorAlert(context);}
      break;
      case "ERROR_USER_NOT_FOUND": {new ErrorAlert("Incorrect Email", "We have no user registered with this email id. Please try again.", "Ok").showErrorAlert(context);}
      break;
      case "ERROR_INVALID_EMAIL": {new ErrorAlert("Invalid Email", "This email is not valid. Please try again.", "Ok").showErrorAlert(context);}
      break;
      case "ERROR_NETWORK_REQUEST_FAILED": {new ErrorAlert("Internal Error", "We are facing some internal error. Please try again after some time.", "Ok").showErrorAlert(context);}
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
          content: new Text(dialogText),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Visibility(
              visible: !_isEmailSent,
              child: new FlatButton(
                child: new Text("Resend Verification Link"),
                onPressed: () {
                  widget._auth.sendEmailVerification().then((_){
                    setState(() {
                      dialogText = "Verification email has been sent to your email address.";
                      _isEmailSent = true;
                    });
                  }).catchError((e){
                    Navigator.of(context).pop();
                    _handleLoginError(e);
                  });
                },
              ),
            )

          ],
        );
      },
    );
  }


}

