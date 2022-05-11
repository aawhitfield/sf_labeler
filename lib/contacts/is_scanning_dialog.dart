import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sf_labeler/models/add_contact_api.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';
import 'package:sf_labeler/models/scan_api.dart';
import 'package:sf_labeler/providers.dart';

class IsScanningDialog extends ConsumerStatefulWidget {
  const IsScanningDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<IsScanningDialog> createState() => _IsPrintingDialogState();
}

class _IsPrintingDialogState extends ConsumerState<IsScanningDialog> {
  SalesForceContact? contact;

  void getContact() async {
    SalesForceContact? contact = await AddContactAPI.fromScanner(context, ref);
    Navigator.of(context).pop(contact);
  }

  @override
  Widget build(BuildContext context) {
    ScanStatus status = ref.watch(scanProvider).status;
    ScanApi scanApi = ref.watch(scanProvider);
    return Center(
        child: Container(
      width: 256,
      height: (status == ScanStatus.initial) ? 530 : 420,
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
            Lottie.asset(scanApi.animationUrl, width: 200, height: 250),
            Material(
              color: Colors.white,
              child: Text(
                scanApi.statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            (status == ScanStatus.initial)
                ? Column(
                    children: [
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          ref
                              .read(scanProvider)
                              .updateStatus(ScanStatus.searching);
                          getContact();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Scan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16))),
                        ),
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ));
  }
}
