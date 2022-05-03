import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:sf_labeler/providers.dart';

class IsUpdatingDialog extends ConsumerStatefulWidget {
  const IsUpdatingDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<IsUpdatingDialog> createState() => _IsPrintingDialogState();
}

class _IsPrintingDialogState extends ConsumerState<IsUpdatingDialog> {
  @override
  void initState() {
    ref.read(selectedProvider).addListener(() {
      if (!ref.read(selectedProvider).isUpdating) {
        Navigator.of(context).pop();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Lottie.asset('assets/animations/refresh.json',
                width: 200, height: 325),
            const Material(
              color: Colors.white,
              child: Text(
                'Updating contact...',
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ));
  }
}
