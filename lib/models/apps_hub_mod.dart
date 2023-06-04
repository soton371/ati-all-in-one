// To parse this JSON data, do
//
//     final appsHubModel = appsHubModelFromJson(jsonString);

import 'dart:convert';

List<AppsHubModel> appsHubModelFromJson(String str) => List<AppsHubModel>.from(json.decode(str).map((x) => AppsHubModel.fromJson(x)));

String appsHubModelToJson(List<AppsHubModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppsHubModel {
    AppsHubModel({
        this.id,
        this.appOrder = 0,
        this.appName,
        this.appId,
        this.appImg,
        this.appUrl,
        this.appInstalled,
    });

    int? id ;
    int appOrder = 0;
    String? appName;
    String? appId;
    String? appImg;
    String? appUrl;
    String? appInstalled;

    factory AppsHubModel.fromJson(Map<String, dynamic> json) => AppsHubModel(
        id: json["id"],
        appOrder: json["appOrder"],
        appName: json["appName"],
        appId: json["appId"],
        appImg: json["appImg"],
        appUrl: json["appUrl"],
        appInstalled: json["appInstalled"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "appOrder": appOrder,
        "appName": appName,
        "appId": appId,
        "appImg": appImg,
        "appUrl": appUrl,
        "appInstalled": appInstalled,
    };
}
