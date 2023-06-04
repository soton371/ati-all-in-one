// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.accessToken,
        this.tokenType,
        this.refreshToken,
        this.expiresIn,
        this.scope,
    });

    String? accessToken;
    String? tokenType;
    String? refreshToken;
    int? expiresIn;
    String? scope;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        refreshToken: json["refresh_token"],
        expiresIn: json["expires_in"],
        scope: json["scope"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "refresh_token": refreshToken,
        "expires_in": expiresIn,
        "scope": scope,
    };
}
