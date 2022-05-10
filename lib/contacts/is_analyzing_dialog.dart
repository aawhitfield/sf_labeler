import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sf_labeler/models/covve_api.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/providers.dart';

class IsAnalyzingDialog extends ConsumerStatefulWidget {
  const IsAnalyzingDialog(this.imageFile, {Key? key}) : super(key: key);

  final File imageFile;

  @override
  ConsumerState<IsAnalyzingDialog> createState() => _IsPrintingDialogState();
}

class _IsPrintingDialogState extends ConsumerState<IsAnalyzingDialog> {
  SalesForceContact? contact;

  void getContact() async {
    contact =
        await CovveAPI.processBusinessCardScan(context, ref, widget.imageFile);
    Navigator.of(context).pop(contact);
  }

  @override
  void initState() {
    getContact();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int progress = ref.watch(selectedProvider).progress;
    return Center(
        child: Container(
      width: 256,
      height: 470,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pop(contact),
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Lottie.asset('assets/animations/analyze.json',
                width: 200, height: 300),
            Material(
              color: Colors.white,
              child: Text(
                (progress == 100) ? 'Analyzing text...' : 'Processing image...',
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),
            (progress == 100)? Container() : Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress / 100,
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  child: Text(
                    '$progress %',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ));
  }
}
