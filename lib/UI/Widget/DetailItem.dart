import 'package:factur/helpers/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailItem extends StatelessWidget {
  final String text;
  @required
  final Icon icon;
  final String title;
  const DetailItem({Key key, this.text = "", this.icon, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 8.0, left: 20),
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon,
            Text(title),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                text,
                style: GoogleFonts.lato(
                  color: Constants.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
