// To parse this JSON data, do
//
//     final territoryListModel = territoryListModelFromJson(jsonString);

import 'dart:convert';

List<TerritoryListModel> territoryListModelFromJson(String str) => List<TerritoryListModel>.from(json.decode(str).map((x) => TerritoryListModel.fromJson(x)));

String territoryListModelToJson(List<TerritoryListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TerritoryListModel {
  TerritoryListModel({
    required this.zid,
    required this.xterritory,
    required this.xsp,
    required this.xso,
  });

  int zid;
  String xterritory;
  String xsp;
  String xso;

  factory TerritoryListModel.fromJson(Map<String, dynamic> json) => TerritoryListModel(
    zid: json["zid"],
    xterritory: json["xterritory"],
    xsp: json["xsp"],
    xso: json["xso"],
  );

  Map<String, dynamic> toJson() => {
    "zid": zid,
    "xterritory": xterritory,
    "xsp": xsp,
    "xso": xso,
  };
}
