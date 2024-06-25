import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class CutiTahunanConfirmServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/confirm';
  Dio dio = Dio();

  Future cutiTahunanConfirm(int id) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final response = await dio.patch(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {'id_ijin': id},
        data: {
          'id_ijin': id,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('success');
      } else {
        print('failed');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
