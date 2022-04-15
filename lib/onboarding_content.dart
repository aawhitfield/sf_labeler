import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sf_labeler/authorization.dart';

void _incrementCounter() {
  Get.to(() => const Authorization());
}

List<Widget> onBoardingContent(BuildContext context) {
  return [
    context.isPortrait ? const SizedBox(height: 32) : Container(),
    SizedBox(
      // shrink relative size of the animation image on tablets/desktop
      width: context.isPhone
          ? context.isPortrait
              ? Get.width
              : Get.width * 0.5
          : context.isPortrait
              ? Get.width * 0.75
              : Get.width * 0.35,
      child: Lottie.network(
          'https://assets2.lottiefiles.com/private_files/lf30_dotmkp93.json'),
    ),
    Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'salesforce Labeler',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                // larger font size on larger sized devices
                fontSize: (context.isPhone) ? 40 : 60,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Quickly print address shipping labels on a Brother printer for any of your Salesforce contacts.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  // larger font size on larger sized devices
                  fontSize: (context.isPhone) ? 14 : 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: _incrementCounter,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 64.0, right: 64.0, top: 12.0, bottom: 12.0),
              child: Text(
                'Get Started',
                // larger font size on larger sized devices
                style: (context.isPhone)
                    ? Theme.of(context).textTheme.headline6
                    : Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ],
      ),
    ),
  ];
}
