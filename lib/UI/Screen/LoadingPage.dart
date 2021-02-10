import 'dart:async';

import 'package:factur/UI/Screen/LoginPage.dart';
import 'package:factur/helpers/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  final bool loged;
  // final String token;
  // final String idsite;
  // final String iduser;

  LoadingScreen({Key key, this.loged = false}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    print(widget.loged);
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              "assets/image/factureHome.png",
              fit: BoxFit.fitHeight,
              height: 150,
            ),
          ),
          SizedBox(
            height: 150,
          ),
          Container(
            height: 20,
            child: SpinKitChasingDots(
              color: Constants.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
