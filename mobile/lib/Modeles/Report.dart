import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Report {
  final int id;
  final String name;
  final String date;
  final num unitAmount;
  final int quantity;
  final num totalAmount;
  final String createDate;
  final String state;
  final String image;
  Report(
      {@required this.id,
      @required this.name,
      this.date,
      this.unitAmount,
      this.quantity,
      this.totalAmount,
      this.createDate,
      @required this.state,
      this.image});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        id: json['id'] as int,
        name: json['name'] as String,
        date: json['date'] as String,
        unitAmount: json['unit_amount'] as num,
        quantity: json['quantity'] as int,
        totalAmount: json['total_amount'] as num,
        createDate: json['createDate'] as String,
        state: json['state'] as String,
        image: json['attachment'] as String);
  }
}
