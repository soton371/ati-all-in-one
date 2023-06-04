// To parse this JSON data, do
//
//     final appDataModel = appDataModelFromJson(jsonString);

import 'dart:convert';

AppDataModel appDataModelFromJson(String str) => AppDataModel.fromJson(json.decode(str));

String appDataModelToJson(AppDataModel data) => json.encode(data.toJson());

class AppDataModel {
    AppDataModel({
        this.statusCode,
        this.objResponse,
        this.message
    });

    int? statusCode;
    ObjResponse? objResponse;
    String? message;

    factory AppDataModel.fromJson(Map<String, dynamic> json) => AppDataModel(
        statusCode: json["statusCode"],
        objResponse: json["objResponse"] == null ? null : ObjResponse.fromJson(json["objResponse"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "objResponse": objResponse?.toJson(),
        "message": message,
    };
}

class ObjResponse {
    ObjResponse({
        this.appServerVersion,
        this.userActiveFlag,
    });

    int? appServerVersion;
    int? userActiveFlag;

    factory ObjResponse.fromJson(Map<String, dynamic> json) => ObjResponse(
        appServerVersion: json["appServerVersion"],
        userActiveFlag: json["userActiveFlag"],
    );

    Map<String, dynamic> toJson() => {
        "appServerVersion": appServerVersion,
        "userActiveFlag": userActiveFlag,
    };
}
