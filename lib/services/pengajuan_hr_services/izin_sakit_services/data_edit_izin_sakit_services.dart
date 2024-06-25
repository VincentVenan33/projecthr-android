import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class DataEditIzinSakitHRService {
  final url = 'http://192.168.2.155:8000/ijin_sakit/hr/data_by_id';
  Dio dio = Dio();

  FutureOr<Map<String, dynamic>> dataEditIzinSakitHR(int id) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headerss = {"Authorization": 'Bearer $token'};
      final response = await dio.get(url,
          options: Options(
            headers: headerss,
          ),
          queryParameters: {
            'id_ijin': id,
          });
      final Map<String, dynamic> responseMap = response.data;

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('sukseesss');
        print(responseMap);
        return responseMap;
      } else {
        print('failed');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('Failed to fetch data');
  }
}
