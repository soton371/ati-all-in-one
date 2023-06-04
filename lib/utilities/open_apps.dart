import 'dart:io';
import 'dart:ui';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// add open apps
void openApps(String id, String url) async {
  if (url.isEmpty) {
    //add for If there is a play store but not install then this app redirect play store or open apps
    await LaunchApp.openApp(
      androidPackageName: id,
    );
  } else {
    // for download
    checkDownload(url);
  }
}
// end open apps

//for download apk
class TaskInfo {
  TaskInfo({this.name, this.link});

  final String? name;
  final String? link;

  String? taskId;
  int? progress = 0;
  DownloadTaskStatus? status = DownloadTaskStatus.undefined;
}

void unbindBackgroundIsolate() {
  IsolateNameServer.removePortNameMapping('downloader_send_port');
}

@pragma('vm:entry-point')
void downloadCallback(
  String id,
  DownloadTaskStatus status,
  int progress,
) {
  debugPrint(
    'Callback on background isolate: '
    'task ($id) is in status ($status) and process ($progress)',
  );

  IsolateNameServer.lookupPortByName('downloader_send_port')
      ?.send([id, status, progress]);
}

Future<String> downloadFilePath() async {
  Directory? externalDir = await getExternalStorageDirectory();
  if (externalDir == null) {
    debugPrint("externalDir: null");
    return '';
  } else {
    return externalDir.path;
  }
}

Future<void> checkDownload(String url) async {
  const permission = Permission.storage;
  final status = await permission.status;
  debugPrint('>>>Status $status');
  downloadApk(url);
  if (status != PermissionStatus.granted) {
    await permission.request();
    if (await permission.status.isGranted) {
      downloadApk(url);
    } else if (await permission.status.isDenied) {
      //show dialog
    } else {
      await permission.request();
    }
    debugPrint('>>> ${await permission.status}');
  }
}

Future<void> downloadApk(String url) async {
  String savePath = (await downloadFilePath());
  final savedDir = Directory(savePath);
  if (!savedDir.existsSync()) {
    await savedDir.create();
  }
  // check apk already downloaded
  String fileName = url.split('/').last.trim();
  String fileDir = '$savePath/$fileName';
  // String fileDir = "File: '$savePath/$fileName'";
  List files = savedDir.listSync();
  bool fileHas = false;
  for (var element in files) {
    if (element.toString() == "File: '$fileDir'") {
      fileHas = true;
    }
  }
  
  if (fileHas) {
    //for install alert
    await OpenFilex.open(fileDir);
  } else {
    //download for app
    await FlutterDownloader.enqueue(
      url: url,
      headers: {},
      savedDir: savePath,
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
//end download apk


