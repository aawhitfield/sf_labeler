import 'dart:ui' as ui;

import 'package:another_brother/label_info.dart';
import 'package:another_brother/printer_info.dart' as brother;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sf_labeler/models/sales_force_contact.dart';

class PrintAPI {
  static Future<void> printContact(
      BuildContext context, SalesForceContact contact) async {
    // get Bluetooth permission
    if (!await Permission.bluetoothConnect.request().isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Access to bluetooth connect is needed in order print."),
        ),
      ));
      return;
    }

    if (!await Permission.bluetoothScan.request().isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Access to bluetooth scan is needed in order print."),
        ),
      ));
      return;
    }

    brother.Printer printer = brother.Printer();
    brother.PrinterInfo printInfo = brother.PrinterInfo();

    printInfo.printerModel = brother.Model.QL_1110NWB;
    printInfo.printMode = brother.PrintMode.FIT_TO_PAGE;
    printInfo.isAutoCut = true;
    printInfo.orientation = brother.Orientation.LANDSCAPE;
    printInfo.port = brother.Port.BLUETOOTH;
    printInfo.align = brother.Align.CENTER;

    // set the label type
    printInfo.labelNameIndex = QL1100.ordinalFromID(QL1100.W103H164.getId());

    // set the printer info so we can use the SDK to get the printers
    await printer.setPrinterInfo(printInfo);

    // Get a list of printers with my model available
    List<brother.BluetoothPrinter> printers = await printer
        .getBluetoothPrinters([brother.Model.QL_1110NWB.getName()]);

    if (printers.isEmpty) {
      // Show a message if no printers are found.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("No paired printers found on your device."),
        ),
      ));

      return;
    }

    // get the MAC address of the first printer
    printInfo.macAddress = printers.first.macAddress;

    printer.setPrinterInfo(printInfo);

    final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
    ))
      ..pushStyle(Theme.of(context).textTheme.headline4!.getTextStyle())
      ..addText('\n\n\n\n\n\n\n\n\n\n\n\n')
      ..addText(contact.name ?? '')
      ..addText('\n')
      ..addText(contact.mailingStreet ?? '')
      ..addText('\n')
      ..addText(
          ' ${contact.mailingCity ?? ''}, ${contact.mailingState ?? ''} ${contact.mailingPostalCode ?? ''}');

    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(
          width: MediaQuery.of(context).size.width - 12.0 - 12.0));

    await printer.printText(paragraph);
    return;
  }
}
