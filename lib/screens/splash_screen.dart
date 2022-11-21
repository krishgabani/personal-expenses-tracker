import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 15,
            ),
            Image.asset(
              'assets/images/wallet.png',
              width: double.infinity,
              height: 170,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Redirect on Login Page.',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 25,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
