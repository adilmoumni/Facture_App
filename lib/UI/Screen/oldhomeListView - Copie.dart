import 'dart:convert';

import 'package:factur/Models/Facutre.dart';
import 'package:factur/Models/User.dart';
import 'package:factur/UI/Screen/DetailPage.dart';
import 'package:factur/UI/Widget/AppBarFacture.dart';
import 'package:factur/helpers/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeListView extends StatefulWidget {
  final UserData userData;
  // final String idsite;
  // final String token;
  // final String iduser;
  HomeListView({Key key, this.userData}) : super(key: key);

  @override
  _HomeListViewState createState() => _HomeListViewState();
}

class _HomeListViewState extends State<HomeListView> {
  List<Data> lstFacture = new List();
  var token = "", nom = "", idSite = "", site = "", pagination;
  bool isSwitched = false;
  bool browsing = false;
  bool topPostion = false;

  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    pagination = 10;
    fetchFive();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchFive();
      }

      // if (_scrollController.offset >=
      //         _scrollController.position.maxScrollExtent &&
      //     !_scrollController.position.outOfRange) {
      //   setState(() {
      //     topPostion = true;
      //     print('is top');
      //   });
      // }

      if (_scrollController.offset <=
              _scrollController.position.minScrollExtent &&
          !_scrollController.position.outOfRange) {
        setState(() {
          topPostion = false;
          print('is bottom');
        });
      } else {
        setState(() {
          topPostion = true;
          print('is top');
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: topPostion == true
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInSine);
              },
              child: Icon(Icons.arrow_circle_up_rounded),
            )
          : null,
      appBar: AppBarFactre(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            pagination = 10;
            lstFacture.clear();
          });
          fetchFive();
          print('refrech ');
        },
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (_, __) => Divider(height: 2),
                  itemCount: lstFacture.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    print(lstFacture.length.toString());
                    if (lstFacture.length < 10) {
                      fetchFive();
                    }
                    if (index == 0) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '  Bonjour, ${widget.userData.nom}',
                                      style: GoogleFonts.lato(
                                        color: Constants.secondaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      '  Site : ${widget.userData.site}',
                                      style: GoogleFonts.lato(
                                        color: Constants.secondaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: Colors.deepOrange[400],
                                    ),
                                    Switch(
                                      activeTrackColor: Colors.green[300],
                                      activeColor: Colors.white,
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = !isSwitched;
                                          pagination = 10;
                                          lstFacture.clear();
                                          if (isSwitched == true) {
                                            fetchIsValid();
                                          } else {
                                            fetchNotValid();
                                          }
                                        });
                                      },
                                    ),
                                    Icon(Icons.verified_user,
                                        color: Colors.green),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 8, left: 10),
                              child: Row(
                                children: [
                                  Text('Status',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  SizedBox(width: 20),
                                  Text('Marque',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                  SizedBox(width: 20),
                                  Text('VIN',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == lstFacture.length && browsing == true) {
                      return CupertinoActivityIndicator(radius: 15);
                    }
                    if (index == lstFacture.length && browsing == false) {
                      print('this is the last porsiton ');
                      return Text('this is the last ');
                    }

                    return Slidable(
                      enabled: lstFacture[index].status == "1" ? false : true,
                      actionPane: SlidableDrawerActionPane(),
                      showAllActionsThreshold: 0.25,
                      secondaryActions: [
                        IconSlideAction(
                          caption: "Detail",
                          color: Colors.white,
                          icon: Icons.info_outline,
                          foregroundColor: Colors.deepOrange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  userData: widget.userData,
                                  client: lstFacture[index].client,
                                  numDelivery: lstFacture[index].numDelivery,
                                  numFacture: lstFacture[index].numFacture,
                                  numserie: lstFacture[index].numserie,
                                  dateFacture: lstFacture[index].dateFacture,
                                ),
                              ),
                            );
                          },
                        ),
                        IconSlideAction(
                          foregroundColor: Colors.green,
                          caption: "Valider",
                          color: Colors.white,
                          icon: Icons.check_sharp,
                          onTap: () {
                            Facture.deliveryUpdate(
                              iduser: widget.userData.iduser,
                              numdelivery: lstFacture[index].numDelivery,
                              status: "1",
                              token: widget.userData.token,
                              key: _scaffoldKey,
                              context: context,
                              pop: true,
                            );
                            setState(() {
                              lstFacture.removeAt(index);
                            });
                          },
                        ),
                      ],

                      // leading: lstFacture[index].status == "0"
                      //     ? Icon(Icons.info, color: Colors.orange[600])
                      //     : Icon(Icons.verified_user, color: Colors.green),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                lstFacture[index].status == "0"
                                    ? Icon(Icons.info,
                                        color: Colors.orange[600])
                                    : Icon(Icons.verified_user,
                                        color: Colors.green),
                                SizedBox(
                                  width: 30,
                                ),
                                Image.asset(
                                    "assets/image/marque/" +
                                        lstFacture[index].make +
                                        ".png",
                                    width: 35),
                                Text("       " + lstFacture[index].numserie),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  fetchNotValid() async {
    browsing = true;
    var url = "http://myautohall.ma/cpc/api/v2/delivery/invoices/" +
        widget.userData.idSite +
        "/" +
        widget.userData.token +
        "/" +
        pagination.toString();
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        var myJson = json.decode(response.body);
        lstFacture.addAll(Facture.fromJson(myJson)
            .data
            .where((element) => element.status == "0"));
      });
    } else {
      throw Exception('Failed to load ');
    }

    browsing = false;
  }

  fetchIsValid() async {
    browsing = true;
    try {
      var url = "http://myautohall.ma/cpc/api/v2/delivery/invoices/" +
          widget.userData.idSite +
          "/" +
          widget.userData.token;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          var myJson = json.decode(response.body);
          var lst = Facture.fromJson(myJson).data;
          if (lst != null) {
            lstFacture.addAll(lst.where((element) => element.status == "1"));
          }
        });
      } else {
        throw Exception('Failed to load ');
      }
    } catch (e) {}
    browsing = false;
  }

  fetchFive() async {
    print('is last');
    if (isSwitched == true) {
      fetchIsValid();
    } else {
      fetchNotValid();
    }
    setState(() {
      pagination = pagination + 10;
    });
  }
}
