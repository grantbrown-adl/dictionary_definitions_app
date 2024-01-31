// To parse this JSON data, do
//
//     final undefinedModel = undefinedModelFromJson(jsonString);

//TODO: rename this as model is ambiguous likely undefinedWordModel
import 'dart:convert';

UndefinedModel undefinedModelFromJson(String str) =>
    UndefinedModel.fromJson(json.decode(str));

String undefinedModelToJson(UndefinedModel data) => json.encode(data.toJson());

class UndefinedModel {
  String title;
  String message;
  String resolution;

  UndefinedModel({
    required this.title,
    required this.message,
    required this.resolution,
  });

  factory UndefinedModel.fromJson(Map<String, dynamic> json) => UndefinedModel(
        title: json["title"],
        message: json["message"],
        resolution: json["resolution"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "resolution": resolution,
      };
}
