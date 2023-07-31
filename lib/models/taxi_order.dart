// To parse this JSON data, do
//
//     final taxiOrder = taxiOrderFromJson(jsonString);

import 'dart:convert';
import 'package:groscross/models/currency.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

TaxiOrder taxiOrderFromJson(String str) => TaxiOrder.fromJson(json.decode(str));

String taxiOrderToJson(TaxiOrder data) => json.encode(data.toJson());

class TaxiOrder {
  TaxiOrder({
    required this.id,
    required this.orderId,
    required this.vehicleTypeId,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupAddress,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.dropoffAddress,
    required this.createdAt,
    required this.updatedAt,
    this.currency,
  });

  int id;
  int orderId;
  int vehicleTypeId;
  String pickupLatitude;
  String pickupLongitude;
  String pickupAddress;
  String dropoffLatitude;
  String dropoffLongitude;
  String dropoffAddress;
  DateTime createdAt;
  DateTime updatedAt;
  Currency? currency;

  factory TaxiOrder.fromJson(Map<String, dynamic> json) => TaxiOrder(
        id: int.parse(json["id"].toString()),
        orderId: int.parse(json["order_id"].toString()),
        vehicleTypeId: int.parse(json["vehicle_type_id"].toString()),
        pickupLatitude: json["pickup_latitude"],
        pickupLongitude: json["pickup_longitude"],
        pickupAddress: json["pickup_address"],
        dropoffLatitude: json["dropoff_latitude"],
        dropoffLongitude: json["dropoff_longitude"],
        dropoffAddress: json["dropoff_address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        currency: json['currency'] != null
            ? Currency.fromJSON(json['currency'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "vehicle_type_id": vehicleTypeId,
        "pickup_latitude": pickupLatitude,
        "pickup_longitude": pickupLongitude,
        "pickup_address": pickupAddress,
        "dropoff_latitude": dropoffLatitude,
        "dropoff_longitude": dropoffLongitude,
        "dropoff_address": dropoffAddress,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "currency": currency != null ? currency!.toJson() : null,
      };

  LatLng get pickupLatLng => LatLng(
        double.parse(pickupLatitude.toString()),
        double.parse(pickupLongitude.toString()),
      );
  LatLng get dropoffLatLng => LatLng(
        double.parse(dropoffLatitude.toString()),
        double.parse(dropoffLongitude.toString()),
      );
}
