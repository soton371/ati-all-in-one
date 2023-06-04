import 'package:url_launcher/url_launcher.dart';

Future<void> launchAppStore(String appStoreLink) async {
    var uri = Uri.parse(appStoreLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch appStoreLink';
    }
  }