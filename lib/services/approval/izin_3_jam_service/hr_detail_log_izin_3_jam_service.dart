import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class HrDetailLogIzin3JamService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/log';
  Dio dio = Dio();

  Future hrDetailLogIzin3Jam(int id) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: queryParameters,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('masok pak');
        return response.data;
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
