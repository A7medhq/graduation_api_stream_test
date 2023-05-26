import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:graduation/api/api_setting.dart';
import 'package:graduation/models/api_response.dart';
import 'package:http/http.dart' as http;

class PatientAuthApiController {
  Future<ApiResponse> patientSignUp({
    required String firstName,
    required String lastName,
    required String email,
    required String pass,
  }) async {
    Uri uri = Uri.parse(
        'http://ac7a1ae098-001-site1.etempurl.com/api/patient/SignUp');
    http.Response response = await http.post(uri, body: {
      "FirstName": firstName,
      "LastName": lastName,
      "Email": email,
      "Password": pass
    });
    var json = jsonDecode(response.body);
    print(json);

    if (response.statusCode == 200 || response.statusCode == 400) {
      print('${response.statusCode}');
      // var json = jsonDecode(response.body);
      print(json);
      // Doctor doctor = Doctor.fromJson(json);
      return ApiResponse('Signup Successfully', true);
      // return ApiResponse(json['message'], json['isValid']);
    }
    return ApiResponse('something went wrong', false);
  }
}