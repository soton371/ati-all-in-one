// To parse this JSON data, do
//
    // final checklistModel = checklistModelFromJson(jsonString);

import 'dart:convert';

List<ChecklistModel> checklistModelFromJson(String str) => List<ChecklistModel>.from(json.decode(str).map((x) => ChecklistModel.fromJson(x)));

String checklistModelToJson(List<ChecklistModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChecklistModel {
    String? title;
    bool? value;

    ChecklistModel({
        this.title,
        this.value,
    });

    factory ChecklistModel.fromJson(Map<String, dynamic> json) => ChecklistModel(
        title: json["title"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
    };
}
