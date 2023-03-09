// To parse this JSON data, do
//
//     final mechanicModel = mechanicModelFromJson(jsonString);

import 'dart:convert';

List<MechanicModel> mechanicModelFromJson(String str) => List<MechanicModel>.from(json.decode(str).map((x) => MechanicModel.fromJson(x)));

String mechanicModelToJson(List<MechanicModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MechanicModel {
  MechanicModel({
    required this.id,
    required this.customer,
    required this.cusName,
    required this.mobile,
    required this.outlate,
    required this.address,
    required this.salesPerson,
    required this.spPhone,
    required this.tsoBpId,
    required this.tsoBpName,
    required this.area,
    required this.territory,
    required this.location,
    required this.dealerId,
    required this.dealerName,
  });

  int id;
  String customer;
  String cusName;
  String mobile;
  String outlate;
  String address;
  String salesPerson;
  String spPhone;
  String tsoBpId;
  String tsoBpName;
  String area;
  String territory;
  String location;
  String dealerId;
  String dealerName;

  factory MechanicModel.fromJson(Map<String, dynamic> json) => MechanicModel(
    id: json["ID"],
    customer: json["customer"],
    cusName: json["cus_name"],
    mobile: json["mobile"],
    outlate: json["outlate"],
    address: json["address"],
    salesPerson: json["sales_person"],
    spPhone: json["sp_phone"],
    tsoBpId: json["tso_bp_id"],
    tsoBpName: json["tso_bp_name"],
    area: json["area"],
    territory: json["territory"],
    location: json["location"],
    dealerId: json["dealer_id"],
    dealerName: json["dealer_name"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "customer": customer,
    "cus_name": cusName,
    "mobile": mobile,
    "outlate": outlate,
    "address": address,
    "sales_person": salesPerson,
    "sp_phone": spPhone,
    "tso_bp_id": tsoBpId,
    "tso_bp_name": tsoBpName,
    "area": area,
    "territory": territory,
    "location": location,
    "dealer_id": dealerId,
    "dealer_name": dealerName,
  };
}
