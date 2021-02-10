import 'package:factur/Models/User.dart';
import 'package:factur/helpers/constant.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visible = true;
  bool loading = false;

  var userName;
  var password;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Constants.fiveColor,
      // backgroundColor: Color.fromRGBO(8, 11, 44, 1),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 130),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(40)),
                  height: 130,
                  child: Image.asset(
                    "assets/image/factureHome.png",
                  ),
                ),
                Text(
                  'BIENVENUE',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: TextFormField(
                    onSaved: (value) => userName = value,
                    validator: (value) =>
                        value.isEmpty ? 'Merci de remplire le champs' : null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      labelText: "Matricule",
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  child: TextFormField(
                    onSaved: (value) => password = value,
                    validator: (value) =>
                        value.isEmpty ? 'Merci de remplire le champs' : null,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: '••••••••••••',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            visible = !visible;
                          });
                        },
                        icon: Icon(
                            visible ? Icons.visibility_off : Icons.visibility),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 15),
                //   child: Container(
                //     width: 300,
                //     child: Align(
                //       alignment: Alignment.bottomRight,
                //       child: Text(
                //         'Mot de passe oublier?',
                //         style: TextStyle(
                //           color: Constants.quatriemeColor,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
                    height: 50,
                    width: 300,
                    child: FlatButton(
                      shape: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          this._formKey.currentState.save();

                          setState(() {
                            loading = true;
                          });

                          // print(userName + "  " + password);

                          await User.userExist(
                            context: context,
                            userName: userName,
                            password: password,
                            key: _scaffoldKey,
                          );
                          setState(() {
                            loading = false;
                          });
                          // await Future.delayed(Duration(seconds: 3));
                          // Navigator.of(context).pushReplacement(
                          //   new MaterialPageRoute(
                          //     builder: (BuildContext context) => HomePage(),
                          //   ),
                          // );
                          // Scaffold.of(context).showSnackBar(SnackBar(
                          //   content: Text('Wrong password'),
                          // ));
                        }
                      },
                      child: !loading
                          ? Text(
                              'Se Connecter',
                              style: TextStyle(color: Colors.white),
                            )
                          : Container(
                              color: Colors.transparent,
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                backgroundColor: Colors.transparent,
                              )),
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
                // Text(
                //   'Somme Text',
                //   style: TextStyle(
                //     color: Constants.quatriemeColor,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
