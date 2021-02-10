import 'package:badges/badges.dart';
import 'package:factur/Models/User.dart';
import 'package:factur/Provider/MyHomePageProvider.dart';
import 'package:factur/UI/Screen/DetailPage.dart';
import 'package:factur/UI/Widget/AppBarFacture.dart';
import 'package:factur/helpers/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool visible = false;
  var _future;
  bool isSwitched = false;
  @override
  void initState() {
    _future = FlutterSession().get("userData");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return visible
        ? Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
                height: 200.0,
                width: 200.0,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBarFactre(),
            body: SingleChildScrollView(
              child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10, bottom: 10),
                          child: Text(
                            'Bonjour, ${snapshot.data["Nom"]}',
                            style: GoogleFonts.lato(
                              color: Constants.secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 10),
                          child: Text(
                            'Site : ${snapshot.data["site"]}',
                            style: GoogleFonts.lato(
                              color: Constants.secondaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        ChangeNotifierProvider<MyHomePageProvider>(
                          create: (context) => MyHomePageProvider(),
                          child: Consumer<MyHomePageProvider>(
                            builder: (context, provider, child) {
                              if (provider.data == null) {
                                provider.getData(
                                    context: context,
                                    token: snapshot.data["token"],
                                    idSite: snapshot.data["idSite"],
                                    filter: "0");
                                return Container(
                                  height: 50,
                                  child: Center(
                                      child: Container(
                                          child: SpinKitChasingDots(
                                              color: Constants.primaryColor,
                                              size: 20))),
                                );
                              }
                              if (provider.data.status != 200) {
                                return Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 100),
                                      Icon(Icons.error_outline,
                                          size: 100, color: Colors.red),
                                      Text('Bad request',
                                          style: TextStyle(fontSize: 25)),
                                    ],
                                  ),
                                );
                              }

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10, bottom: 10),
                                    child: isSwitched == false
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text('Vous avez '),
                                                Badge(
                                                    toAnimate: false,
                                                    shape: BadgeShape.square,
                                                    badgeColor:
                                                        Colors.deepPurple,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    badgeContent: Text(
                                                        '${provider.data.data.length}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                                Text(
                                                    '  véhicules en attente de livraison.'),
                                              ],
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text('Vous avez livré '),
                                                Badge(
                                                  toAnimate: false,
                                                  shape: BadgeShape.square,
                                                  badgeColor: Colors.deepPurple,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  badgeContent: Text(
                                                      '${provider.data.data.length}',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                                Text('  véhicules.'),
                                              ],
                                            ),
                                          ),
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
                                        activeColor: Colors.green,
                                        value: isSwitched,
                                        onChanged: (value) {
                                          setState(() {
                                            isSwitched = value;
                                            print(isSwitched);
                                            if (value == false) {
                                              provider.getData(
                                                  context: context,
                                                  token: snapshot.data["token"],
                                                  idSite:
                                                      snapshot.data["idSite"],
                                                  filter: "0");
                                            } else {
                                              provider.getData(
                                                  context: context,
                                                  token: snapshot.data["token"],
                                                  idSite:
                                                      snapshot.data["idSite"],
                                                  filter: "1");
                                            }
                                          });
                                        },
                                      ),
                                      Icon(Icons.verified_user,
                                          color: Colors.green),
                                    ],
                                  ),
                                  Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DataTable(
                                            showCheckboxColumn: false,
                                            sortAscending: true,
                                            sortColumnIndex: 0,
                                            columns: [
                                              DataColumn(label: Text('Statut')),
                                              DataColumn(label: Text('Marque')),
                                              DataColumn(
                                                  label: Text('N° Serie')),
                                            ],
                                            rows: provider.data.data
                                                .map((data) => DataRow.byIndex(
                                                        onSelectChanged:
                                                            (bool selected) {
                                                          print(
                                                              '${snapshot.data['iduser']}');
                                                          if (selected) {
                                                            setState(() {
                                                              visible = true;
                                                            });
                                                            if (data.status ==
                                                                "0") {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => DetailPage(
                                                                        token: snapshot.data[
                                                                            "token"],
                                                                        idSite: snapshot.data[
                                                                            'idSite'],
                                                                        numDelivery:
                                                                            data
                                                                                .numDelivery,
                                                                        dateFacture:
                                                                            data
                                                                                .dateFacture,
                                                                        numFacture:
                                                                            data
                                                                                .numFacture,
                                                                        numserie:
                                                                            data
                                                                                .numserie,
                                                                        idUser: snapshot.data[
                                                                            'iduser'],
                                                                        client:
                                                                            data.client)),
                                                              );
                                                            } else {
                                                              Scaffold.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18),
                                                                      side: BorderSide(
                                                                          color: Colors.yellow[
                                                                              600],
                                                                          width:
                                                                              1)),
                                                                  margin:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  // padding: EdgeInsets.all(20),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .yellow,
                                                                  content: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .info_outline,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          'le véhicule est déjà livré',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  action:
                                                                      SnackBarAction(
                                                                    textColor:
                                                                        Colors
                                                                            .black,
                                                                    label: 'X',
                                                                    onPressed:
                                                                        () {
                                                                      Scaffold.of(
                                                                              context)
                                                                          .removeCurrentSnackBar();
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            setState(() {
                                                              visible = false;
                                                            });
                                                          }
                                                        },
                                                        index: int.parse(
                                                            data.numDelivery),
                                                        cells: [
                                                          DataCell(
                                                            Icon(
                                                                data.status ==
                                                                        "0"
                                                                    ? Icons.info
                                                                    : Icons
                                                                        .verified_user,
                                                                color: data.status ==
                                                                        "0"
                                                                    ? Colors.deepOrange[
                                                                        400]
                                                                    : Colors
                                                                        .green),
                                                          ),
                                                          DataCell(
                                                              data.make != null
                                                                  ? Image.asset(
                                                                      'assets/image/marque/${data.make}.png',
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                    )
                                                                  : Icon(Icons
                                                                      .broken_image_outlined)
                                                              // Text(data.make),
                                                              ),
                                                          DataCell(
                                                            Text(data.numserie),
                                                          ),
                                                          // DataCell(
                                                          //   Text(data
                                                          //       .numFacture),
                                                          // ),
                                                          // DataCell(
                                                          //   Text(data
                                                          //       .dateFacture),
                                                          // ),
                                                        ]))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ]);
                },
              ),
            ),
          );
  }
}
