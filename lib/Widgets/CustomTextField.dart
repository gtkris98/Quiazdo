import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
      this.hint,
      this.obscure = false,
      this.validator,
      this.onSaved,
      this.textInputType,
      this.currentFocusNode,
});
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obscure;
  final FormFieldValidator<String> validator;
  final TextInputType textInputType;
  final FocusNode currentFocusNode;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        keyboardType: textInputType,
        focusNode: currentFocusNode,
        onSaved: onSaved,
        validator: validator,
        autofocus: true,
        obscureText: obscure,
        style: TextStyle(
          fontSize: 15,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 15),
            labelText: hint,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
            ),
//
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 0, right: 10),
            )),
      ),
    );
  }

}
