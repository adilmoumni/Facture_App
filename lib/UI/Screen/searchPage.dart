import 'dart:convert';

import 'package:factur/Models/Facutre.dart';
import 'package:factur/Models/User.dart';
import 'package:factur/UI/Screen/DetailPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends SearchDelegate<String> {
  // List<Data> lstFacture = new List();
  final UserData userData;

  SearchPage(this.userData);

  fetch() async {
    try {
      var url = "http://myautohall.ma/cpc/api/v2/delivery/invoices/search/" +
          userData.idSite +
          "/" +
          userData.token +
          "/0/" +
          query;

      final response = await http.get(url);
      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);
        return Facture.fromJson(myJson);
      } else {
        throw Exception('Failed to load ');
      }
    } catch (e) {}
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    fetch();

    return FutureBuilder(
        future: fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (query == '' || query == null) {
            return Text('');
          }
          if (snapshot.hasError) {
            return Text('');
          }

          if (snapshot.hasData) {
            if (snapshot.data.status == 400) {
              return Center(child: Text('Aucune donnée disponible'));
            }
            return ListView.separated(
              itemCount: snapshot.data.data.length,
              separatorBuilder: (_, __) => Divider(height: 2),
              itemBuilder: (BuildContext context, int index) {
                fetch();
                return InkWell(
                  onTap: () {
                    if (snapshot.data.data[index].status == "0") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            userData: userData,
                            client: snapshot.data.data[index].client,
                            numDelivery: snapshot.data.data[index].numDelivery,
                            numFacture: snapshot.data.data[index].numFacture,
                            numserie: snapshot.data.data[index].numserie,
                            dateFacture: snapshot.data.data[index].dateFacture,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        snapshot.data.data[index].status == "0"
                            ? Icon(Icons.info, color: Colors.orange[600])
                            : Icon(Icons.verified_user, color: Colors.green),
                        SizedBox(
                          width: 30,
                        ),
                        Image.asset(
                            "assets/image/marque/" +
                                snapshot.data.data[index].make +
                                ".png",
                            width: 35),
                        Text("       " + snapshot.data.data[index].numserie),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }
}
