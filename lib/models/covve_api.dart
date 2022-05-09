import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sf_labeler/models/business_card.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:http_parser/http_parser.dart';

import 'package:sf_labeler/secrets.dart';

class CovveAPI {
  static Future<SalesForceContact> processBusinessCardScan(File image) async {
    String extension = image.path.split('.').last;
    String fileName = image.path.split('/').last;

    Uint8List bytes = await image.readAsBytes();

    // multipart request tutorial from https://stackoverflow.com/a/51813960/4333051 

    Uri postUri = Uri.parse('https://app.covve.com/api/businesscards/scan');
    http.MultipartRequest request = http.MultipartRequest('POST', postUri);

    request.headers.addAll({
      'Authorization': APIKeys.covve,
      'Content-Type': 'multipart/form-data',
    });
    request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: fileName, contentType: MediaType('image', extension)));

    http.StreamedResponse response = await request.send();
    String responseString = await response.stream.bytesToString();
    responseString = responseString.replaceAll('\\"', '"');
    if (response.statusCode == 201 || response.statusCode == 200) {
      // multipart request doesn't return a response, but a streamedResponse so 
      // we need to convert as per https://stackoverflow.com/a/55521892/4333051

      BusinessCard card = BusinessCard.fromJson(responseString);
      SalesForceContact contact =
          SalesForceAPI.convertBusinessCardToContact(card);
      return contact;
    } else {
      debugPrint('${response.statusCode} $responseString');
      throw Exception('Failed to create contact');
    }
  }
}
