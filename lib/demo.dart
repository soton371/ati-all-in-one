// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class DemoScreen extends StatefulWidget {
//   const DemoScreen({super.key});

//   @override
//   State<DemoScreen> createState() => _DemoScreenState();
// }

// class _DemoScreenState extends State<DemoScreen> {
//   late String _localPath;
//   static String myTaskId = '';
//   String apkUrl = 'http://192.168.0.164/soton/ati-all-apps/raw/master/counter.apk';

//   @override
//   void initState() {
//     super.initState();
//     _checkStoragePermission();
//     FlutterDownloader.registerCallback(downloadCallback, step: 1);
//   }

//   Future<void> _checkStoragePermission() async {
//     /// Snippet when user clicks on download second time
//     const permission = Permission.storage;
//     final status = await permission.status;
//     debugPrint('>>>Status $status');
//     _prepareSaveDir();
//     if (status != PermissionStatus.granted) {
//       await permission.request();
//       if (await permission.status.isGranted) {
//         _prepareSaveDir();
//       } else if (await permission.status.isDenied) {
//         //show dialog
//       } else {
//         await permission.request();
//       }
//       debugPrint('>>> ${await permission.status}');
//     }
//   }

//   @override
//   void dispose() {
//     _unbindBackgroundIsolate();
//     super.dispose();
//   }

//   static int downloadProgress = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('$downloadProgress %\n'),
//             ElevatedButton(
//                 onPressed: () async {
//                   debugPrint('_localPath: $_localPath');
//                   final taskId = await FlutterDownloader.enqueue(
//                     url: apkUrl,
//                     headers: {},
//                     savedDir: _localPath,
//                     showNotification: true,
//                     openFileFromNotification: true,
//                   );
//                   myTaskId = taskId ?? '';
//                   debugPrint('myTaskId: $myTaskId');
//                   setState(() {});
//                 },
//                 child: const Text('Download')),

//                 Text('\n\n $_openResult \n\n'),

//                 ElevatedButton(
//                   onPressed: openFile, 
//                 child: const Text('Open')
//                 )
//           ],
//         ),
//       ),
//     );
//   }

//   // all method
//   var _openResult = 'Unknown';
//   Future<void> openFile() async {
//     String fileName = apkUrl.split('/').last.trim();
//     String path = (await _downloadFilePath());
//     String filePath = '$path/$fileName';
//     debugPrint('filePath: $filePath');
//     final result = await OpenFilex.open(filePath);

//     setState(() {
//       _openResult = "type=${result.type}  message=${result.message}";
//     });
//   }
  
//   Future<void> _prepareSaveDir() async {
//     _localPath = (await _downloadFilePath());
//     final savedDir = Directory(_localPath);
//     if (!savedDir.existsSync()) {
//       await savedDir.create();
//     }
//   }

//   Future<String> _downloadFilePath() async {
//     Directory? externalDir = await getExternalStorageDirectory();
//     if (externalDir == null) {
//       debugPrint("externalDir: null");
//       return '';
//     } else {
//       debugPrint("externalDir: ${externalDir.path}");
//       return externalDir.path;
//     }
//   }


//   @pragma('vm:entry-point')
//   static void downloadCallback(
//     String id,
//     DownloadTaskStatus status,
//     int progress,
//   ) {
//     debugPrint(
//       'Callback on background isolate: '
//       'task ($id) is in status ($status) and process ($progress)',
//     );

//     IsolateNameServer.lookupPortByName('downloader_send_port')
//         ?.send([id, status, progress]);
    
//     installApk(id, status);
//   }
  
//   static void installApk(String taskId, DownloadTaskStatus value) async{
//     debugPrint('value: $value');
//     if (value.toString() == 'DownloadTaskStatus(3)') {
//       debugPrint('download done from background & taskId: $taskId');
      
//     }
//   }
  
//   void _unbindBackgroundIsolate() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }
// }

// class TaskInfo {
//   TaskInfo({this.name, this.link});

//   final String? name;
//   final String? link;

//   String? taskId;
//   int? progress = 0;
//   DownloadTaskStatus? status = DownloadTaskStatus.undefined;
// }
