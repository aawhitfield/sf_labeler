import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:sf_labeler/contacts_list.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(),
      body: InAppWebView(
        key: webViewKey,
        initialOptions: InAppWebViewGroupOptions(android: AndroidInAppWebViewOptions(useHybridComposition: true)),
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9riCAn8HHkYUeNXLeHjXdlW6ncpfGaKj4DNJysxBFIV.D.EavXpNaBy9MdAebmTZgqm9OkzKBC0n0HSfW&redirect_uri=https://us-central1-sf-labeler.cloudfunctions.net/oauth")),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStop: (controller, url) async {
          if (url!.toString().contains('code')) {
            // https://stackoverflow.com/a/62168577/4333051
            // if JavaScript is enabled, you can use
            String html = await controller.evaluateJavascript(
                source:
                    "window.document.body.innerText");

            SalesForceAuthorization salesForceAuthorization = SalesForceAuthorization.fromJson(html);
            Get.offAll(() => ContactsList(salesForceAuthorization));
          }
        },
      ),
    );
  }
}
