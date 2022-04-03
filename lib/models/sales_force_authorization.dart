// To parse this JSON data, do
//
//     final salesForceAuthorization = salesForceAuthorizationFromMap(jsonString);

import 'dart:convert';

class SalesForceAuthorization {
  SalesForceAuthorization({
    required this.accessToken,
    required this.signature,
    required this.scope,
    required this.instanceUrl,
    required this.tokenType,
    required this.issuedAt,
  });

  final String accessToken;
  final String signature;
  final String scope;
  final String instanceUrl;
  final String tokenType;
  final int issuedAt;

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
}
