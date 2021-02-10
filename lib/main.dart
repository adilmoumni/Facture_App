import 'package:factur/Models/User.dart';
import 'package:factur/UI/Screen/LoadingPage.dart';
import 'package:factur/UI/Screen/lodingHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

void main() {
  runApp(MyApp());  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Factures',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // primarySwatch: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: FlutterSession().get("userData"),
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data == "") {
            return LoadingScreen(
              loged: false,
              // token: snapshot.data['token'],
              // idsite: snapshot.data['idSite'],
              // iduser: snapshot.data['iduser'],
            );
          } else {
            print(snapshot.data['nom'].toString());

            return LoadingHome(
              userData: UserData(
                iduser: snapshot.data['iduser'],
                idProfile: snapshot.data['idProfile'],
                idSite: snapshot.data['idSite'],
                nom: snapshot.data['Nom'],
                site: snapshot.data['site'],
                token: snapshot.data['token'],
              ),
              // token: snapshot.data['token'],
              // idsite: snapshot.data['idSite'],
              // iduser: snapshot.data['iduser'],
            );
          }
        },
      ),
    );
  }
}
