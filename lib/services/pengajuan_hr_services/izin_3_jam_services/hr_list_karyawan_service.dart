import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class ListKaryawanService {
  final url = 'http://192.168.2.155:8000/user/hr/list';
  Dio dio = Dio();

  Future listKaryawan({
    required String? filterNama,
  }) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final queryparameters = {
        if (filterNama != null) 'filter_nama': filterNama,
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: queryparameters,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('failed to fetch data');
        return [];
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
      return [];
    }
  }
}
