import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:project/services/pref_helper.dart';

class getDataKaryawanCutiServices {
  final url = 'http://192.168.2.155:8000/user/hr/list';
  Dio dio = Dio();

  Future getDatakaryawanCutiList({
    required String? filterNama,
  }) async {
    try {
      final tokenRespons = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenRespons);
      final token = tokenJson['access_token'];
      final headerss = {
        "Authorization": 'Bearer $token',
      };
      final queryparameters = {
        if (filterNama != null) 'filter_nama': filterNama,
      };
      final response = await dio.get(
        url,
        options: Options(
          headers: headerss,
        ),
        queryParameters: queryparameters,
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.data);
        return response.data;
      } else {
        print('failed to fetch data');
      }
    } on DioError catch (e) {
      print(e);
    }
  }
}
