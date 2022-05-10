import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sf_labeler/models/business_card.dart';
import 'package:sf_labeler/models/sales_force_api.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/providers.dart';
import 'package:sf_labeler/secrets.dart';

class CovveAPI {
  static Future<SalesForceContact> processBusinessCardScan(
      BuildContext context, WidgetRef ref, File image) async {

    String fileName = image.path.split('/').last;

    Uint8List bytes = await image.readAsBytes();

    Response response;
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(bytes, filename: fileName),
    });
    response = await dio.post(
      'https://app.covve.com/api/businesscards/scan',
      options: Options(
        headers: {
          'Authorization': APIKeys.covve,
          'Content-Type': 'multipart/form-data',
        },
      ),
      data: formData,
      onSendProgress: (int sent, int total) {

        ref.read(selectedProvider).updateProgress(sent, total);
      },
    );

    Map<String, dynamic> responseMap = response.data;
    
    if (response.statusCode == 201 || response.statusCode == 200) {
      // multipart request doesn't return a response, but a streamedResponse so
      // we need to convert as per https://stackoverflow.com/a/55521892/4333051

      BusinessCard card = BusinessCard.fromMap(responseMap);
      SalesForceContact contact =
          SalesForceAPI.convertBusinessCardToContact(card);
      return contact;
    } else {
      debugPrint('${response.statusCode} $responseMap');
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: 'Error: ${response.statusCode} ${response.statusMessage}');
      throw Exception('Failed to create contact');
    }
  }
}
