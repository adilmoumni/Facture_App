import 'package:connectivity/connectivity.dart';
import 'package:factur/UI/Screen/homeListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  UserData userData;

  User({this.userData});

  User.fromJson(Map<String, dynamic> json) {
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['userData'] = this.userData.toJson();
    }
    return data;
  }

  static userExist(
      {String userName,
      String password,
      BuildContext context,
      GlobalKey<ScaffoldState> key}) async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        key.currentState.showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.yellow[600], width: 1)),
            margin: EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            // padding: EdgeInsets.all(20),
            backgroundColor: Colors.yellow,
            content: Row(
              children: [
                Icon(
                  Icons.signal_cellular_connected_no_internet_4_bar_rounded,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    'Téléphone non connecté',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              textColor: Colors.black,
              label: 'X',
              onPressed: () {
                Scaffold.of(context).removeCurrentSnackBar();
              },
            ),
          ),
        );
      } else {
        var url = "http://myautohall.ma/cpc/api/v2/login";
        var data = {
          'username': userName,
          'password': password,
        };
        var res = await http.post(url, body: data);

        var myJson = json.decode(res.body);

        User findUser = User.fromJson(myJson);
        // print(userSuccess.userData);

        if (findUser.userData != null) {
          UserData userData = findUser.userData;
          await FlutterSession().set("userData", userData);
          await FlutterSession().set("token", findUser.userData.idSite);
          // await FlutterSession().set("idUser", )
          // todo : REMOVE THIS IF THE HOME SCREEN IS GOOD
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomePage(user: findUser)),
          // );
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeListView(userData: userData)),
          );
          print("Existe");
        } else {
          print("MDP IS NOT VALABLE");
          key.currentState.showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.red[600], width: 1)),
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
              // padding: EdgeInsets.all(20),
              backgroundColor: Colors.red,
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      'Matricule / Mot de Passe incorrecte ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'X',
                onPressed: () {
                  Scaffold.of(context).removeCurrentSnackBar();
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }

    // return User.jsonDecodUser(myJson);
  }
}

class UserData {
  String iduser;
  String nom;
  String idSite;
  String idProfile;
  String token;
  String site;
  UserData(
      {this.iduser,
      this.nom,
      this.idSite,
      this.idProfile,
      this.token,
      this.site});

  UserData.fromJson(Map<String, dynamic> json) {
    iduser = json['iduser'];
    nom = json['Nom'];
    idSite = json['idSite'];
    idProfile = json['idProfile'];
    token = json['token'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iduser'] = this.iduser;
    data['Nom'] = this.nom;
    data['idSite'] = this.idSite;
    data['idProfile'] = this.idProfile;
    data['token'] = this.token;
    data['site'] = this.site;
    return data;
  }
}
