class MyUrls {
  static const String baseUrl = "http://gpst.billingdil.com:8088";
  static const String appStoreLink = "https://play.google.com/store/apps/details?id=com.atilimited.ati_all_in_one";
  static const String appData = "$baseUrl/dil_rmd_ws/api/policy/app-data/2";
  static const String appList = "http://192.168.0.164/soton/ati-all-in-one/raw/master/assets/jsons/apps_list.json";
  static const String sendLocation = "http://203.130.133.168/ati_ets/location/send-location";
  static String appLogin(String username, String password) => "http://ati-ms:ati-pass@192.168.0.91:9191/auth-api/oauth/token?grant_type=password&username=$username&password=$password";
}