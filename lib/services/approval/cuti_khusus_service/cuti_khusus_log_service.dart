import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../pref_helper.dart';

class CutiKhususLogService {
  final url = 'http://192.168.2.155:8000/cuti_khusus/log';
  Dio dio = Dio();

  Future cutiKhususLog(int id) async {
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
      debugPrint('${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('Succes!!!');
        return response.data;
      }
    } on DioError catch (e) {
      debugPrint('${e.error}');
      debugPrint('${e.message}');
      debugPrint('${e.response}');
    }
  }
}
