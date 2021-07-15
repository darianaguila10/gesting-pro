import 'package:flutter/material.dart';

void showCustomSnackBar(String c, scalffoldkey, {Color color = Colors.green}) {
  scalffoldkey.currentState.showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      behavior: SnackBarBehavior.floating,
      action:
          SnackBarAction(textColor: color, label: "aceptar", onPressed: () {}),
      duration: Duration(milliseconds: 2000),
      content: Text(c)));
}

void showCustomDialog(BuildContext context, title, content) {
  showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text(title),
        content: SingleChildScrollView(
            child: Container(
          child: Text(content),
        )),
        actions: <Widget>[
          FlatButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ));
}
