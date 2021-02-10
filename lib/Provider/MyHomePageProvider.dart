import 'dart:convert';
import 'package:factur/Models/Facutre.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MyHomePageProvider extends ChangeNotifier {
  Facture data;
  String token;
  String idSite;
  Future getData1({context, token = "", idSite = "", filter = ""}) async {
    var url = "http://myautohall.ma/cpc/api/v2/delivery/invoices/" +
        idSite +
        "/" +
        token;

    // await Future.delayed(Duration(seconds: 1));
    // print(filter + "     this is a filter value ");
    var res = await http.get(url);
    var myJson = json.decode(res.body);
    this.data = Facture.fromJson(myJson);

    this.notifyListeners();
  }

  Future getData({context, token = "", idSite = "", filter = ""}) async {
    var url = "http://myautohall.ma/cpc/api/v2/delivery/invoices/" +
        idSite +
        "/" +
        token;

    // await Future.delayed(Duration(seconds: 1));
    // print(filter + "     this is a filter value ");
    var res = await http.get(url);
    var myJson = json.decode(res.body);
    this.data = Facture.fromJson(myJson);
    if (filter == "") {
      this.data.data = Facture.fromJson(myJson).data.toList();
    } else {
      this.data.data = Facture.fromJson(myJson)
          .data
          .where((element) => element.status == filter)
          .toList();
    }

    // this.data.data.where((element) => element.status == "1").toList();
    // this.data = Facture.fromJson(myJson);
    // this.data.data = this.data.data.where((element) => element.status == "1");
    this.notifyListeners();
  }
}
