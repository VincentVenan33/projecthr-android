import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class GetPerusahaanIzin3JamService {
  final url = 'http://192.168.2.155:8000/perusahaan/list';
  Dio dio = Dio();

  Future getPerusahaanIzin3Jam() async {
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
      );

      print('STATUS IZIN 3 JAM: ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('failed to fetch data');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
