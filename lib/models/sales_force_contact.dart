// To parse this JSON data, do
//
//     final salesForceContact = salesForceContactFromMap(jsonString);

import 'dart:convert';

class SalesForceContact {
  SalesForceContact({
    this.attributes,
    this.id,
    this.name,
    this.mailingStreet,
    this.mailingCity,
    this.mailingState,
    this.mailingPostalCode,
    this.photoUrl,
  });

  final Attributes? attributes;
  final String? id;
  final String? name;
  final String? mailingStreet;
  final String? mailingCity;
  final String? mailingState;
  final String? mailingPostalCode;
  final String? photoUrl;

  factory SalesForceContact.fromJson(String str) => SalesForceContact.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SalesForceContact.fromMap(Map<String, dynamic> json) => SalesForceContact(
    attributes: json["attributes"] == null ? null : Attributes.fromMap(json["attributes"]),
    id: json["Id"],
    name: json["Name"],
    mailingStreet: json["MailingStreet"],
    mailingCity: json["MailingCity"],
    mailingState: json["MailingState"],
    mailingPostalCode: json["MailingPostalCode"],
    photoUrl: json["PhotoUrl"],
  );

  Map<String, dynamic> toMap() => {
    "attributes": attributes?.toMap(),
    "Id": id,
    "Name": name,
    "MailingStreet": mailingStreet,
    "MailingCity": mailingCity,
    "MailingState": mailingState,
    "MailingPostalCode": mailingPostalCode,
    "PhotoUrl": photoUrl,
  };
}

class Attributes {
  Attributes({
    this.type,
    this.url,
  });

  final String? type;
  final String? url;

  factory Attributes.fromJson(String str) => Attributes.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
    type: json["type"],
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "type": type,
    "url": url,
  };
}
