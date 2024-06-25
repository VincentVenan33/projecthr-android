import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../pref_helper.dart';

class DetailApprovalCutiTahunanServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/hr/data_by_id';
  Dio dio = Dio();

  FutureOr<Map<String, dynamic>> detailApprovalCutiTahunan(int id) async {
    try {
      final tokenResponse = await PrefHelper().getToken() ?? '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {"Authorization": 'Bearer $token'};

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id_ijin': id,
        },
      );

      print('status code Edit : ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = response.data;
        print('success');
        return responseMap;
      } else {
        print('failed');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('failed to fetch data');
  }
}
