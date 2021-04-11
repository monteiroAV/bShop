import 'package:flutter/material.dart';

class LoginFormField extends StatelessWidget {
  const LoginFormField(
      {this.controller,
      this.hint,
      this.prefix,
      this.suffix,
      this.obscure,
      this.textInputType,
      this.onChanged,
      this.enabled,
      this.suffixIcon,
      this.initialValue,
      this.validator, this.onSaved,
     });
  final TextEditingController controller;
  final String hint;
  final String initialValue;
  final Widget prefix;
  final Widget suffix;
  final Widget suffixIcon;
  final bool obscure;
  final TextInputType textInputType;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final bool enabled;
  final FormFieldValidator<String> validator;
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      obscureText: obscure,
      keyboardType: textInputType,
      onChanged: onChanged,
      enabled: enabled,
      validator: validator,
      autocorrect: false,
      onSaved: onSaved,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.blue[300]),
          prefixIcon: prefix,
          suffix: suffix,
          suffixIcon: suffixIcon),
    );
  }
}
