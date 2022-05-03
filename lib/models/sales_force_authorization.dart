// To parse this JSON data, do
//
//     final salesForceAuthorization = salesForceAuthorizationFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

class SalesForceAuthorization extends ChangeNotifier{
  SalesForceAuthorization({
    required this.accessToken,
    required this.signature,
    required this.scope,
    required this.instanceUrl,
    required this.tokenType,
    required this.issuedAt,
  });

  String accessToken;
  String signature;
  String scope;
  String instanceUrl;
  String tokenType;
  int issuedAt;

  factory SalesForceAuthorization.fromJson(String str) => SalesForceAuthorization.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesForceAuthorization.fromMap(Map<String, dynamic> json) => SalesForceAuthorization(
    accessToken: json["access_token"],
    signature: json["signature"],
    scope: json["scope"],
    instanceUrl: json["instance_url"],
    tokenType: json["token_type"],
    issuedAt: int.parse(json["issued_at"]),
  );

  Map<String, dynamic> toMap() => {
    "access_token": accessToken,
    "signature": signature,
    "scope": scope,
    "instance_url": instanceUrl,
    "token_type": tokenType,
    "issued_at": issuedAt,
  };

  void saveNewAuthorization(SalesForceAuthorization authorization) {
    accessToken = authorization.accessToken;
    signature = authorization.signature;
    scope = authorization.scope;
    instanceUrl = authorization.instanceUrl;
    tokenType = authorization.tokenType;
    issuedAt = authorization.issuedAt;
    notifyListeners();
  }
}
