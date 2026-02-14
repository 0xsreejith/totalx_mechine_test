import 'package:flutter/material.dart';

class PhoneIllustration extends StatelessWidget {
  const PhoneIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset(
          'assets/images/OBJECTS.png',
          height: 150,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.phone_android_rounded,
                size: 80,
                color: Colors.blue.shade300,
              ),
            );
          },
        ),
      ),
    );
  }
}
