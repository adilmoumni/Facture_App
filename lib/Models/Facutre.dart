import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Facture {
  int status;
  List<Data> data;

  Facture({this.status, this.data});

  Facture.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static deliveryUpdate({
    String iduser,
    String numdelivery,
    String status,
    String token,
    GlobalKey<ScaffoldState> key,
    BuildContext context,
    bool pop = false,
  }) async {
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
        var url = "http://myautohall.ma/cpc/api/v2/delivery/update";
        var data = {
          'iduser': iduser,
          'numdelivery': numdelivery,
          'status': status,
          'token': token
        };
        var res = await http.post(url, body: data);

        var myJson = json.decode(res.body);

        var statutAPI = myJson['status'];

        print(iduser +
            " - " +
            numdelivery +
            "  " +
            status +
            "  " +
            token +
            "   " +
            statutAPI.toString());

        if (statutAPI == 201) {
          key.currentState.showSnackBar(
            SnackBar(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(color: Colors.green[600], width: 1)),
              margin: EdgeInsets.all(10),
              behavior: SnackBarBehavior.floating,
              // padding: EdgeInsets.all(20),
              backgroundColor: Colors.green,
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Text(
                      'Véhicule Livré',
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
          // Navigator.pop(context);
          if (pop == false) {
            await Future.delayed(Duration(seconds: 1));
            Navigator.of(context).pop();
          }

          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => HomeListView()));
        } else {}

        return;
      }
    } catch (e) {
      key.currentState.showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.red[600], width: 1)),
          margin: EdgeInsets.all(10),
          behavior: SnackBarBehavior.floating,
          // padding: EdgeInsets.all(20),
          content: Row(children: [
            Icon(Icons.info_outline_rounded, color: Colors.white),
            Expanded(
                child: Text(
                    'Une erreur est survenue merci de reessayer plus tard ',
                    style: TextStyle(color: Colors.white))),
          ]),
          action: SnackBarAction(
              textColor: Colors.white,
              label: 'X',
              onPressed: () {
                Scaffold.of(context).removeCurrentSnackBar();
              }),
        ),
      );
      await Future.delayed(Duration(seconds: 1));
    }
  }
}

class Data {
  String numDelivery;
  String numserie;
  String numFacture;
  String dateFacture;
  String status;
  String make;
  String client;
  Data(
      {this.numDelivery,
      this.numserie,
      this.numFacture,
      this.dateFacture,
      this.status,
      this.make,
      this.client});

  Data.fromJson(Map<String, dynamic> json) {
    numDelivery = json['numDelivery'];
    numserie = json['numserie'];
    numFacture = json['numFacture'];
    dateFacture = json['dateFacture'];
    status = json['status'];
    make = json['make'];
    client = json['client'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['numDelivery'] = this.numDelivery;
    data['numserie'] = this.numserie;
    data['numFacture'] = this.numFacture;
    data['dateFacture'] = this.dateFacture;
    data['status'] = this.status;
    data['make'] = this.make;
    data['client'] = this.client;
    return data;
  }
}
