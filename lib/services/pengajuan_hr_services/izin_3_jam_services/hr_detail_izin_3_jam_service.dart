import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class DataDetailIzin3JamHRService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/hr/data_by_id';
  Dio dio = Dio();

  FutureOr<Map<String, dynamic>> dataDetailIzin3JamHR(int id) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id_ijin': id,
        },
      );

      print('status code EDIT : ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = response.data;
        print('sukses ngab');
        return responseMap;
      } else {
        print('gagal ngab');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('Failed to fetch data');
  }
}
