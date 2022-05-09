// To parse this JSON data, do
//
//     final businessCard = businessCardFromMap(jsonString);

import 'dart:convert';

class BusinessCard {
  BusinessCard({
    this.language,
    this.id,
    this.firstName,
    this.lastName,
    this.middleName,
    this.emails,
    this.phones,
    this.jobs,
    this.websites,
    this.notes,
    this.addresses,
  });

  String? language;
  String? id;
  String? firstName;
  String? lastName;
  String? middleName;
  List<Email>? emails;
  List<Phone>? phones;
  List<Job>? jobs;
  List<Website>? websites;
  String? notes;
  List<Address>? addresses;

  factory BusinessCard.fromJson(String str) =>
      BusinessCard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BusinessCard.fromMap(Map<String, dynamic> json) => BusinessCard(
        language: json["language"],
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        middleName: json["middleName"],
        emails: json["emails"] == null
            ? null
            : List<Email>.from(json["emails"].map((x) => Email.fromMap(x))),
        phones: json["phones"] == null
            ? null
            : List<Phone>.from(json["phones"].map((x) => Phone.fromMap(x))),
        jobs: json["jobs"] == null
            ? null
            : List<Job>.from(json["jobs"].map((x) => Job.fromMap(x))),
        websites: json["websites"] == null
            ? null
            : List<Website>.from(
                json["websites"].map((x) => Website.fromMap(x))),
        notes: json["notes"],
        addresses: json["addresses"] == null
            ? null
            : List<Address>.from(
                json["addresses"].map((x) => Address.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "language": language,
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "middleName": middleName,
        "emails": emails == null
            ? null
            : List<dynamic>.from(emails!.map((x) => x.toMap())),
        "phones": phones == null
            ? null
            : List<dynamic>.from(phones!.map((x) => x.toMap())),
        "jobs": jobs == null
            ? null
            : List<dynamic>.from(jobs!.map((x) => x.toMap())),
        "websites": websites == null
            ? null
            : List<dynamic>.from(websites!.map((x) => x.toMap())),
        "notes": notes,
        "addresses": addresses == null
            ? null
            : List<dynamic>.from(addresses!.map((x) => x.toMap())),
      };
}

class Address {
  Address({
    this.fullAddress,
    this.parsedAddress,
  });

  String? fullAddress;
  dynamic parsedAddress;

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        fullAddress: json["fullAddress"],
        parsedAddress: json["parsedAddress"],
      );

  Map<String, dynamic> toMap() => {
        "fullAddress": fullAddress,
        "parsedAddress": parsedAddress,
      };
}

class Email {
  Email({
    this.address,
  });

  String? address;

  factory Email.fromJson(String str) => Email.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Email.fromMap(Map<String, dynamic> json) => Email(
        address: json["address"],
      );

  Map<String, dynamic> toMap() => {
        "address": address,
      };
}

class Job {
  Job({
    this.company,
    this.title,
  });

  String? company;
  String? title;

  factory Job.fromJson(String str) => Job.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Job.fromMap(Map<String, dynamic> json) => Job(
        company: json["company"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "company": company,
        "title": title,
      };
}

class Phone {
  Phone({
    this.number,
  });

  String? number;

  factory Phone.fromJson(String str) => Phone.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Phone.fromMap(Map<String, dynamic> json) => Phone(
        number: json["number"],
      );

  Map<String, dynamic> toMap() => {
        "number": number,
      };
}

class Website {
  Website({
    this.url,
  });

  String? url;

  factory Website.fromJson(String str) => Website.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Website.fromMap(Map<String, dynamic> json) => Website(
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
      };
}
