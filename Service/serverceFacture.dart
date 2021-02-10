import 'dart:convert';

import 'package:factur/Models/Facutre.dart';
import 'package:http/http.dart' as http;

class ServiceFacutre {
  static const String url = '';

  static getFacture() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var myJson = json.decode(response.body);

        var data = Facture.fromJson(myJson);
        return data;
        
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
