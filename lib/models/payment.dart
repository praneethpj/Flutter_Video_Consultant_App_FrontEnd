import 'dart:convert';

Payment jsontoPaymentModel(String str) => Payment.fromJson(json.decode(str));

class Payment {
  final int id;
  final int userId;
  final int clientId;
  final String paypaltoken;
  final DateTime dateval;
  final String time;
  final dynamic userfee;
  final double taxfee;
  final double platformfee;
  final double totalfee;
  final int paymentstatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment({
    required this.id,
    required this.userId,
    required this.clientId,
    required this.paypaltoken,
    required this.dateval,
    required this.time,
    required this.userfee,
    required this.taxfee,
    required this.platformfee,
    required this.totalfee,
    required this.paymentstatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as int,
      userId: json['userId'] as int,
      clientId: json['clientId'] as int,
      paypaltoken: json['paypaltoken'] as String,
      dateval: DateTime.parse(json['dateval'] as String),
      time: json['time'] as String,
      userfee: json['userfee'],
      taxfee: json['taxfee'] as double,
      platformfee: json['platformfee'] as double,
      totalfee: json['totalfee'] as double,
      paymentstatus: json['paymentstatus'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'clientId': clientId,
      'paypaltoken': paypaltoken,
      'dateval': dateval.toIso8601String(),
      'time': time,
      'userfee': userfee,
      'taxfee': taxfee,
      'platformfee': platformfee,
      'totalfee': totalfee,
      'paymentstatus': paymentstatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
