import 'dart:async';

import 'package:factur/Models/User.dart';
import 'package:factur/UI/Screen/homeListView.dart';
import 'package:factur/helpers/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingHome extends StatefulWidget {
  final bool loged;
  final UserData userData;
  // final String idsite;
  // final String token;
  // final String iduser;
  LoadingHome({Key key, this.loged = false, this.userData}) : super(key: key);

  @override
  LoadingHomeState createState() => LoadingHomeState();
}

class LoadingHomeState extends State<LoadingHome> {
  @override
  void initState() {
    print(widget.loged);
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeListView(userData: widget.userData),
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
