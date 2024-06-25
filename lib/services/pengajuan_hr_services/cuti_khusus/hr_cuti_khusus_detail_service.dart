import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../pref_helper.dart';

class HRDetailCutiKhususService {
  final url = 'http://192.168.2.155:8000/cuti_khusus/hr/data_by_id';
  Dio dio = Dio();

  FutureOr<Map<String, dynamic>> hrdetailCutikhusus(int id) async {
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

      final Map<String, dynamic> responseMap = response.data;

      debugPrint('${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Succes!!!');
        return responseMap;
      } else {
        debugPrint('Failed!!!');
      }
    } on DioError catch (e) {
      debugPrint('${e.error}');
      debugPrint(e.message);
      debugPrint('${e.response}');
    }
    throw Exception('Failed to fetch data');
  }
}
