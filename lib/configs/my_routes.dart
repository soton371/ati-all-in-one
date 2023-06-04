import 'package:flutter/cupertino.dart';

class MyRoutes {
  static void pushAndRemoveUntil(BuildContext context, myPage)=>
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_)=>myPage), (route) => false);
    // Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_)=>myPage));
}