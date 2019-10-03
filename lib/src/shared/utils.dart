import 'package:flutter/material.dart';

class Utils {
  static void showAlert(
      {BuildContext context, String title, String body, List<Widget> actions}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text(title), content: Text(body), actions: actions);
      },
    );
  }
}
