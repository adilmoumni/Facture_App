import 'package:factur/Models/User.dart';
import 'package:factur/UI/Screen/LoginPage.dart';
import 'package:factur/UI/Screen/searchPage.dart';
import 'package:factur/helpers/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarFactre extends StatefulWidget implements PreferredSizeWidget {
  //Bg Color = "primary " or "white" or "grey"
  final bool show;
  final UserData userData;

  AppBarFactre({
    Key key,
    this.show = false, this.userData,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AppBarFactreState createState() => _AppBarFactreState();
}

class _AppBarFactreState extends State<AppBarFactre> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.show,

      iconTheme: IconThemeData(color: Constants.primaryColor),
      // leading: IconButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   icon: Icon(
      //     Icons.arrow_back,
      //     color: Constants.primaryColor,
      //   ),
      // ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: SearchPage(widget.userData,));
          },
        ),
        IconButton(
          onPressed: () async {
            await FlutterSession().set("userData", "");
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          icon: Icon(
            Icons.logout,
            color: Constants.primaryColor,
          ),
        )
      ],
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        'Livraison',
        style: GoogleFonts.lato(
          color: Constants.primaryColor,
          fontSize: 25,
          fontWeight: FontWeight.w800,
        ),
        // style: TextStyle(
        //   color: Constants.primaryColor,
        //   fontWeight: FontWeight.w800,
        //   fontSize: 25,
        // ),
      ),
    );
  }
}
