// To parse this JSON data, do
//
//     final qrReturnModel = qrReturnModelFromJson(jsonString);

import 'dart:convert';

QrReturnModel qrReturnModelFromJson(String str) => QrReturnModel.fromJson(json.decode(str));

String qrReturnModelToJson(QrReturnModel data) => json.encode(data.toJson());

class QrReturnModel {
  QrReturnModel({
    required this.code,
    required this.batch,
    required this.xdate,
    required this.squ,
    required this.perLiterDis,
  });

  String code;
  String batch;
  String xdate;
  String squ;
  String perLiterDis;

  factory QrReturnModel.fromJson(Map<String, dynamic> json) => QrReturnModel(
    code: json["code"],
    batch: json["batch"],
    xdate: json["xdate"],
    squ: json["squ"],
    perLiterDis: json["perLiter_Dis"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "batch": batch,
    "xdate": xdate,
    "squ": squ,
    "perLiter_Dis": perLiterDis,
  };
}
