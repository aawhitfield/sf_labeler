import 'package:custom_widgets/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:sf_labeler/contacts/contacts_list.dart';
import 'package:sf_labeler/models/sales_force_authorization.dart';
import 'package:sf_labeler/providers.dart';

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  State<Authorization> createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    return const CustomPlatformScaffold(
      title: Text('Sign into Salesforce'),
      child: SalesForceLogin(),
    );
  }
}

class SalesForceLogin extends ConsumerStatefulWidget {
  const SalesForceLogin({Key? key}) : super(key: key);

  @override
  ConsumerState<SalesForceLogin> createState() => _SalesForceLoginState();
}

class _SalesForceLoginState extends ConsumerState<SalesForceLogin> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      key: webViewKey,
      initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(useHybridComposition: true)),
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
              source: "window.document.body.innerText");

          SalesForceAuthorization salesForceAuthorization =
              SalesForceAuthorization.fromJson(html);
          ref
              .read(authorizationProvider)
              .saveNewAuthorization(salesForceAuthorization);
          Get.offAll(() => ContactsList(salesForceAuthorization));
        }
      },
    );
  }
}
