import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'District.dart';

class Services {
  static const ROOT = "http://localhost/EXEMPTION_KODAGU/exemption.php";

  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  static const _ADD_DISTRICT_ACTION = 'ADD_DISTRICT';

  static Future<String> createTable() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_ACTION;
      final response = await http.post(Uri.parse(ROOT), body: map);
      print('Create table District: ${response.body}');
      return response.body;
    } catch (e) {
      log(e);
    }
  }

  static Future<List<District>> getDistrict() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      log('in getDistrict');
      final response = await http.post(Uri.parse(ROOT), body: map);
      log('in getDistrict 1');
      print('Get details : ${response.body}');
      if (200 == response.statusCode) {
        List<District> list = parseResponse(response.body);
        log('Returns getDist:$list');
        return list;
      } else {
        return <District>[];
      }
    } catch (e) {
      return <District>[];
      // print(e);
    }
  }

  static List<District> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<District>((json) => District.fromJson(json)).toList();
  }

  static Future<String> addDistrict(String dist_id, String dist_name) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _ADD_DISTRICT_ACTION;
      map['dist_id'] = dist_id;
      map['dist_name'] = dist_name;
      log(dist_id);

      final response = await http.post(Uri.parse(ROOT), body: map);
      // print('addDistrict response: ${response.body}');
      String v = response.statusCode.toString();
      log('Response string :$v');
      if (200 == response.statusCode) {
        getDistrict();
        return response.body;
      } else {
        return "Error adding districts";
      }
    } catch (e) {
      log('Exception :$e');
      getDistrict();
      return "Something went wrong";
    }
  }
}
