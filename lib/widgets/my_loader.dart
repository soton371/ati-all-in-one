import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void myLoader(BuildContext context,String msg) {
  CupertinoAlertDialog alert= CupertinoAlertDialog(
    content: Column(
      children: [
        Text("$msg\n"),
        const LinearProgressIndicator(),
      ],),
  );
  showCupertinoDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}
