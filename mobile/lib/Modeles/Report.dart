import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Report {
  final int id;
  final String name;
  final String date;
  final double unitAmount;
  final int quantity;
  final double totalAmount;
  final String createDate;
  final String state;
  Report({
    @required this.id,
    @required this.name,
    this.date,
    this.unitAmount,
    this.quantity,
    this.totalAmount,
    this.createDate,
    @required this.state,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
        id: json['id'] as int,
        name: json['name'] as String,
        date: json['date'] as String,
        unitAmount: json['unit_amount'] as double,
        quantity: json['quantity'] as int,
        totalAmount: json['total_amount'] as double,
        createDate: json['createDate'] as String,
        state: json['state'] as String);
  }
}
