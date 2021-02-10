import 'dart:core';

import 'package:factur/Models/Facutre.dart';
import 'package:factur/Models/User.dart';
import 'package:factur/UI/Widget/AppBarFacture.dart';
import 'package:factur/UI/Widget/DetailItem.dart';
import 'package:factur/helpers/constant.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  DetailPage(
      {Key key,
      this.userData,
      this.numDelivery,
      this.numserie,
      this.numFacture,
      this.dateFacture,
      this.token,
      this.idSite,
      this.idUser,
      this.client})
      : super(key: key);

  final UserData userData;
  final String numDelivery;
  final String numserie;
  final String numFacture;
  final String dateFacture;
  final String token;
  final String idSite;
  final String idUser;
  final String client;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool checked;
  @override
  void initState() {
    checked = false;

    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBarFactre(
        show: true,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              decoration: BoxDecoration(
                color: Constants.fiveColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 45,
                      child: Row(children: [
                        Expanded(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Icon(
                                checked == false
                                    ? Icons.info_outlined
                                    : Icons.verified_user,
                                color: checked == false
                                    ? Colors.deepOrange
                                    : Colors.green,
                              ),
                              Text('  INFO',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]))
                      ])),
                  DetailItem(
                      title: " Client",
                      text: widget.client,
                      icon: Icon(Icons.person)),
                  Divider(),
                  DetailItem(
                      title: " N° Facture",
                      text: widget.numFacture,
                      icon: Icon(Icons.confirmation_num_rounded)),
                  Divider(),
                  DetailItem(
                      title: " Date Facture",
                      text: widget.dateFacture,
                      icon: Icon(Icons.date_range_rounded)),
                  Divider(),
                  DetailItem(
                      title: " N° Serie",
                      text: widget.numserie,
                      icon: Icon(Icons.format_list_numbered_rounded)),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: checked,
                        onChanged: (value) {
                          setState(() {
                            checked = value;
                          });
                        },
                      ),
                      Text('Signaler livraison'),
                    ],
                  )
                ],
              ),
            ),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            onPressed: () {
              if (checked == true) {
                Facture.deliveryUpdate(
                    iduser: widget.userData.iduser,
                    numdelivery: widget.numDelivery,
                    status: "1",
                    token: widget.userData.token,
                    key: _scaffoldKey,
                    context: context);
              }
            },
            color: Constants.troisiemeColor,
            child: Text(
              'Valider',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      )),
    );
  }
}
