import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> uninstallApp(String packageName, String url) async {
  debugPrint('call uninstallApp');
  try {
    final androidIntent = AndroidIntent(
      action: 'android.intent.action.UNINSTALL_PACKAGE',
      data: 'package:$packageName',
    );
    await androidIntent.launch().whenComplete(() => deleteApk(url));
  } on Exception catch (e) {
    debugPrint('Failed to uninstall $packageName: $e');
  }
}

Future<void> deleteApk(String url) async {
  Directory? externalDir = await getExternalStorageDirectory();
  try {
    if (externalDir != null && externalDir.path.isNotEmpty && url.isNotEmpty) {
    String fileName = url.split('/').last.trim();
    String fileDir = '${externalDir.path}/$fileName';
    File f = File(fileDir);
    await f.delete();
  } else {
    debugPrint('externalDir from deleteApk: $externalDir url: $url');
  }
  } catch (e) {
    debugPrint('could not delete apk => No such file or directory');
  }
  
}
